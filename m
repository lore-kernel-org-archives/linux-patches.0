Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBC71940A2;
	Wed,  3 Jul 2024 10:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004270; cv=none; b=Hi7c95s95HXs/wK+rWZT8pf53xRQ+YlU24kq/Xj+GsA0LQ0dC2PDQ7ysfZU4UeCCZAkmJWG6nrQSgfVfY75lwsX4qVjpLapHrjFyYfP+pazDkHQH6PbB4+bIPP8YOgYfLv1jiclntVEE/aMyDYZo1ehJc3xkI57+X0ty1lPQMLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004270; c=relaxed/simple;
	bh=fZxUL2xI2+CSw+vgKE8YNHNididZzKSa7FrLkZXxUwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dc/tau/mkaVnW0lumutqasj8Pyre9cW9Y8P5bEcaZPREEEwJ2L0gwylAjPCFQplXIvRI7y41DZznNmoh311bFeFxgW0u4Rh/kSCXPyOOMC++E4BkG5rtPdWzNMqBjviC/zP9HoH7QI/cC81G1/g0S6R7Wc1n0aA0ZHnsiA85Ytc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0ulb1Jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0ulb1Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE14C2BD10;
	Wed,  3 Jul 2024 10:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004270;
	bh=fZxUL2xI2+CSw+vgKE8YNHNididZzKSa7FrLkZXxUwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0ulb1Jk0Ly3xfSswMXMwNctXdQti5jACN8u9CDdaPoDKEpInGmLWCPWL4XhelUus
	 MJxVxrd27ZAT9/yonNRv39L9Xp4Bxwq0w1drxxoNoFU53Mx4UQeJpqe/oQ0L+6rZAe
	 XNZ0jL7yxfbKAEANPCnR4bciy8quoVZYeJ0JiOnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.4 177/189] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes
Date: Wed,  3 Jul 2024 12:40:38 +0200
Message-ID: <20240703102848.152883166@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 66edf3fb331b6c55439b10f9862987b0916b3726 upstream.

In nv17_tv_get_ld_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240625081828.2620794-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
@@ -208,6 +208,8 @@ static int nv17_tv_get_ld_modes(struct d
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(encoder->dev, tv_mode);
+		if (!mode)
+			continue;
 
 		mode->clock = tv_norm->tv_enc_mode.vrefresh *
 			mode->htotal / 1000 *


