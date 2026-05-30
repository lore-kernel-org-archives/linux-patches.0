Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD5C241C8C;
	Sat, 30 May 2026 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164947; cv=none; b=iIusW6ExE/6cUsbyr2z8p7fI6OL+WHJGz1M2fNSE0ZBaU2xWYjehtg6HPFpoVJJHzDukIqaJ4pAdsjP2jcCKADndvfjjkOuYRlITO3MAuhgUmA7PI1EOXQcsT2NdIblxLGZfFBDiyA2kNl0FLNDYauWtyIoyQKLB5ok5i3ZgtC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164947; c=relaxed/simple;
	bh=1S1+oX6ZUmlMNnwYj7H/fLronfaWRj0sWDc2uhAMtOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ2ZOHEraIJ9Q3v0VSvHtU/HyN/QsGMMIoWnU7OhrmT0rOqFx/VbDKeCz2AXjTCANLXbnpnKRQr4QW7eoHeAjeF7Aw1dunY76J1Ooqw6mq7RkVcQf8YEkMHCVmv7vMhvomrYVecjrZ4M6gse3d5WQJkBTBnQq0aA8TL+bkRkCqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWNXF8OP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWNXF8OP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB271F00893;
	Sat, 30 May 2026 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164946;
	bh=A3NtKT9g/qc1/cyDJKarugHK0y/zrHMFDO11RBErdXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWNXF8OP4l8bUQYM8UsR+L6XxjRi8VmiUl+SPMMhuXLQs+YeXGJvmAdT755DUAS6Y
	 ziFrL2iAdfpHnWGoUxMSJUXxc1U5qzViRXw+GZdeH23ofueLozfzvrT6r7nTwMmPDr
	 C7vZlAEF1CIMklWjzoy/N1n7XgP90e/H3/ok+bbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 705/776] drm/amd/display: Validate payload length and link_index in dc_process_dmub_aux_transfer_async
Date: Sat, 30 May 2026 18:06:59 +0200
Message-ID: <20260530160258.064230029@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3755,7 +3755,11 @@ bool dc_process_dmub_aux_transfer_async(
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


