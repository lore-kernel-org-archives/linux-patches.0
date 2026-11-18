Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037014;
	b=bhC1cGLrc/OmWr0plq3w9MDAzM9wHY6+iFfRJLaWp7ZRdNSHlShGczSCFHED6oSmlhV+
	 9slqyhRgckP6kB+q4WrOkOmPGmAIeW8welo3I7nmoGG4olv7ihyfabVi9sI4yRcmLn7CT
	 w3XG1ygMLxvA46a3c5q0VeAqLbikNtAjZdU+93hX2976i5Ws4396wKQ/WlpaiinjuWJjo
	 vw0ENGHL+f0bKaERzfNpcMW2TCR1lfK3AdnLr0PL76Gu8u+qcUB7cbljIcgr8T+XLilHD
	 OSHHvbQDs0Jv9Udq+0r9slIm0SQ1l7lmyh+yJ+dFtf+COKa06Tonzz5d6oJLkX00skg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b0htGrEcpOKWhTHECnQDaOalhlqvVrDcTI6iauv2ZFk=;
	b=OZJDjOw1me9xoecYxnd0TVZ0LASps6BU8xQ8weDXt1N9aEr61W6PAhpLa120siOzWpZm
	 6Mt/q4W7Am9tQx3usqxtsmRax/NHHqI2yeLUJf/Zh9+EGw+54sl+cX8MzR/LLYHujJ0sc
	 gxfn0P8jlQ9mASKW1jvG6bNjQnfGi2TbR01701m3+CVU+PGPa1u/pH1Yp3zneWXEDEKjh
	 JOI1jxHqp5zfpJgjh34lv9N/U/qaWRa94GlDEKeNfOlZ+BZyRb6wAV4bI06BnM17lihkN
	 jDKPZp3UYcGoAa2Q6hnIjQFI0lHiI9yf+mxjSE/yAtMVtfr7hm3C726DAWtqZaiqrGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMIeBR4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55906606A31C;
	Wed, 18 Nov 2026 21:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMIeBR4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3DD1F000C5;
	Wed, 18 Nov 2026 21:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037014;
	bh=b0htGrEcpOKWhTHECnQDaOalhlqvVrDcTI6iauv2ZFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMIeBR4evOwB971C9uSXoAFDZHoI1QsgXpO7jGDBmmnohoUf4y9jcOBFAx80HF25p
	 Ec2PfbNZ7uiWXIN8DFfvtY2ywLEYUrqwL2P0/zmXtqcVPWOZhZ7X1+QP2VELWEl6qb
	 XUsmG5aN9HfAJisEFoSnVFB9aPIrRakoyPET15ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1263/3318] drm/amd/display: take a runtime PM reference only when a CRTC turns on
Date: Wed, 18 Nov 2026 15:31:25 +0100
Message-ID: <20261118150358.105205441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luigi Lauro <luigi.lauro@gmail.com>

[ Upstream commit b456f591f925fbd6b33770d0eec1b51c2f9d41c1 ]

amdgpu_dm_commit_streams() takes a runtime PM reference for every
active CRTC that needs a modeset and has a new stream, but
amdgpu_dm_atomic_commit_tail() drops one only for each CRTC that goes
from active to inactive. A modeset of a CRTC that is already active (a
mode change, or anything else that needs a full modeset) therefore
leaks one reference. Once that has happened, the usage count no longer
returns to zero with every CRTC off, and the device cannot runtime
suspend again until reboot. The two also disagree the other way when a
CRTC turns on without a stream ("Failed to create new stream"): no
reference is taken, but one is dropped when it turns off.

Take the reference in the loop that counts the disabled CRTCs, on the
mirror condition: when the CRTC goes from inactive to active, which is
what the commit that added it intended ("every time we enable a
previously disabled CRTC"). Each active CRTC then holds exactly one
reference.

Tested on an RX 9070 XT (Navi 48) over OCuLink, with the change
backported to 7.2.9: an unplugged connector forced on, then mode A on a
CRTC, mode B on the same active CRTC, and the CRTC off, three rounds in
a row. The usage count rose by 3 with the stock module, by 0 with this
patch, and by 3 again after reloading the stock module.

Fixes: 97028037a38a ("drm/amdgpu: Grab/put runtime PM references in atomic_commit_tail()")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5951
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luigi Lauro <luigi.lauro@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 59ef9a435499777b8e1c4e0eff52f813c64fb920)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index bc86394d13d92..d79f39dd21ac5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8676,8 +8676,6 @@ static void amdgpu_dm_commit_streams(struct drm_atomic_state *state,
 			if (dm_old_crtc_state->stream)
 				remove_stream(adev, acrtc, dm_old_crtc_state->stream);
 
-			pm_runtime_get_noresume(dev->dev);
-
 			acrtc->enabled = true;
 			acrtc->hw_mode = new_crtc_state->mode;
 			crtc->hwmode = new_crtc_state->mode;
@@ -8983,8 +8981,13 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 #ifdef CONFIG_DEBUG_FS
 		enum amdgpu_dm_pipe_crc_source cur_crc_src;
 #endif
-		/* Count number of newly disabled CRTCs for dropping PM refs later. */
-		if (old_crtc_state->active && !new_crtc_state->active)
+		/*
+		 * One runtime PM reference per active CRTC: take it when the
+		 * CRTC turns on, count it when it turns off for dropping later.
+		 */
+		if (!old_crtc_state->active && new_crtc_state->active)
+			pm_runtime_get_noresume(dev->dev);
+		else if (old_crtc_state->active && !new_crtc_state->active)
 			crtc_disable_count++;
 
 		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-- 
2.53.0



