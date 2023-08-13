Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364F59446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49F8C433C7;
	Sun, 13 Aug 2023 21:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962982;
	bh=k6oJgLUjGsRe1XEcLqcY2g+e+mgJi8mFANRjC008rVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zui+g0/4c6AozzC95ktj3g3yuZg57D0pB+McoREvTQTu0KlN+Q6QUFscDEC3HNgok
	 k+Nifh5vLJm8yCz+WPIuw3FSYVPqPL9e59LDthkCgJylo66R6AbiKD0MSC5grDzCcK
	 hnqTf+hO1pnLH92+ixJSQQSktJZLHVkLh6506LXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 10/89] drm/amd/display: check attr flag before set cursor degamma on DCN3+
Date: Sun, 13 Aug 2023 23:19:01 +0200
Message-ID: <20230813211711.086566192@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Melissa Wen <mwen@igalia.com>

commit 96b020e2163fb2197266b2f71b1007495206e6bb upstream.

Don't set predefined degamma curve to cursor plane if the cursor
attribute flag is not set. Applying a degamma curve to the cursor by
default breaks userspace expectation. Checking the flag before
performing any color transformation prevents too dark cursor gamma in
DCN3+ on many Linux desktop environment (KDE Plasma, GNOME,
wlroots-based, etc.) as reported at:
- https://gitlab.freedesktop.org/drm/amd/-/issues/1513

This is the same approach followed by DCN2 drivers where the issue is
not present.

Fixes: 03f54d7d3448 ("drm/amd/display: Add DCN3 DPP")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1513
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
@@ -355,8 +355,11 @@ void dpp3_set_cursor_attributes(
 	int cur_rom_en = 0;
 
 	if (color_format == CURSOR_MODE_COLOR_PRE_MULTIPLIED_ALPHA ||
-		color_format == CURSOR_MODE_COLOR_UN_PRE_MULTIPLIED_ALPHA)
-		cur_rom_en = 1;
+		color_format == CURSOR_MODE_COLOR_UN_PRE_MULTIPLIED_ALPHA) {
+		if (cursor_attributes->attribute_flags.bits.ENABLE_CURSOR_DEGAMMA) {
+			cur_rom_en = 1;
+		}
+	}
 
 	REG_UPDATE_3(CURSOR0_CONTROL,
 			CUR0_MODE, color_format,


