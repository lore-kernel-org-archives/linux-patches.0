Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9449313A244;
	Tue, 27 May 2025 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365814; cv=none; b=rzpB/tRpJcrxjQRec3DTNX2+7KFUndiHmhSyzdqSudzsZ7lkTyOLDbTBA144lKehkUNsokYxGA3JRRyO7RbkcvNXPLZI1p8TGIOhK8OPVGclN69bn23WY3WV2vVQZWe/+lPeXiOWYjfKtd+h62HFM550s4n2RcbpywxO1QkD1Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365814; c=relaxed/simple;
	bh=x4akmfWCKBWH5A3fbflmoFoIhuNz8zCupw9SSdidlNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIA1u7z5CQUKtCCl6D7gtifO5qgz2yV+/Zt6hTeAE4t1NZrEGjs9ieKYyERt9PayOnLV9okqqcDq8PFtP0duc9OMmsXpzQZOF2NbN58br3QxZDE7rV5K1FPxYTAlCoMqFMuGpCP7KTp7NduUM0/Tg7Vv8zFmQbCUBumMwt0J67E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COyeoidP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COyeoidP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65FEC4CEE9;
	Tue, 27 May 2025 17:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365814;
	bh=x4akmfWCKBWH5A3fbflmoFoIhuNz8zCupw9SSdidlNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COyeoidPVJkvApRLrkmmXlM8vYOsrLFjG5cji+sHQ4FO5I9vwng5Cu3E0u80tdxsX
	 N7+tTUWhgrKmjXJNpylSn5Yl1F9jB14FIwpwOOyzxfHr4O/lXE0t/VtBqXpMlbXMZK
	 9+dOszAqqLcrxkN2rxnf7qHWqp7Pwb5DN0gM1yRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 497/626] drm/xe: Do not attempt to bootstrap VF in execlists mode
Date: Tue, 27 May 2025 18:26:30 +0200
Message-ID: <20250527162505.170651092@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit f3b59457808f61d88178b0afa67cbd017d7ce79e ]

It was mentioned in a review that there is a possibility of choosing
to load the module with VF in execlists mode.

Of course this doesn't work, just bomb out as hard as possible.

Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241210083111.230484-12-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_vf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
index 7ddbfeaf494ac..29badbd829ab6 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
@@ -235,6 +235,9 @@ int xe_gt_sriov_vf_bootstrap(struct xe_gt *gt)
 {
 	int err;
 
+	if (!xe_device_uc_enabled(gt_to_xe(gt)))
+		return -ENODEV;
+
 	err = vf_reset_guc_state(gt);
 	if (unlikely(err))
 		return err;
-- 
2.39.5



