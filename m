Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053944;
	b=QMMr8jOBke0+5T1WIWt36SyB5obi8Qe+aP+0PykTBRSU3v2SyUcuitG2CuBU7BbVq156
	 tumhaYwTjYPAMI4usoLGTuuJrOq+nFc89tAG3I7hglcr9bzagQFZ64G4WtBwU6IGCL44z
	 r0hEMy7ZOjliP2hhvtUyoB8Qoi1mlFKDzNPUdgUn1G1ny94WNAO+xLy+YrK/GHYtNMmsm
	 5AxVZrLQ0nzOYU/BfuSHfo6URtowN1i5Iurog0wtyvFvOGuln+JPOqSann5VRv4Ul1WzI
	 hZObgy1x27vUFB25zloUqciIH7WGUXzF4DxzDBqvPyuasDpSeAiR67Ivt8X6GDN03Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x9xAOLfV9Pq5YsC0LckyXVXMyeELMP/smmh/SxNlRFU=;
	b=d9tySmbX0mHEYdyu7siV6hZrtblSvpwCaLnf/P8MxX2Z9BT+rvhGxw2tGAEpbnZImgdx
	 uJhCy/AcdKdZ7svMC+Cx/NB7nsZr1QD1RCjRsnACAv+iaBFBj0QbCEgCadKx8kcg0FCYg
	 pa9RYR0U4QLARkBDmbD9Vp8+gnQDyIRIrQkwPRgUDsnJJ9A+dXEza4kSsuD3dE6JvhwKS
	 xBK/oy0RCS29x0kKQJ53ugvM4jKYPXk/OD1hsKUMjUULafAHXH5JY3ObCKgaakhdz6rcz
	 q57nQSeLPpTf3RpRUjdeJPM+cBv6pnqmDhAdndPR4W0RAD0cQX14QMuSRQtkShkC/ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HwoS/1zD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FE0606A325;
	Thu, 19 Nov 2026 02:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HwoS/1zD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494691F000C4;
	Thu, 19 Nov 2026 02:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053943;
	bh=x9xAOLfV9Pq5YsC0LckyXVXMyeELMP/smmh/SxNlRFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwoS/1zD/+tHj6R2z6Az4x6Tn72PXzskVPf013qlzsNklLexDs7UeEiyuugj4BmDH
	 2N0lUxuTiK3O0ypUdgdrW5y1f/6nIRLUo7JQynjGSWcGrF482U5eUcqzEfreEQXs9G
	 T8CD+Ky8s12N6l5Nyuzn1B8nDs7pwpXRRxFsPuQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1098/2214] fbcon: Retry rotated font allocation after failure
Date: Wed, 18 Nov 2026 15:46:14 +0100
Message-ID: <20261118150056.126112145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Yiqi <yaoyiqi3@huawei.com>

[ Upstream commit 7935db1a4a0f83a63590a222500e5016e2f6c85e ]

fbcon_rotate_font() records the font, its geometry and the rotation in
par->rotated before calling font_data_rotate(). If the allocation
fails, the error path clears par->rotated.buf, but the recorded key
already looks up to date, so the next call takes the early-out and
never retries. The rotated putcs/cursor ops keep returning early on
the NULL buffer, and the console stays blank even after memory is
available again.

Also test par->rotated.buf in the early-out, so a failed allocation
is retried on the next call: at the next fbcon_switch(),
fbcon_modechanged() or font change.

Fixes: e4ef723d8975 ("fbcon: Avoid OOB font access if console rotation fails")
Cc: stable@vger.kernel.org
Signed-off-by: Yao Yiqi <yaoyiqi3@huawei.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
[ sashal: Adapted the cached buffer check from par->rotated.buf to par->fontbuffer in the existing font cache condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon_rotate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon_rotate.c b/drivers/video/fbdev/core/fbcon_rotate.c
index 66b35613368e1..f7e03c17f94be 100644
--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -27,7 +27,8 @@ static int fbcon_rotate_font(struct fb_info *info, struct vc_data *vc)
 	u8 *dst;
 
 	if (vc->vc_font.data == par->fontdata &&
-	    par->p->con_rotate == par->cur_rotate)
+	    par->p->con_rotate == par->cur_rotate &&
+	    par->fontbuffer)
 		goto finished;
 
 	src = par->fontdata = vc->vc_font.data;
-- 
2.53.0



