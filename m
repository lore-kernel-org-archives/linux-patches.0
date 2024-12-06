Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96981F4735;
	Fri,  6 Dec 2024 15:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498722; cv=none; b=dRESTfUDx81xmR1R1RA7vSiNha2kRfxiXE4oim6n1t2HT9lHCA06FtsxAH5kN/onEcFwHifOare9rq/QkBG39wEOyQljSUkoqMvrTu7cLHooiNUWWu16FU8HWjJAIOVCS1PzGcRT8MeigqhfACpW2jEBIiCAjnbl9Ix6NPDX34o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498722; c=relaxed/simple;
	bh=Rvv4jMkJvjGwnN1LtEWQlunDRBZJFxKdtd/XEmvEhtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+wpRUciKJRYOHyQv6GXtXk4xH/djEPLoJZS2TyA+PUDBX8e5t8rMhB81R8uW2sbs8DSUhhmgU27E3GB6R7CVvhWB6UgLYIzddexKaEXA2L5oJ0fSKgGAJL96471Eo6PmegVDQZmg8iLhWS1edt++Dwli9u3Byad7XHZUDwgIHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvCKeyq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvCKeyq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47905C4CED1;
	Fri,  6 Dec 2024 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498722;
	bh=Rvv4jMkJvjGwnN1LtEWQlunDRBZJFxKdtd/XEmvEhtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvCKeyq+7Y+N7wgkVf5nzW+wgmmE378OlR/Zk9VCdAoYS2aqFXdB6rUL26vW+uUKZ
	 +PKju7wzR1KgIylqGudON3pF/P4Ptve4ti9GB6UOf5R9Opc3Io3usy3Ds5c2Phhm/8
	 FddzCS7KNRnpCbDGlse7PsFwJgE/mBqu0ezHfsMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.6 669/676] drm/sti: avoid potential dereference of error pointers
Date: Fri,  6 Dec 2024 15:38:08 +0100
Message-ID: <20241206143719.502701627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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


