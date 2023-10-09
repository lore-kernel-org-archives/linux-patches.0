Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD592E63E
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXm6zMNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B2BC433C7;
	Mon,  9 Oct 2023 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858182;
	bh=7T0C9GJetIV0Osyo8dafQ27MqvNtbaz9NPbr+iHyL/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXm6zMNYEYLC9qV0DeEH8rIw04TT5yV9hpngxIlF0Pbv8ViSXZtanqzescx5YMUEi
	 OklGuhBVcpVnLjSXly6KWCPjn9zGoPX+/Jrmf7fmCl5euWhBcMwYXIZibFf29Fsq5J
	 R0CwgkWOGBqqKb2VZ1sdphH8kmq81sMxx9BKFUaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/131] drm/amd/display: prevent potential division by zero errors
Date: Mon,  9 Oct 2023 15:01:21 +0200
Message-ID: <20231009130117.566299510@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit 07e388aab042774f284a2ad75a70a194517cdad4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index 5835b968cac5d..ed5c9edfdcc56 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -323,7 +323,9 @@ static void apply_below_the_range(struct core_freesync *core_freesync,
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
@@ -370,8 +372,9 @@ static void apply_below_the_range(struct core_freesync *core_freesync,
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
-- 
2.40.1



