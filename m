Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ECC17A589;
	Tue, 10 Sep 2024 10:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963655; cv=none; b=tDANbzwu1h4xbvCge6eb68bDj4xHIJU/2EnDTo6HysWLegetcPs4mi0U4L5A9ODYDMq1q4FqQhcW8PW5P9RFTLn3AkcsGlDvLBZNcEYc26WmuSG7vrUvPs6x/T9y+6nfvNhtyaAYdl1XFtwnLDQ7lbrG7Bb0KOuwxMfYsVPD1vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963655; c=relaxed/simple;
	bh=L9G8To2nme6T/QzSjXXigPZIukAhUuWnJMW82dzes2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gd9cWsJcQ0ZFqYLPaZJ+KwmL8b7C5t66K5NGYstmMlhJyA3EkuTyyiMBGPUEIfCEusj0YE6qbm2gEo+XMAM0d8uQcX+n6RCq3a3ZztDHicrSzXZh6APjL+yWWTkGLuvQzVmhe/NPEjaV4vG8hvjEXln89N3cOtq54dYJWDJAyC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmVnXW/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmVnXW/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270A0C4CEC3;
	Tue, 10 Sep 2024 10:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963655;
	bh=L9G8To2nme6T/QzSjXXigPZIukAhUuWnJMW82dzes2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmVnXW/5oSuL61931k1sB+h0rBZTzyZ2JJFi83mzwF9qMltUFLo1wBQUJTsNQgRvH
	 0SlLj/Ps2HOh4qYo01Tv3kVlyBKkx7DDtQuQvli18W3BYvMxF4aACfRXnbter9AHVV
	 rMVzKKCo8huVrs3bWCGvw8X7AjKiI+l9lSCO6hpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/214] drm/amd/display: Check HDCP returned status
Date: Tue, 10 Sep 2024 11:32:16 +0200
Message-ID: <20240910092603.463225907@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6ec918af3bff..119b00aadd9a 100644
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



