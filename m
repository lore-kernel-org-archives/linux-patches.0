Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14BA1DAC9F;
	Tue,  3 Dec 2024 15:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241054; cv=none; b=nM/DaYVpEJvCLRGTXo3PcjPMQZMDgFrAs+HBiYtRNTEbfReiUo4wMx2n6QWmiAzcCQblE92Z+jDaxpPv5F8BiQ3e/sBOZV8wZyGlUHe94ZED9oLJ9w8xkUuQgvkOTaZ11cJpTjc99T7b+zb1DF1mTtKSFB6nQyd1DxdoQQSoHf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241054; c=relaxed/simple;
	bh=hwTSditoq2gjqULLpMNipxrabK/7z5Jn3No4dTS1ZLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPKS8PUDRYiUuuPJMKElmIfCU5f8ePvKwKd9gGT1zgJ8NUpz/DxHnt9VjLfYxO0rdIa2QAUz9yHcrUg3oPtBlxBkhhkRAEXdD/OZ0lvj0OTzfHa+TuaEA9NdSf/ljsUvwrlgitqXkzCVdvAf9PomrW5LsvzNpeBaPz/O0kw/z3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToCwri37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToCwri37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BB8C4CED6;
	Tue,  3 Dec 2024 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241054;
	bh=hwTSditoq2gjqULLpMNipxrabK/7z5Jn3No4dTS1ZLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToCwri37DaH+fT0zhRqk4mai2ncHPwQxaPb38/O2GBEFcZvUCqF6YV6ReMdzlbnUd
	 ycKGOEKZnEp28MdXI2oJUwY9Fes0vnk4oZQWQhFdjv0OGJlH7gXS1Vlpglkol4oNfQ
	 n/Zzr38DOwiIodF6VGdUZale2pm8CaTNF/OMpixg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/826] drm/xe/hdcp: Fix gsc structure check in fw check status
Date: Tue,  3 Dec 2024 15:40:07 +0100
Message-ID: <20241203144754.695147102@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit 182a32bcc223203c57761889fac7fa2dbb34684b ]

Fix the condition for gsc structure validity in
gsc_cs_status_check(). It needs to be an OR and not an AND
condition

Fixes: b4224f6bae38 ("drm/xe/hdcp: Check GSC structure validity")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241025160834.8785-1-suraj.kandpal@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
index 6619a40aed153..f4332f06b6c80 100644
--- a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
+++ b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
@@ -42,7 +42,7 @@ bool intel_hdcp_gsc_check_status(struct xe_device *xe)
 	struct xe_gsc *gsc = &gt->uc.gsc;
 	bool ret = true;
 
-	if (!gsc && !xe_uc_fw_is_enabled(&gsc->fw)) {
+	if (!gsc || !xe_uc_fw_is_enabled(&gsc->fw)) {
 		drm_dbg_kms(&xe->drm,
 			    "GSC Components not ready for HDCP2.x\n");
 		return false;
-- 
2.43.0



