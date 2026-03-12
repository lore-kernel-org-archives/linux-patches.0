Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F4833A9CF;
	Thu, 12 Mar 2026 20:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347328; cv=none; b=Ur49WYFoQ9appHbqvmS1tytVI5g8giEZwpMODpPZ7ABbOX0cmF0Sa0KVM62urOCj6I5+UelhHUFevC8pmAHwpOxuNRveXEbPF+9L2fzZ8JdJE2bCgRLlNIsGRhZE/+bRjP3SCeDNYYq6Y8efaTAOtAVrsncEgdwMch7xyXkUZO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347328; c=relaxed/simple;
	bh=/BX3KxE5XGNlx5B0ctK9xYBLdkWQ5Wimg3qn9SXiCaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=err1BPRixOaxuUf0gXBQP5oBkP97GuF5MimBIp7KdgNrKdzSqoywJ9l98vXlg318SpXPrqZldKxDLLDLMJlAI3Cz5RVTP+ROweQsGBue+DqUaSM/z/5yPAL0CgfDV1jR34uI/P3dswie9dL3AqRMhdZmeLCtb5EtEeleTx7T21g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cByjxQc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cByjxQc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B494FC19425;
	Thu, 12 Mar 2026 20:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347328;
	bh=/BX3KxE5XGNlx5B0ctK9xYBLdkWQ5Wimg3qn9SXiCaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cByjxQc+d9u/3/mFDshvVVKCRAo5PfxqkVvg5v4EssWQM+owTPeTEtB9p73x/giBr
	 QrsJSQWpbV10BT57xRdUjF2Mp3tvUm759+vXDXAMw1OFUHS1qAvfxOelbE+wV+eQMh
	 HNqOKT6P4vbUB06kgU1keTSccBCeghJce89cUlS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/265] drm/xe/reg_sr: Fix leak on xa_store failure
Date: Thu, 12 Mar 2026 21:10:09 +0100
Message-ID: <20260312201026.343722384@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 3091723785def05ebfe6a50866f87a044ae314ba ]

Free the newly allocated entry when xa_store() fails to avoid a memory
leak on the error path.

v2: use goto fail_free. (Bala)

Fixes: e5283bd4dfec ("drm/xe/reg_sr: Remove register pool")
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20260204172810.1486719-2-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 6bc6fec71ac45f52db609af4e62bdb96b9f5fadb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_sr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_reg_sr.c b/drivers/gpu/drm/xe/xe_reg_sr.c
index d3773a9853872..ae9e6df2f4e12 100644
--- a/drivers/gpu/drm/xe/xe_reg_sr.c
+++ b/drivers/gpu/drm/xe/xe_reg_sr.c
@@ -102,10 +102,12 @@ int xe_reg_sr_add(struct xe_reg_sr *sr,
 	*pentry = *e;
 	ret = xa_err(xa_store(&sr->xa, idx, pentry, GFP_KERNEL));
 	if (ret)
-		goto fail;
+		goto fail_free;
 
 	return 0;
 
+fail_free:
+	kfree(pentry);
 fail:
 	xe_gt_err(gt,
 		  "discarding save-restore reg %04lx (clear: %08x, set: %08x, masked: %s, mcr: %s): ret=%d\n",
-- 
2.51.0



