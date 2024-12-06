Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AB113D516;
	Fri,  6 Dec 2024 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496434; cv=none; b=NpDM3pAyOeSkITHVRlB8uyYtUaOcJiWFRZwpmqaBar+lmwrzyDMAOr68nVJpnu4GR8kBQB74o1/BNoVJyQv2ggHYpYcRaT5mApz1nzv3hyFbuL81pcGS4PA9/8i92DH/aUTFtqm5x+W58VbWtpndXdjtADQ66zDQ4UG5mtb3X0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496434; c=relaxed/simple;
	bh=8F4au+M7BRt2nZmCVvZD5JJTE6lCFVrG3p1y8tfILZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s99Rb34GZ84dQQ0EsVwD2A2fS+anmpm7uCBTumRDc7xNZC8prUUVx3jnMWdQCU8nBYGUruOOF1oXXMMMZAjlhiHVjU3mRT6PFJXRNvB/iFFJ1Wf3min6m2xkY3QtPwB5OcriHRHGlfQ+1qALL3CXGrRJMflvpmfb7RoVHxt0XEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bo36luZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bo36luZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EDAC4CED1;
	Fri,  6 Dec 2024 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496434;
	bh=8F4au+M7BRt2nZmCVvZD5JJTE6lCFVrG3p1y8tfILZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bo36luZTla23GbXSOt6EltlgzzDFPkw4DMlwbtGnNFLrCDE2VEv6d2xtWx0UIgMqA
	 /HP+swTCT7AizE35SbTOUeY4iVD3W/nfC+3LqZ7MMD9hF/x3YsTK5Lz7tnOVJrfSNR
	 2ppCi1UbRvMwcvcJFywXHgVLmejNH2P35CC/5BBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.12 121/146] drm/sti: avoid potential dereference of error pointers in sti_gdp_atomic_check
Date: Fri,  6 Dec 2024 15:37:32 +0100
Message-ID: <20241206143532.313807630@linuxfoundation.org>
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


