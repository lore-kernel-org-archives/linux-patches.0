Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E9653A7;
	Fri,  6 Dec 2024 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498720; cv=none; b=CAKsOqqDOliZSQg64dT+b3WRO6v7t0sZMTrVE6N3W4QTCH8pBjTX1bbJ0CyesT+Yu6t4/pOrEJkm3q/RI028UQtYOORMEMi36KHaUPamNYJIsNBkiyuzzgINaa8fiuoPyYTJjVRE/u8UGRbpaNa/B4/xKpao49oqKbdaqUA24JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498720; c=relaxed/simple;
	bh=bkenfFd6Q2o6WwLLJ134vG4yH/FKG9KoyC2HWtUiC68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQePc1boJeVbeoFLfLfh6YqoWuGicUPgic05tHOMbALCZA428jX0AhJRzwwbSUGsdDphtV2RTzadLvL8USRLYLtbEuVyWQBTv36pwvhkXnwdt/92Nj8P1v0GW/kTw8vZ2capPUtxCV17EBUeBAT/Cwb1oCc7E5/L7vejUJyDXEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cioCevyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cioCevyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5756C4CED1;
	Fri,  6 Dec 2024 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498719;
	bh=bkenfFd6Q2o6WwLLJ134vG4yH/FKG9KoyC2HWtUiC68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cioCevyI2kLcCsxk5gKvoHq6E2NQvRFigpvcYpIdFf2pqzHXgy//TmS6rEnP3aNf+
	 etlfuRPuB77FWAKZEy8kdM/IM3BB2cz0eFw/sHRayyel4Qx94MOu9w92GZzhrhuzvv
	 E7xUJS255r81wgWTZRe5lzi/Rcb8RB7hgPfuXdHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alain Volmat <alain.volmat@foss.st.com>
Subject: [PATCH 6.6 668/676] drm/sti: avoid potential dereference of error pointers in sti_gdp_atomic_check
Date: Fri,  6 Dec 2024 15:38:07 +0100
Message-ID: <20241206143719.463252541@linuxfoundation.org>
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


