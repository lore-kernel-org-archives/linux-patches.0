Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45510E0;
	Fri,  6 Dec 2024 14:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496431; cv=none; b=kAYpNAZhVB1zNLHEJ0KXMCI/yz4c6R4ykg5dSwh0y3urKh1AE+95l9+yA+W7mZKbR2TOhKGCeBmCLZF6gXmZor0Yvk3Wt6j3Erk5sRuuhpzWyMskGiPxYRobsis0XzuRvKTwhPHDur13CQAdeFTp4V3RDvm5ZprwYCixImQralA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496431; c=relaxed/simple;
	bh=Necrdf+/4ZMJLwJ+V6lpBZQ5Y4t+Evm4ysRXmcNbRGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVM6QkQYQ4k2bEnDk71THtwhZybws7QzLDl0UO0MiHDbwpfUlxSrNPn1vrX7seP0MxEyhyADO4vpaSynlKCCl94jlpGOboZVpL4+zXf2G3DKC5uU8ldC/QGCOW0tqsZBExzIERuxN9k9L484iNC52r4uguhnSmLZh+uAIzOv9pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIPg0MVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIPg0MVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00FBC4CED1;
	Fri,  6 Dec 2024 14:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496431;
	bh=Necrdf+/4ZMJLwJ+V6lpBZQ5Y4t+Evm4ysRXmcNbRGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIPg0MVpgajZVQ9Y5nge2MaYskbzFPtXN7F+4K1AMBZVFf42SQ1Te7TctmfQkvwIN
	 idzDdNNuif2TKjRaxRqJJiiyJ0wXbgLDTvWynx+Kq37pW0Te6RF8AddpClp7V90TqG
	 jxvcTN7VgpN1wg4s7lUIRe2cKMCWsROe4KdY0jiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.12 120/146] drm/sti: avoid potential dereference of error pointers in sti_hqvdp_atomic_check
Date: Fri,  6 Dec 2024 15:37:31 +0100
Message-ID: <20241206143532.275963231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit c1ab40a1fdfee732c7e6ff2fb8253760293e47e8 upstream.

The return value of drm_atomic_get_crtc_state() needs to be
checked. To avoid use of error pointer 'crtc_state' in case
of the failure.

Cc: stable@vger.kernel.org
Fixes: dd86dc2f9ae1 ("drm/sti: implement atomic_check for the planes")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patchwork.freedesktop.org/patch/msgid/20240913090926.2023716-1-make24@iscas.ac.cn
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sti/sti_hqvdp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/sti/sti_hqvdp.c
+++ b/drivers/gpu/drm/sti/sti_hqvdp.c
@@ -1037,6 +1037,9 @@ static int sti_hqvdp_atomic_check(struct
 		return 0;
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
 	mode = &crtc_state->mode;
 	dst_x = new_plane_state->crtc_x;
 	dst_y = new_plane_state->crtc_y;


