Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4181C7608;
	Mon, 14 Oct 2024 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918973; cv=none; b=WAkdpKKXpXMsO1biWqVPBkPR9tQuOaTpH4jiSBL7SGBYtU4J/29Tb4VaZa/C4ARbRxOUu9DhI75iLT3yBQDS5AOVGTL7/dcV0wA5iYIQI5yE5fZyHowz2f0ldB7n396dldxktRhLLF7yOzofjznI54W4wubCcXMIXRhrm5RZZHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918973; c=relaxed/simple;
	bh=JbofWkSn8VLf/1xfrdQ5HL+iIR7+AX1Vlwi26lNL2Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCd4ir1VRBzU2bFC367totw/QZLo1uT6STGesc/78eSb/fA8jO4RKAY41+wsG2Y5C7wIEY+APiTEUqPgXXN83k88H6VR6v8HZcnIHTO2d8PHfvbVI1v6fdlwgk6vi7mYb5wyTOdtBtPmuZXUaJTHozXnFwFnasuejvhkrK+LNVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbS7P2v+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbS7P2v+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6E5C4CECF;
	Mon, 14 Oct 2024 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918973;
	bh=JbofWkSn8VLf/1xfrdQ5HL+iIR7+AX1Vlwi26lNL2Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbS7P2v+n5+0WU2a0/w6Wh0IdLPW0irSLd2gSWFd9KAqhysnXBGsngbtT63ohCDtA
	 lZSiLG70aUe1QkBKb32BzLvLJ9Iw+1npiXjxTo5fUfO2q6mk+8AdUMHTp0/XCdeWyo
	 alnthKEkNporhz0T4UXdvwLumD1pQcEa+Txqlp9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 477/798] drm/amd/display: Handle null stream_status in planes_changed_for_existing_stream
Date: Mon, 14 Oct 2024 16:17:11 +0200
Message-ID: <20241014141236.714153831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 8141f21b941710ecebe49220b69822cab3abd23d ]

This commit adds a null check for 'stream_status' in the function
'planes_changed_for_existing_stream'. Previously, the code assumed
'stream_status' could be null, but did not handle the case where it was
actually null. This could lead to a null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_resource.c:3784 planes_changed_for_existing_stream() error: we previously assumed 'stream_status' could be null (see line 3774)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 29400db42bb2d..d4ba81f36ded1 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2634,8 +2634,10 @@ static bool planes_changed_for_existing_stream(struct dc_state *context,
 		}
 	}
 
-	if (!stream_status)
+	if (!stream_status) {
 		ASSERT(0);
+		return false;
+	}
 
 	for (i = 0; i < set_count; i++)
 		if (set[i].stream == stream)
-- 
2.43.0



