Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B77237FE0;
	Thu, 12 Dec 2024 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020575; cv=none; b=ajQuNcSn1Qed9ITJXRWNId8TkMQWRxt50QaRKvqQo4jRPOKVyTjM5fI8hIa4cn9zDw4Bq31DUNc/GvGDJqHSd/Po/rfN6OxFOonEePJ2vbFhKXvPcDLZX+8Ek+3BDWG+aOsPYVRqQPkkyUgLeag8TAuulwJCkNLzVDQcih9oNN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020575; c=relaxed/simple;
	bh=8ZWna/XYIjvNSvwfje03LtLErpHzm/xKb/UXbqY1p4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zz8Fw8K2RfCARLK14ozSS76VtH6vdzLEevPg8qXNF8jmk6WTrniqDOSW8yx+8Z1FsliAwxBgpcYnKksYdxi4siRuAmTFwnG5lytProvIrGZNTISgSLkWkMwurTAIzqg2LVVsFBHMaqcbix20e+snWTkcU1wjtGI9Q69xJdcluTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyOd/Iy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyOd/Iy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D214DC4CECE;
	Thu, 12 Dec 2024 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020575;
	bh=8ZWna/XYIjvNSvwfje03LtLErpHzm/xKb/UXbqY1p4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyOd/Iy5Wn4JS1rVAZAkwvPt2574xPpxpd5XX83HonaaMjq6tBTJ7wclSJEo1HjTZ
	 nupF2naPvVX0j7lcJcsTkmMvcisKaPcK/iK2zRj7BvBGdTglxPbizfZXp7+x1f7Nsc
	 mpX4claK7eMpzYH/olyJJncLznnX7LmBhoyD4keU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.1 504/772] drm/sti: avoid potential dereference of error pointers
Date: Thu, 12 Dec 2024 15:57:29 +0100
Message-ID: <20241212144410.787417059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -200,6 +200,9 @@ static int sti_cursor_atomic_check(struc
 		return 0;
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
 	mode = &crtc_state->mode;
 	dst_x = new_plane_state->crtc_x;
 	dst_y = new_plane_state->crtc_y;


