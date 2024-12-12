Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C043D22652A;
	Thu, 12 Dec 2024 16:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020571; cv=none; b=FMNbqynr7AGpDsGzsMFIrpF5q+l37oZznRyymco+Ncvua7xMJ7wppF6TcT1uc5J7ECUYkBW/xPdiTwgjwX2bFQnAVg9Y8WTd2j3Y7L/y1UF+HHw+7thQyadK4DCHyakIsw6AIMstKk8cYXqiahxENfvlyCnnS5B3r2/xOv2yHz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020571; c=relaxed/simple;
	bh=+ZePz8/tL5d50839kDhHiNOgWVdGnI+30nQcIod+jqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCvxd2E2ug/qL3IaqctizgW4AtWs4PTPn2azxb2U9ma5alyI2fipDdgVW3t0ZktmN2dD0sWvcmonT0tHIX1Vo0gkiN+tQrlF8D4AsGZBVc32eQ2mvQwJ8R7LlcWddtKjlNFPUac7QIUvLR9n1tOMx0TUFedTavXs6EVHbUah6dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlUsHNi1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlUsHNi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E44C4CED0;
	Thu, 12 Dec 2024 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020571;
	bh=+ZePz8/tL5d50839kDhHiNOgWVdGnI+30nQcIod+jqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlUsHNi1zL6C5lhLrURoGPSivgsCOmdxizE+Tf0785jBlkOpWav4Dy7HhMHLTyenb
	 hZj7MHj+ri3Wpngbb1lGUgWPfCSAQhcwb07pS6lT8TDIXg6WpcsXDujqsxv/lNFCZm
	 hroY7/tKXI78FR75y894cGVYwa9KTwwB9bGhudeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.1 503/772] drm/sti: avoid potential dereference of error pointers in sti_gdp_atomic_check
Date: Thu, 12 Dec 2024 15:57:28 +0100
Message-ID: <20241212144410.747445441@linuxfoundation.org>
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

commit e965e771b069421c233d674c3c8cd8c7f7245f42 upstream.

The return value of drm_atomic_get_crtc_state() needs to be
checked. To avoid use of error pointer 'crtc_state' in case
of the failure.

Cc: stable@vger.kernel.org
Fixes: dd86dc2f9ae1 ("drm/sti: implement atomic_check for the planes")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240909063359.1197065-1-make24@iscas.ac.cn
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sti/sti_gdp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/sti/sti_gdp.c
+++ b/drivers/gpu/drm/sti/sti_gdp.c
@@ -638,6 +638,9 @@ static int sti_gdp_atomic_check(struct d
 
 	mixer = to_sti_mixer(crtc);
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
 	mode = &crtc_state->mode;
 	dst_x = new_plane_state->crtc_x;
 	dst_y = new_plane_state->crtc_y;


