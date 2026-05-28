Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB19197A7D;
	Thu, 28 May 2026 20:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000654; cv=none; b=Yuw3nBpH8mwKEbWoBkSK3L/NcLvigy566hC7QjPoYP0QZQKYYVYFOVWM5SpIqdoJfOqYckb9/FbJsh2bLXcwQ1V7Y3uN+AhYBwgmjJe9yWNLxNFuasv4PFgeqmSYOwQMrOaV42BvyYG7Z8M8321Cx5V4PqBxhTqJMrUwUN5wLRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000654; c=relaxed/simple;
	bh=H+6xemgne0afsF7oIA1Wq6DWG7BDybQQJ/MFmtebunw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfkE6ZhDDjs0NGYf6SBvBh8tISIOHXvV6im+SlcM6q+TKNVpaUosSQ33wmza2Bj7iOdYBEKvmkJfDQFXawq4Z5eUpossiPaorjSIxwvaYcez3lxJeMTMg86hpgtU/lwcpNw0lYu5ethUxdJoCCyn6u8oakUYQRUzSk+O32k0XZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydYQV84V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydYQV84V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AFA1F000E9;
	Thu, 28 May 2026 20:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000653;
	bh=YW6VP+7B2j5D2f2Ta6VOjP0ohH/o+3RYHeyPecnpSCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydYQV84Vv8BFKsXYbwO7meQSuexBeqYthKCF/wHwc+Pc6Neng5AYUhYLy+r4JiluB
	 D2z0xs56r6Oo2ia+bLuDBgrZYcqOUUDZx7upXNWx7cQG6Bh0vpEbW7LdPfgry0fj7w
	 xl70RbK3rUf/z9ots9GZa2pbbjeLvHKPjkS2h2Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 120/272] drm/amd/display: Validate payload length and link_index in dc_process_dmub_aux_transfer_async
Date: Thu, 28 May 2026 21:48:14 +0200
Message-ID: <20260528194632.739861868@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -5661,7 +5661,11 @@ bool dc_process_dmub_aux_transfer_async(
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


