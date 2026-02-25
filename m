Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D142BAF7;
	Wed, 25 Feb 2026 01:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983087; cv=none; b=PmuEUkrW5PL+Gz2M79tdIwPeGA3s3eIo4gfI8Ylx/RjXW02y1wNjih4EMSTFRTrRKjHrAEJP5xuzHOjNB5c4ImJXXue3LXMrDVspLhYto8tjtqN/2Egr8iGBRWgq3NlzfjwzcAunbhE1gGBpdP/0esg8N97iTBxbtqxG9TAtolw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983087; c=relaxed/simple;
	bh=b2ljnzSIXBlWdCcG0w3BJSRVgD4SUgGLC3tJMrNinB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JF7MsKKkUVRm0AU7zgMXFu/E27zjzTAWMtjCE5MZy1PMuOniihWUUWxB7BKiYOoM87CIlS9awgmRGRt2RwMALDX6832lQTvc+lhTYCWvKTgOlDs4M/lTxaKy/0jS+ssZ26WXlJR496mgv8JvH+1Ap8Gsq5C7x6bpGbLV354EdE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkkvzjsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkkvzjsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4ABC19423;
	Wed, 25 Feb 2026 01:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983086;
	bh=b2ljnzSIXBlWdCcG0w3BJSRVgD4SUgGLC3tJMrNinB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkkvzjsmbFBvBm1NiPSrG92Cxjib6KFE5FyKCTaKLSpWHKZmyPuOovwNC41O6AMQg
	 DsGuP5UJrMAZ2aqEiK7AXXxdAuA2TsEYCmU1ZDdeCMlY1x3mHUqT2tcic1xd9OXsj/
	 qRhIEpBjdAe9TyebXvv5zUSjp10bt0GmirqUOtLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 246/781] drm/amd/display: Dont repeat DAC load detection
Date: Tue, 24 Feb 2026 17:15:55 -0800
Message-ID: <20260225012405.742199200@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 0d89268d20c961b6226a4aa948fdbe9f93021d95 ]

The analog link detection code path had already performed the
DAC load detection by the time the EDID read is attempted.
So there is no need to repeat the DAC load detection,
we can know that no display is connected if no EDID is read.

Fixes: ac1bb4952267 ("drm/amd/display: Use DAC load detection on analog connectors (v2)")
Suggested-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_detection.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_detection.c b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
index 4f48e7ea75110..f986b57381bab 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1173,11 +1173,10 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 			 * - cheap DVI-A cable or adapter that doesn't connect DDC
 			 */
 			if (dc_connector_supports_analog(link->link_id.id)) {
-				/* If we didn't do DAC load detection yet, do it now
-				 * to verify there really is a display connected.
+				/* If we didn't already detect a display using
+				 * DAC load detection, we know it isn't connected.
 				 */
-				if (link->type != dc_connection_analog_load &&
-					!link_detect_dac_load_detect(link)) {
+				if (link->type != dc_connection_analog_load) {
 					if (prev_sink)
 						dc_sink_release(prev_sink);
 					link_disconnect_sink(link);
-- 
2.51.0



