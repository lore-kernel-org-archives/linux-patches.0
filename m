Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A77E2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28AEC433EF;
	Sun, 22 Jan 2023 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400469;
	bh=arP/9gihXpo5gmdhMOHxh359EdvmMQ7uXXaUS6JZqHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuZLup54/3N2odBUBM5sgaPu99KCm1s6LKPWIe+rDoTtU9Q1JVl6bz2Z7BevKFcg1
	 FcsLNyC5z7FRK1CDit6AgYXnWebJMG76y5DoA1AB47cQtjd2+c/SeiXptr/s8Qvx1H
	 tWp/h1Tvlo0wuLYF8z7HabmU3Edgkj3s4FzfahpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Joshua Ashton <joshua@froggi.es>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 79/98] drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix
Date: Sun, 22 Jan 2023 16:04:35 +0100
Message-Id: <20230122150232.775854527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joshua Ashton <joshua@froggi.es>

commit 973a9c810c785ac270a6d50d8cf862b0c1643a10 upstream.

The YCC conversion matrix for RGB -> COLOR_SPACE_YCBCR2020_TYPE is
missing the values for the fourth column of the matrix.

The fourth column of the matrix is essentially just a value that is
added given that the color is 3 components in size.
These values are needed to bias the chroma from the [-1, 1] -> [0, 1]
range.

This fixes color being very green when using Gamescope HDR on HDMI
output which prefers YCC 4:4:4.

Fixes: 40df2f809e8f ("drm/amd/display: color space ycbcr709 support")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Joshua Ashton <joshua@froggi.es>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -92,8 +92,8 @@ static const struct out_csc_color_matrix
 		{ 0xE00, 0xF349, 0xFEB7, 0x1000, 0x6CE, 0x16E3,
 				0x24F, 0x200, 0xFCCB, 0xF535, 0xE00, 0x1000} },
 	{ COLOR_SPACE_YCBCR2020_TYPE,
-		{ 0x1000, 0xF149, 0xFEB7, 0x0000, 0x0868, 0x15B2,
-				0x01E6, 0x0000, 0xFB88, 0xF478, 0x1000, 0x0000} },
+		{ 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868, 0x15B2,
+				0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} },
 	{ COLOR_SPACE_YCBCR709_BLACK_TYPE,
 		{ 0x0000, 0x0000, 0x0000, 0x1000, 0x0000, 0x0000,
 				0x0000, 0x0200, 0x0000, 0x0000, 0x0000, 0x1000} },


