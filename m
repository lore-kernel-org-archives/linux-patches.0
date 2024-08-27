Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E416F1A08A3;
	Tue, 27 Aug 2024 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770461; cv=none; b=eeIAm7pAU6u/l/hWygb68c7OoSFc/dl1/QiqwPQRWIkJy6XJyzB9xal89LoBgJ3BBbx/QjpIY5HlCHSeNX45jD2f8Crv6dWK4QOTvRALkR8wyGbc5nbj3jGcPhA1+9V4mkVfhwINk5RM1uLoWiZ9kgmbkGHQ32730m/UhRYpCM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770461; c=relaxed/simple;
	bh=8+DcCbpUzYnTWFhQuZP+dPe4XNDXqPahPiS4yJgdif0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VN8CDYmIMBx9gzdQBoRL8mLS//wX+1hlyUAPaCRv6yK8vpw1esDLfN0k6II+05ZezzSk0fUAkJcZQm+S+vHnurxuTy/gWunstY8nPnecrxkNl5nS7EHW4NArOctKsjSCS7VuzyOT5Yj5SKYOfl9rHPVMFp7lwYe+9eLkhotdWRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLfGNtez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLfGNtez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D72C4E673;
	Tue, 27 Aug 2024 14:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770460;
	bh=8+DcCbpUzYnTWFhQuZP+dPe4XNDXqPahPiS4yJgdif0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLfGNtezgBUBBIzrOKUSFU11gi847daBs5j/4mzu7QhVvVfQ8gKj2CbiYGN1yBRxV
	 ObGe98fZNalI5Mj9FScdj019Kh+DA6lfTg5gwz/AFg8VYw+51cBVUEHCFHYyTZBHa6
	 XBF/vlOdEMCoK5jGGTbTch87aHEz8nipT/VgPP+E=
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
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/341] drm/amd/display: fix cursor offset on rotation 180
Date: Tue, 27 Aug 2024 16:37:47 +0200
Message-ID: <20240827143852.388936671@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 737222cebecbdbcdde2b69475c52bcb9ecfeb830 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index c9f13c3768431..ff38a85c4fa22 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3521,7 +3521,7 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 						(int)hubp->curs_attr.width || pos_cpy.x
 						<= (int)hubp->curs_attr.width +
 						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = temp_x + viewport_width;
+						pos_cpy.x = 2 * viewport_width - temp_x;
 					}
 				}
 			} else {
-- 
2.43.0



