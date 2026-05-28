Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297072F8EA1;
	Thu, 28 May 2026 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998345; cv=none; b=JvPAempIX+dWHG/cd8UHyb+TvZVB1BhdyyiJFMo2Y1ZzNPerMlUxVEKcWzfAuTNC+3iFR7WgPr7zIuYmDNIKgH1aUW5eaVFxlGLWkJvSPz5+gcupJzYJ9xghvBgXMN2Sv8pfIj0j+e5q6NxioOhgt4stUFiyeoyt4w0cgccKLxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998345; c=relaxed/simple;
	bh=Z2hkIc4+bFlOk8T1zY/GwqlYQhUH9IyYquE3rb18V0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okUPJXC5oWP1Hrmi0RN6rUpaBtlN3Eig4QkseHUPopuCpRDzE/whR8kP4MU6PX7ZO+07X/EzcdIVDLcELh+pssPdJBtUzDW4Ncjj31zFbLQ/MbxMoCS1ED6t3+t6MDBFAzMFzxlb1YGqd6W8j3DXHBeaXfiuV1fm5dRwjWr+Fio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJWA7hCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJWA7hCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FFD1F000E9;
	Thu, 28 May 2026 19:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998344;
	bh=ZpbxA/j1tuq3NQ5s+fFwlRpoxByhS+tXjsqbawcwjC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJWA7hCg3tHQNIoYpIJiOebcrwDXBCnv8mZ3TYFMfmYQc3u+OLRz8UKA8F8sxR1K6
	 QnaQFIq7AeLEpRgDxDyFLhemKFUAefJsZE+LHNQ8aIgYag1fUrOOcPIYX6egBJzjTb
	 S/2s1AgZkx0rswfLLSd5Il6JwYJc27u6biD4JRw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 140/461] drm/amd/display: Validate payload length and link_index in dc_process_dmub_aux_transfer_async
Date: Thu, 28 May 2026 21:44:29 +0200
Message-ID: <20260528194651.052392524@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit 6c92f6d9600efa3ef0d9e560a2b52776d9803c29 upstream.

[Why&How]
dc_process_dmub_aux_transfer_async() copies payload->length bytes into a
16-byte stack buffer (dpaux.data[16]) guarded only by an ASSERT(), which
is a no-op in release builds. If a caller ever passes length > 16 this
results in a stack buffer overflow via memcpy.

Additionally, link_index is used to dereference dc->links[] without
bounds checking against dc->link_count, risking an out-of-bounds access.

Replace the ASSERT with a hard runtime check that returns false when
payload->length exceeds the destination buffer size, and add a bounds
check for link_index before it is used.

Assisted-by: GitHub Copilot:Claude claude-4-opus
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ba4caa9fecdf7a38f98c878ad05a8a64148b6881)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5993,7 +5993,11 @@ bool dc_process_dmub_aux_transfer_async(
 	uint8_t action;
 	union dmub_rb_cmd cmd = {0};
 
-	ASSERT(payload->length <= 16);
+	if (link_index >= dc->link_count || !dc->links[link_index])
+		return false;
+
+	if (payload->length > sizeof(cmd.dp_aux_access.aux_control.dpaux.data))
+		return false;
 
 	cmd.dp_aux_access.header.type = DMUB_CMD__DP_AUX_ACCESS;
 	cmd.dp_aux_access.header.payload_bytes = 0;


