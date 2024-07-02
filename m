Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5801BD4E9;
	Tue,  2 Jul 2024 17:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941153; cv=none; b=jI+Qj41kUw80mk1afAkII79VtwXHvCnwf1QQpzIsbG/65N2JwURzbg6nJ8kboW2T8EfY6qQnVBrD00/sDEm6ykLufsHv6cN2RCg4J9XmGd9oC5reW/gzRyJJjh1DReyi3sjVBlcQ/2M4oP5WBUwv7wG4h+ln+eWt8Q8FyQx7Pu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941153; c=relaxed/simple;
	bh=7vjweHlSL3g7uvee6JieEJwwoB//3RFLK9joj4qhVRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6YhdUWjr/Mxov4YU1NJRCJtbMpWl35ws8pFaxJaARMXFnJue5LCUfU39Je5xczR4Sr/DHK9Vb4/K6XEtqgfU97TfGs/T6n4KdpfKfAnqoctMhnlNu4MIpCfvEW0ILtDa/cyxumIfk3w05lQtitw1S0D7qStBtCJ7hZ3i26L458=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2g6BYGsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2g6BYGsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8595C116B1;
	Tue,  2 Jul 2024 17:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941153;
	bh=7vjweHlSL3g7uvee6JieEJwwoB//3RFLK9joj4qhVRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2g6BYGsV6cXhQ0tKp35q6wybLPX4/X1Lr2jrByEMz+8YRWpp3u3ypCOJ6iGp9P98e
	 Tf9NS5r6fBt16uRuIVyQDcl5jje/FgIQvzDzI0BexPSWG+K26lAo2X9jG3R1Xr2TKQ
	 /8rAm6AKxAe1ybrSSHYNH9n2Zy6cakBPQLGFAfG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.6 136/163] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes
Date: Tue,  2 Jul 2024 19:04:10 +0200
Message-ID: <20240702170238.200491841@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -209,6 +209,8 @@ static int nv17_tv_get_ld_modes(struct d
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(encoder->dev, tv_mode);
+		if (!mode)
+			continue;
 
 		mode->clock = tv_norm->tv_enc_mode.vrefresh *
 			mode->htotal / 1000 *


