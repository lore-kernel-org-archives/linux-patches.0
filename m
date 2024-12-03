Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAD71F706B;
	Tue,  3 Dec 2024 15:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238500; cv=none; b=Wb9CCXzLKBsRbtqEeDtiXSvJtB/V9jcTzRlsApzbuQsLOXjIuIwFHSVp3x8HUVFBZ/lLJzpBx1cf6nWyPA2nOrC/R2co/COkM6jQv5yY1QAMLIiCub5EXAnRR4NDBfeCDcLP3xbsXEnVEdw9L6xNuzCP60eKso/bJtxh/oCl88Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238500; c=relaxed/simple;
	bh=pEXI9JMwFylQZ5q1UnBPLdmz/MvQwojftlCmphZJ2Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtPYuGPCV1RKdsZCsOcjBTBhEgyFQuTOmEHN3TaJ6lLiFa47SxQHrADv+gmuPEG5XUV4Ed/AO8ZbBU6CcRgFppENQwLZ+txnUZaxGQ5+4fZUAJlkEQzDeG2todx+3xIRMdFS4pj3a//5UONlBiGp98NG2oeZhPWkGJXnT7al26g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAIJxA6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAIJxA6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7ADC4AF09;
	Tue,  3 Dec 2024 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238500;
	bh=pEXI9JMwFylQZ5q1UnBPLdmz/MvQwojftlCmphZJ2Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAIJxA6OPna9D/7X0krILQplszjelojlI/t//r2ApjKWMRzQTct7ske6uBTKd0vWp
	 XSCjcLeoh+027wO8s9UEz46G3NaDNY055E45fQflOBrWPSA0MpUoil4UUFnbVmeK+T
	 +LjjKsRGm+Z3Hjakk1d4C/MrpqyRHFCQFch1ySCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 298/817] drm/xe/hdcp: Fix gsc structure check in fw check status
Date: Tue,  3 Dec 2024 15:37:50 +0100
Message-ID: <20241203144007.450569204@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 0af667ebebf98..09b87d70e34c6 100644
--- a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
+++ b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
@@ -43,7 +43,7 @@ bool intel_hdcp_gsc_check_status(struct xe_device *xe)
 	struct xe_gsc *gsc = &gt->uc.gsc;
 	bool ret = true;
 
-	if (!gsc && !xe_uc_fw_is_enabled(&gsc->fw)) {
+	if (!gsc || !xe_uc_fw_is_enabled(&gsc->fw)) {
 		drm_dbg_kms(&xe->drm,
 			    "GSC Components not ready for HDCP2.x\n");
 		return false;
-- 
2.43.0



