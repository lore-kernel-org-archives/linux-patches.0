Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497CE10E0;
	Fri,  6 Dec 2024 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496441; cv=none; b=LIzVpuC9b8/W+Stgs3vcOjWGl4V734OJqM/tfI8ADLtq4mWXOPlcNl+ihtd84r6DXOp1TKZrPM86AM3UBnZk2OLGJSQeEktY9I3WedjjNSXCiu6+PCK/kr3rD6kzqlRbruS2OQ1eIE+txPoWxOj3kUGvjSGA13J++8Q9fYUvsOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496441; c=relaxed/simple;
	bh=ERe56//bMKh6lOtLdSu5Qr//Dt08frU83UQjVqfeJKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obIC52R8IL9coPW+OtQjiR88AFBQFVRiwbpY4kMR5A/lqsJCYAYUWNlp3Q42Zkt4ek4Mh+D++K3rlv+WqBZvpmqmlHkMFCXZySECZ4KgJY36bUljKVrFNPf0tSNRhD/8nrCSWL6yURXlhRk2pTaoLCFeM+LIyoYdk7PFLO8alXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKdjjf3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKdjjf3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17C4C4CED1;
	Fri,  6 Dec 2024 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496441;
	bh=ERe56//bMKh6lOtLdSu5Qr//Dt08frU83UQjVqfeJKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKdjjf3MteZkWw2NdcyzwFCd14LUtGqg4Y69S20NUucW/vLh3mJMNz/YFKXP4M1kk
	 WEVBwxSVmkmcz9lEOyaCd3fx89R7LUsBpLXSPYfw42O4r09vLhWZJQydMyP9SKjo4+
	 11Lzx5imgH9NG9ElG//DN2OHfH+48pnYkH04Wka0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.12 123/146] drm/sti: avoid potential dereference of error pointers
Date: Fri,  6 Dec 2024 15:37:34 +0100
Message-ID: <20241206143532.389680657@linuxfoundation.org>
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


