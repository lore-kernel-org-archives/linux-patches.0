Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70305223E8C;
	Thu, 12 Dec 2024 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023006; cv=none; b=onnZqW8wu+h/pONje1eDk5Pacw5ZweCh4H6oBpdbfGuqL1Lfp2pm+/IuA3qlDf/tD5gXDPKs7kXvmvrmWQa3rZPlnR//VTGfA1NRH+WGtX8INSgT479ccYJNyhVR5+sN9rluSFGamcD20tixid1Z93FIcEO5L8nWEPn/qQjAfBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023006; c=relaxed/simple;
	bh=hvj0wsJn79LjhWw3MBlnLE5qHZgYC49it8fjk0I42s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txhZ3WqvQDLRrC1sq9MRgzg04SIOCzhHGLatO94vIOBVmu3FYtKupN99Y2VjysqYekx4wIBsqwgy9B0crxk3u4zNbFz8Qkbny3XCV754mEn1Mh3WnTZ4ieiykVtDTu12PPhsNS/+QaMqtSRmINXDZraxDipF8a1pu2bBA3bk6sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYysPcRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYysPcRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C01C4CECE;
	Thu, 12 Dec 2024 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023006;
	bh=hvj0wsJn79LjhWw3MBlnLE5qHZgYC49it8fjk0I42s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYysPcRR9XIFpwpe5XwNjOCuWh8rG+RRTkyrkFm0jWUyPaGttYOlwe3hybF96kh7p
	 2x9txhWTMZe/ulUc+QyEZgGjOzAhW7EaxA8byqH0IzPRVY0ZwWV0L2iULM0CjCCSkK
	 N06FlKPngCZzR8xPIFJ+lch3UFDd0dyCuKMY1oYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 5.15 395/565] drm/sti: avoid potential dereference of error pointers in sti_gdp_atomic_check
Date: Thu, 12 Dec 2024 15:59:50 +0100
Message-ID: <20241212144327.261164129@linuxfoundation.org>
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
@@ -636,6 +636,9 @@ static int sti_gdp_atomic_check(struct d
 
 	mixer = to_sti_mixer(crtc);
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
 	mode = &crtc_state->mode;
 	dst_x = new_plane_state->crtc_x;
 	dst_y = new_plane_state->crtc_y;


