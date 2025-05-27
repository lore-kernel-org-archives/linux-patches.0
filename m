Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171E527BF79;
	Tue, 27 May 2025 17:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367253; cv=none; b=XM8ypM7Rc6ociHCcSjiu8mxqTzvT0oKRolo3J6Z/A/VKf10A8cnb2YPDUAe9blkDbq5Hmb4RYa/647SWAUaP7AdvFw0ai56lRrJ1gYdYo9g+sdHbb/bKs7QYXps953E/A+LRhn9ogr7Htc0mhKXrmx/nG0eS+DKPmVoBF0pqSBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367253; c=relaxed/simple;
	bh=KBsDlHyHQrpkeEt/0eQEs+oSNqAyOyLt3sRvxIxaHqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElhkuxP2pdXb7/fq/BewRrsUPYLQEh1QPCk+VnB2y7WuxphSpmz6houBaQDFEZf7Wqw8OoeLlRc4lRybA738VP53RlxMcx5kRMKj+pg3gcT8rbptfkDm42ETA8VirTtemR/9+kOBFRSi5rApz5bJQ1RaP4SO7pIWglkTSwyNBNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhrP7MHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhrP7MHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7714DC4CEE9;
	Tue, 27 May 2025 17:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367253;
	bh=KBsDlHyHQrpkeEt/0eQEs+oSNqAyOyLt3sRvxIxaHqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhrP7MHQrj1wYqxIn0/J4Yd4AQro5nSzUILP/3Nlx3WhWL3ucQpAzxcGQspr2o0b+
	 yPaceGQgs3C6ZzBkPvP1GZizvv46SrEnaoxNh/pW9vphGpbZEiKQk0yIg6UjtX387w
	 a5ti5OhOcSGM3ha4vGO3csVfUWOEDXlx1xUVw5IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Wajdeczko?= <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 328/783] drm/xe/vf: Retry sending MMIO request to GUC on timeout error
Date: Tue, 27 May 2025 18:22:05 +0200
Message-ID: <20250527162526.416187210@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>

[ Upstream commit ba757a65d2a28d46a8ccf50538f4f05036983f1b ]

Add support to allow retrying the sending of MMIO requests
from the VF to the GUC in the event of an error. During the
suspend/resume process, VFs begin resuming only after the PF has
resumed. Although the PF resumes, the GUC reset and provisioning
occur later in a separate worker process.

When there are a large number of VFs, some may attempt to resume
before the PF has completed its provisioning. Therefore, if a
MMIO request from a VF fails during this period, we will retry
sending the request up to GUC_RESET_VF_STATE_RETRY_MAX times,
which is set to a maximum of 10 attempts.

Signed-off-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Michał Wajdeczko <michal.wajdeczko@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Reviewed-by: Piotr Piorkowski <piotr.piorkowski@intel.com>
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250224102807.11065-3-satyanarayana.k.v.p@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_vf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
index 9c30cbd9af6e1..1c764f200b2a5 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
@@ -47,12 +47,19 @@ static int guc_action_vf_reset(struct xe_guc *guc)
 	return ret > 0 ? -EPROTO : ret;
 }
 
+#define GUC_RESET_VF_STATE_RETRY_MAX	10
 static int vf_reset_guc_state(struct xe_gt *gt)
 {
+	unsigned int retry = GUC_RESET_VF_STATE_RETRY_MAX;
 	struct xe_guc *guc = &gt->uc.guc;
 	int err;
 
-	err = guc_action_vf_reset(guc);
+	do {
+		err = guc_action_vf_reset(guc);
+		if (!err || err != -ETIMEDOUT)
+			break;
+	} while (--retry);
+
 	if (unlikely(err))
 		xe_gt_sriov_err(gt, "Failed to reset GuC state (%pe)\n", ERR_PTR(err));
 	return err;
-- 
2.39.5



