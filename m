Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A102E213E6B;
	Thu, 12 Dec 2024 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023010; cv=none; b=nESWyKH+N56Yl7faqMEFpkuQhlEVoz+ocz8HhIsECIsSG5wUghQ6H47JOr1iAhr4/M1spTrR/mmsGpxz/eWNx1v2WlqOSn3QVxFJ2P2ni5Stjyr9sjg8XUTJ4PHZfDvaryCDUZ/S8GSUAi6ADjoUjYPvzG8jXFUCxkqwFLF4mmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023010; c=relaxed/simple;
	bh=G7HP7JWA+O/Atvg5FgrByv3ZgGE8QEAkyF5XwTisHKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNiUyKM7mHMVPpyoR7NVLDDoAT/5CVX+fEAO/LdZDmsLcKWMop2S5nLVdBuoYwUJ1eGEoY1yj2O/QowPm7zi69pUBzNilNROZQ21OEylqrBWmISKzKfgXUXqITOGsIep+oTovR1mt0Yjpmy9M1H84vVorS0g5y/dJo+QVQKOWyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WExWbr3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WExWbr3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E032C4CECE;
	Thu, 12 Dec 2024 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023010;
	bh=G7HP7JWA+O/Atvg5FgrByv3ZgGE8QEAkyF5XwTisHKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WExWbr3m51I8tcPEqPTpe9JGjlnp9p7kVwovpxFDvWvqUEZjYHdLWJkDEd1POAb7P
	 iWF4PFkaI8x7nwGT2UB9/2zdJBxYJid5UW2Np540oPprghuR8DEkowKoQHA1pMN3KZ
	 euCP5x1QezBkxtaspGKMxPadcR2TYFPsoHEatYdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 5.15 396/565] drm/sti: avoid potential dereference of error pointers
Date: Thu, 12 Dec 2024 15:59:51 +0100
Message-ID: <20241212144327.302182178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

commit 831214f77037de02afc287eae93ce97f218d8c04 upstream.

The return value of drm_atomic_get_crtc_state() needs to be
checked. To avoid use of error pointer 'crtc_state' in case
of the failure.

Cc: stable@vger.kernel.org
Fixes: dd86dc2f9ae1 ("drm/sti: implement atomic_check for the planes")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patchwork.freedesktop.org/patch/msgid/20240913090412.2022848-1-make24@iscas.ac.cn
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sti/sti_cursor.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/sti/sti_cursor.c
+++ b/drivers/gpu/drm/sti/sti_cursor.c
@@ -199,6 +199,9 @@ static int sti_cursor_atomic_check(struc
 		return 0;
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
 	mode = &crtc_state->mode;
 	dst_x = new_plane_state->crtc_x;
 	dst_y = new_plane_state->crtc_y;


