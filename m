Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065488;
	b=k6BVyO0cgZSjj5+d2atS+OJ4HQE3mfMJhpDEARnCfU6i5v5uyTRB8BGgCLZ8MwdeUMgd
	 QyNf9XTCqGfRV3p/Tdz6qOuviUUOK3WkQu7zUE/Co7BtrLikpK0LJ8NXJMlGdtfhEZjrI
	 A6DYslYUuKuke7BnpUMYfTSIvV/FmEYOAkf3T8vji/uy0yKeg9BXPCsupxhUOZLJKcNRz
	 K8F0o4UGzsuCbuD3xhRrtrrIdf0kyaysRNJh/lOs5O/ZI5u9nAwFmBeghy5W4i1W3ccEJ
	 W+OQArmA3cdI1bbw1JuG560wmAgcOp1yaxKri3kFXJTFQFJK64SfHmayJb4itSTVwIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7q5IG/5j265vpfv7shWXOV2tYvOhHkArUKLh0dONpTo=;
	b=yr+L+I1jiO4QJ43rCn7OYBAr0uKaM1AYKaDV9eLJmEtM7niR4+5fPLul6U0Owc2ve/AJ
	 9o1w54R7c2qaVotKAo2sypIraoxJ4FZmdyjNBDwhX7yOFXPY02z0m7QH2fZYtuR5pPeRC
	 gPsaSj4HtMe8wAbpYWQmppXz7rAmhdk2WfFUlNhzIDXYsYLkatZrwljV+Lf/EhUDL+nth
	 TfjooCh4XpjIciv1D17PbPMbLD9UzqDOD19D2Dl6AhROepy7+Ss1pKO8aAoZjGrwXpHmk
	 A8CtM3opRJr+M8LeN7LYXeAX9dSVQVqGGhkQ2JrVTgrBTg9J/pMegO+WY/D5iwKZKWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKeFgbMG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29262606A32C;
	Sat,  7 Nov 2026 15:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKeFgbMG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDABC1F0089F;
	Sat,  7 Nov 2026 15:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065488;
	bh=7q5IG/5j265vpfv7shWXOV2tYvOhHkArUKLh0dONpTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKeFgbMG+idaPr8LalKJZhZOSUq4ZC91BygStCAmJ3ONB7aWrbwhZ6UmqQDaRegDq
	 eKpN0CFheFGbbTyEwGJScr+JIL75hqq9fzCDDZMBWkZo3UmCXJ0kxlOx9YfyLRWbL1
	 bs36A5TQCmfZN8Y9q/tf/v3yijOpDcDmF0tFBNSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1180/1257] drm/amd/display: take a runtime PM reference only when a CRTC turns on
Date: Sat,  7 Nov 2026 08:57:56 -0500
Message-ID: <20261107135011.763827780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 47a0ff2ed0359..0c92f9c5d5825 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4597,8 +4597,6 @@ static void amdgpu_dm_commit_streams(struct drm_atomic_commit *state,
 			if (dm_old_crtc_state->stream)
 				remove_stream(adev, acrtc, dm_old_crtc_state->stream);
 
-			pm_runtime_get_noresume(dev->dev);
-
 			acrtc->enabled = true;
 			acrtc->hw_mode = new_crtc_state->mode;
 			crtc->hwmode = new_crtc_state->mode;
@@ -5178,8 +5176,13 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_commit *state)
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



