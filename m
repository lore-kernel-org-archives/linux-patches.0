Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC42188CDC;
	Tue, 10 Sep 2024 09:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961600; cv=none; b=SvGDL2waTMhBb9PI8ggmXEVS/LpGT8t9l+4lgl20mOVfim6ohrt/pTV4lwH8/yrTdj6Vmt0Us+iZT/W9g7+XZ7o/kftvlxmihSKcU9D4curSdtlTpxyDCRUdnvq6BTtCBZr7tfN03wJGFeqLmYSFAHjLUUmdvDfHgPosB/VFahk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961600; c=relaxed/simple;
	bh=EcFnz6gHxUrBWJ6yoIUqyysI9wfFbDu3qoGXzesPo94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9zeX2OtHIn7YmjpSGw/Rph/UX0LZ1wzdcUc06pDu3k6aaVgnpd0Qb1Kc+k99WnCfA7CJr1Dq/e3ajJGu/4R9LxtMnwrcX/pGyFAMSvgrhd5FLbN+08izGFjbZXa768Ki6oIqEzGUm181JKpWRrh0LXIuq7XXfo2BMAUO09tSUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1730pUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1730pUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF15C4CEC3;
	Tue, 10 Sep 2024 09:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961599;
	bh=EcFnz6gHxUrBWJ6yoIUqyysI9wfFbDu3qoGXzesPo94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1730pUnT7eUBHdKpWE+VFkPwNtexsBsZtOikkSziD0HiHfjRrB8+P3cD61p3D/ix
	 G6nFOTb42XYzqHDFyyZc29YjUZyNYUduFMVRUvRFIGuO3kRpnImkNKJba/9DGBg5Rf
	 ScSnssyCnVbZlBElVheW3+QZGd7+2NdVC1L6AU1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 124/375] drm/amd/display: Check HDCP returned status
Date: Tue, 10 Sep 2024 11:28:41 +0200
Message-ID: <20240910092626.603881992@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 5d93060d430b359e16e7c555c8f151ead1ac614b ]

[WHAT & HOW]
Check mod_hdcp_execute_and_set() return values in authenticated_dp.

This fixes 3 CHECKED_RETURN issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/modules/hdcp/hdcp1_execution.c    | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
index 182e7532dda8..d77836cef563 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
@@ -433,17 +433,20 @@ static enum mod_hdcp_status authenticated_dp(struct mod_hdcp *hdcp,
 	}
 
 	if (status == MOD_HDCP_STATUS_SUCCESS)
-		mod_hdcp_execute_and_set(mod_hdcp_read_bstatus,
+		if (!mod_hdcp_execute_and_set(mod_hdcp_read_bstatus,
 				&input->bstatus_read, &status,
-				hdcp, "bstatus_read");
+				hdcp, "bstatus_read"))
+			goto out;
 	if (status == MOD_HDCP_STATUS_SUCCESS)
-		mod_hdcp_execute_and_set(check_link_integrity_dp,
+		if (!mod_hdcp_execute_and_set(check_link_integrity_dp,
 				&input->link_integrity_check, &status,
-				hdcp, "link_integrity_check");
+				hdcp, "link_integrity_check"))
+			goto out;
 	if (status == MOD_HDCP_STATUS_SUCCESS)
-		mod_hdcp_execute_and_set(check_no_reauthentication_request_dp,
+		if (!mod_hdcp_execute_and_set(check_no_reauthentication_request_dp,
 				&input->reauth_request_check, &status,
-				hdcp, "reauth_request_check");
+				hdcp, "reauth_request_check"))
+			goto out;
 out:
 	return status;
 }
-- 
2.43.0



