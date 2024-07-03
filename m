Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894AE1487CE;
	Wed,  3 Jul 2024 11:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006199; cv=none; b=ndRqF0AJfIzIf0mjObiU8f5PoYA8+lEUnUoONKzBrsWtjLkox0GcyXN9KeqHuT7+hKQHJ30C6tPKmZNDY3GeNLqaURwkCBH7pBpwaSux84E8DChatTMy6kW/5TedEBtU1Xez+hvS0+ZlKG+euIkTI7SxAL7F5yHIhDdme26SCFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006199; c=relaxed/simple;
	bh=2EAMCMIEOIMpQtbQYRy2Z4GNSRh1v6Pi+P6Hgm7DV+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJoP5Xf7EvofHOzdsPo8ojLvbDFmnTVXO205f5+VURcZBkwvDsbBnfEqDDGARZbYKKv0dVPDCoFIiQEGDQTLIOpIMA9aPG/z8/G/iWt61q0cSQW1APsI1+JHlXC3rZlwFgg+Uxe1l5xdIqn2rfZrc4xZM51iw/fuwio3tBoVE6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrOVUFLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrOVUFLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F73DC2BD10;
	Wed,  3 Jul 2024 11:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006199;
	bh=2EAMCMIEOIMpQtbQYRy2Z4GNSRh1v6Pi+P6Hgm7DV+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrOVUFLTyWXze4C9hkFLaC6hrlLJKV1X+OvsQM9dDWvLVll1VELWrR3TpXPr28I/l
	 suPJYU1/5YLV5Et5KPMJjTckU+AQinSdhpxPMr69I+b6RSa6y4zP9wwlSyldpj5/BH
	 YdC8FQh+XGd3aEwZt0OWteSbHxQt0vjINf7/9RYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 333/356] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes
Date: Wed,  3 Jul 2024 12:41:09 +0200
Message-ID: <20240703102925.708716950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


