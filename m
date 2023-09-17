Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E9E6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0996C433C7;
	Sun, 17 Sep 2023 20:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981767;
	bh=9i2qdpJSqpgS2PCA31nKmL4Jel5D0GoeqyLHX+DjYQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKXkbre5pvhfNnnOJ3JrbSf5AJU9pfjV13fmg+YHUqmRJcBWDIilQ3ncgnIbJjpsp
	 sP7EUq+0+SPa9C0UReAoroCe/5BqRQud7Wj3npacNuBP3iBiUP8ZSoUak1+faL/d0Y
	 gJrnCwtLhCKFzsSjiCZUkoYCY4XVeZgS8jemYd8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 169/219] drm/amd/display: prevent potential division by zero errors
Date: Sun, 17 Sep 2023 21:14:56 +0200
Message-ID: <20230917191047.125645012@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 07e388aab042774f284a2ad75a70a194517cdad4 upstream.

There are two places in apply_below_the_range() where it's possible for
a divide by zero error to occur. So, to fix this make sure the divisor
is non-zero before attempting the computation in both cases.

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2637
Fixes: a463b263032f ("drm/amd/display: Fix frames_to_insert math")
Fixes: ded6119e825a ("drm/amd/display: Reinstate LFC optimization")
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -338,7 +338,9 @@ static void apply_below_the_range(struct
 		 *  - Delta for CEIL: delta_from_mid_point_in_us_1
 		 *  - Delta for FLOOR: delta_from_mid_point_in_us_2
 		 */
-		if ((last_render_time_in_us / mid_point_frames_ceil) < in_out_vrr->min_duration_in_us) {
+		if (mid_point_frames_ceil &&
+		    (last_render_time_in_us / mid_point_frames_ceil) <
+		    in_out_vrr->min_duration_in_us) {
 			/* Check for out of range.
 			 * If using CEIL produces a value that is out of range,
 			 * then we are forced to use FLOOR.
@@ -385,8 +387,9 @@ static void apply_below_the_range(struct
 		/* Either we've calculated the number of frames to insert,
 		 * or we need to insert min duration frames
 		 */
-		if (last_render_time_in_us / frames_to_insert <
-				in_out_vrr->min_duration_in_us){
+		if (frames_to_insert &&
+		    (last_render_time_in_us / frames_to_insert) <
+		    in_out_vrr->min_duration_in_us){
 			frames_to_insert -= (frames_to_insert > 1) ?
 					1 : 0;
 		}


