Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585785;
	b=olmj8NJHMhI7cWPEZLnnUZZcMca9ylDm/1zHwUbkFR8oW7/Rd3aRfvFY0SQyLxvExFha
	 5TC7tbejWD2OXmrINfKw7HkIx+g2koAIzXe8Q8qiEvCHj3sqwLJ4d69PoylM5b8NzJZ66
	 ntZUzTgR0SDhgl9ySF1DIAD8y26BiWtx1JIf0Ub4c95Y4Zy1vdYWu81hEdyT0UqSofTiL
	 57OvQPEk1KEa5WY4XS3QLmOeTkBUignT4LUI09mi6Mp1ijDSgicyQCd8c9K8n19IJBg1m
	 LMevGJtJZutjTr+xbU0aMXkZEVV4KNYL50d8thEn0YgJtmsCtW4uRZIlnchnOtjM/5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DWq/HOLvvTx0AQE3ZsYnn5Cps535Euqai6R8CYzqj80=;
	b=v+roAIfUDenRim1cEhauxrjNIMLTkQVjrFyJKTCuqroZCt+KIf93hxWO3aPyxbKV9erO
	 wdBHGDWHmf59vfnm9i+jJCKhlCV387uvDCyP1ao7ZK8O5Z3rRAhkv2Bbstz9zdmNLOsTE
	 quORRsqZ3DAtjrk6Bus+OzSXNPUcCv3mC6gSIbOlPELCGXDC8UfHbdUyUOvdUwIl/PhE+
	 0fx153rxeBzNkvqhYGhLHX9Zc9uGVcaD9XcObP/iesvuNGWT1BJfLXDXpBMBmT6ahAaBp
	 UVERWQLbFcmHmGA2Hg/ADfEH4kfatVdmaF9myFOjrjboGC0e2T1p2zAw1JL7RWRG/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EwBF4i5Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A672606BA94;
	Fri, 13 Nov 2026 16:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EwBF4i5Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C971F000C7;
	Fri, 13 Nov 2026 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585785;
	bh=DWq/HOLvvTx0AQE3ZsYnn5Cps535Euqai6R8CYzqj80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EwBF4i5QgMUVS/UA1DNjVhC+clnBCFK6VYPmPZfGTEpNVzdnD8Ot3THameh7l4dJf
	 DKDNNG1hNdTCuBODvohEJ2HvSBC4rXV8nSJ18MNZ+ARWPWB1H95zeU2CA6xi5RXIxa
	 eMSKz/mop5k8XOQJW+5O2M69sZsOMDE4vuKl6dqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 367/507] drm/amd/display: Keep the nominal vtotal while VRR is inactive
Date: Fri, 13 Nov 2026 10:51:11 -0500
Message-ID: <20261113153808.481549841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit f2853a06e4b923c77a8cba69d76d2222b198256b ]

Commit 33c995709121 ("drm/amd/display: Allow VRR params change if
unsynced with the stream") derives the inactive vtotal from
max_refresh_in_uhz and rounds it up. The round trip through integer
rates can add a line even with VRR off. The ASUS ROG Xbox Ally X20's
120.0004 Hz mode exceeds its 120 Hz EDID maximum, so 1152 lines
become 1153 and the CRTC vblank counter measures 119.89 Hz.

Take both limits from stream->timing.v_total, as
mod_freesync_build_vrr_params() does, which keeps the resync to the
stream's timing. Active VRR keeps the helper's rounding.

Fixes: 33c995709121 ("drm/amd/display: Allow VRR params change if unsynced with the stream")
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 428c95d380f07694cbbd9ebe3450214404f57b5a)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index 4bd060e30799a..f154a619b5339 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -1281,10 +1281,8 @@ void mod_freesync_handle_v_update(struct mod_freesync *mod_freesync,
 	 * If VRR is inactive, set vtotal min and max to nominal vtotal
 	 */
 	 if (in_out_vrr->state == VRR_STATE_INACTIVE) {
-		in_out_vrr->adjust.v_total_min =
-			mod_freesync_calc_v_total_from_refresh(stream,
-				in_out_vrr->max_refresh_in_uhz);
-		in_out_vrr->adjust.v_total_max = in_out_vrr->adjust.v_total_min;
+		in_out_vrr->adjust.v_total_min = stream->timing.v_total;
+		in_out_vrr->adjust.v_total_max = stream->timing.v_total;
 		return;
 	}
 }
-- 
2.53.0



