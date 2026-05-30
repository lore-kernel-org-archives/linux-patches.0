Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AD42E7379;
	Sat, 30 May 2026 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162296; cv=none; b=crgqcUhOrlxPfOVFOC2X/lTIjzjyrvyVQUdlYAtMut6Qr5PzqNttaV4zBtf8wZgIfnghDDxHem0PJvktvFWyqmP0+X6+aZzZoMVLtjRkvftT1k0rwkv5CsTDrokZT30oKe2gs1oVy1qWADUfp0yduW01cM9qD8IHRhSbBYAAVZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162296; c=relaxed/simple;
	bh=hRkMde9IVgJ2lHCXygL3/Ei2Az4aSv5sU7vrd9fPeuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFAcSESicptjPKCGGhMBASyHTJvXQ/R6FAWaGl75Mwc3fS6oeMs6FSctotRHfz0jaRziC77ycN41w4bYTradGNXwjByGtizqzQPSTyG0vaDcscVaDrDu/Ea+QsfbnErL96Q2Yq09R39iXnGGXg0WlTednyu3fJ1sgxRNOL5kBRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOhqMNxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOhqMNxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B361F00893;
	Sat, 30 May 2026 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162295;
	bh=iR9J/ElfvmjkNZ20TKj6TQU+euVe3J91YLvPCgLcKe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOhqMNxRPCGXgx8OJ7vDBTd/ezDWL2KloIZ8ybbtuZTZvfA/pUV4S5hzgawlefZnx
	 5hoNOWUyPwuBHbKMlw3b4AO8gpQoIuKwtQ8mdjL46BnJSCmVzMh/z5jRfsMH5FfKQu
	 TaO7ak9t5CkisX4KvjWR/k4i6qAhPsnjbhyG5kNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 879/969] drm/amd/display: Validate payload length and link_index in dc_process_dmub_aux_transfer_async
Date: Sat, 30 May 2026 18:06:43 +0200
Message-ID: <20260530160324.959479667@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4737,7 +4737,11 @@ bool dc_process_dmub_aux_transfer_async(
 	union dmub_rb_cmd cmd = {0};
 	struct dc_dmub_srv *dmub_srv = dc->ctx->dmub_srv;
 
-	ASSERT(payload->length <= 16);
+	if (link_index >= dc->link_count || !dc->links[link_index])
+		return false;
+
+	if (payload->length > sizeof(cmd.dp_aux_access.aux_control.dpaux.data))
+		return false;
 
 	cmd.dp_aux_access.header.type = DMUB_CMD__DP_AUX_ACCESS;
 	cmd.dp_aux_access.header.payload_bytes = 0;


