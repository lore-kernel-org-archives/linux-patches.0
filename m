Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CEB223E64;
	Thu, 12 Dec 2024 17:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023003; cv=none; b=POekPlGj2rRWBFHruWRedS3Bna807ftVzc3HVeLCa82FTyrOGpUdfEVmBml9a5oKJeziSVGOPhmA+wG9aKC2aVNVIM433DIXoE4yRmCRXBHsYSce1BbCvEu3e02g1pl/az9eUKvBlpuEKi0YSNgM++pWQvCaneaXFftGbGlFM+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023003; c=relaxed/simple;
	bh=Hixige3tTxzoZ9v6dL8MYATlTAdBj4X39q+htXJV3uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFaWIx/fS1tw8B54ZcUo3uUxNvQhFhb1GDYmYXK3S/GbIqBoKCp6Tdh9S2ONBcfkjMakSI2xhMWEsmKl6/zWWj+Are4joRHgsR8p10Wi7162mNowkaI9MKZG6m5FpCMTLphNs9zWNw+lqTOSCq55B/xjAaWzy+hLREynKIDBEpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1RSQCNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1RSQCNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF4FC4CECE;
	Thu, 12 Dec 2024 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023002;
	bh=Hixige3tTxzoZ9v6dL8MYATlTAdBj4X39q+htXJV3uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1RSQCNgtnux6CJtprNFyvz9M+c54Y5r0E2Npz+ddotUm8BAbO8rvT2lwY4bWd0u1
	 NMKDLFdbxUC3RFUs2E/EVizlPHK7Yazz59jpzfynXsMhcBwEz4KszzZVTbMzlpziNc
	 bY1qhEMuj9KGVLDH88r7nEUYN92pcFh3aZ6Jqdy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 5.15 394/565] drm/sti: avoid potential dereference of error pointers in sti_hqvdp_atomic_check
Date: Thu, 12 Dec 2024 15:59:49 +0100
Message-ID: <20241212144327.220908802@linuxfoundation.org>
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
@@ -1035,6 +1035,9 @@ static int sti_hqvdp_atomic_check(struct
 		return 0;
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
 	mode = &crtc_state->mode;
 	dst_x = new_plane_state->crtc_x;
 	dst_y = new_plane_state->crtc_y;


