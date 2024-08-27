Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1666F19F485;
	Tue, 27 Aug 2024 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771049; cv=none; b=g5lWY3xIemQnyrWjlhatQFtYQZDnJb3jsP74x+pr84Ctzvwee/1KveyGPf89b03tp0seG2uPtULXSnIgrTkO7celGUOvWETPFb+EI79vVKYtm3mNv4yvXPQF2wuLssa5T0rWRNNFfOB7uNPuPGbNKoWFsOT3ZVmsd60tRMTsAME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771049; c=relaxed/simple;
	bh=dvMCGKZSmm+m8BDh7drhp2IAQiQjwoJPuLGOw4R/rm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqZXakRWUhWud/xeLAFyhpPUJrH4XE77eBVJivSdOiRb9l1y78qf0xf6Jzh7HZ4sUXBIZJl5ixmr1Zm9vlxx2kSDfNghHLwTVNLcGtdKOk7HZgqP+TJ78KJLr+zY9lldF+RDjItQjtWIbrCn2ntCaXbFuA1sVPdJRUW3eP9B2vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzgRwhNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzgRwhNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76670C6104C;
	Tue, 27 Aug 2024 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771049;
	bh=dvMCGKZSmm+m8BDh7drhp2IAQiQjwoJPuLGOw4R/rm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzgRwhNti8RNqvC5X7b7XyfMNBwAsbzlFqw1j2vHjXoTW2q/g8UtOJtDN/7uZ0jOa
	 CMJGQ9S66x3p8x2xN+mr5+3UbV276eheK6FikWgLtgMcHzGHiuORCSTCuvLdLw+Cnj
	 n8N2AK6B2XF0l8L5at+REgsNqfgPLHzr3tpaENfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@gmail.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 072/273] drm/amd/display: fix cursor offset on rotation 180
Date: Tue, 27 Aug 2024 16:36:36 +0200
Message-ID: <20240827143836.156585536@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Melissa Wen <mwen@igalia.com>

commit 737222cebecbdbcdde2b69475c52bcb9ecfeb830 upstream.

[why & how]
Cursor gets clipped off in the middle of the screen with hw
rotation 180. Fix a miscalculation of cursor offset when it's
placed near the edges in the pipe split case.

Cursor bugs with hw rotation were reported on AMD issue
tracker:
https://gitlab.freedesktop.org/drm/amd/-/issues/2247

The issues on rotation 270 was fixed by:
https://lore.kernel.org/amd-gfx/20221118125935.4013669-22-Brian.Chang@amd.com/
that partially addressed the rotation 180 too. So, this patch is the
final bits for rotation 180.

Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2247
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 9d84c7ef8a87 ("drm/amd/display: Correct cursor position on horizontal mirror")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1fd2cf090096af8a25bf85564341cfc21cec659d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -3605,7 +3605,7 @@ void dcn10_set_cursor_position(struct pi
 						(int)hubp->curs_attr.width || pos_cpy.x
 						<= (int)hubp->curs_attr.width +
 						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = temp_x + viewport_width;
+						pos_cpy.x = 2 * viewport_width - temp_x;
 					}
 				}
 			} else {


