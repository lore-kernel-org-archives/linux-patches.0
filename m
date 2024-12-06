Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E198953A7;
	Fri,  6 Dec 2024 15:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498716; cv=none; b=pABHF/C6izV5xsxXIlsR92kuhJnTxZdYJBg8OkH+YeXEJ7SxQIVHVbIGaJ6JyaRXmi4J021BiqZi9CSGpEGOJz08CbRwHerNDJBXuxbrYwuuLavqHa0tlf9xW5W5RW7ymNQJDXWpW3YvYjVoMQ2OyhI9aP3YQ/+Lsb+EzsLaLWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498716; c=relaxed/simple;
	bh=pV4UIbrHAKGosL2LY05e5stYN08/sVrrh923RvDcgeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNE4yn3q0lTMw+nJ1N7RTtEjliq7sBetTinrWdZpQwDQpSrpXDKzfS7VbuYSii0/c6h1gcOzeRFozM+7yRajBFo2PjcGb2Mk/dO+mkBd0/5Ozy4/v8KBS1a7kNdyR4IryHQzVooj14YYGNFbQWhBAyd5plmznDrNitwUN8D1Ncg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8CfTciB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8CfTciB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF12C4CED1;
	Fri,  6 Dec 2024 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498715;
	bh=pV4UIbrHAKGosL2LY05e5stYN08/sVrrh923RvDcgeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8CfTciBtuSXyoJuxT+HfI2XJ0ZV/QMLLVjkkHpyYgxhJeOVYlrpYKs6G2y0lf5pt
	 gGHycVc5P3JIHF3NBv2453aTKJ+9zaL59L3ffOr5KOq9Bi/c88HBDnJoQe7Darklu8
	 hypjlhPZ7mwEBC6z19yZ3K1Q6wm5lI+1TC/u/FyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.6 667/676] drm/sti: avoid potential dereference of error pointers in sti_hqvdp_atomic_check
Date: Fri,  6 Dec 2024 15:38:06 +0100
Message-ID: <20241206143719.424631540@linuxfoundation.org>
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
@@ -1037,6 +1037,9 @@ static int sti_hqvdp_atomic_check(struct
 		return 0;
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
 	mode = &crtc_state->mode;
 	dst_x = new_plane_state->crtc_x;
 	dst_y = new_plane_state->crtc_y;


