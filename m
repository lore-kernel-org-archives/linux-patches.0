Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31F063D;
	Tue,  2 Jul 2024 17:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941584; cv=none; b=JnS0VDyZgGujxV8+8cpOR9hzuekKf1rSFM5SMTKuCO4ZHW3aI2MM4lP7T6UmtGcoerxWEOBZj0GKDe8eXhGGH/EpBvk9t2xmauyThRaoy+Am9CVPnKD+j/FvswYrHjz2n3KquDJAJknvIZMrCg2Xym5qU6PfWKdVuGP9kD3+KVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941584; c=relaxed/simple;
	bh=cBWfMGGn+He+FKuwVkGDRL7NzlI4ytYuLCvwr5tyrac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ve0Fzt0sVJN5mlc4WhSaNirkxTkZ9XIw5qOSAksoFxsSDtTuo5eC3tyMb7+PGT8Fvn55S4e6YAEVFkMCaOdAQOkh+22SK4ZcAqta0WOH/mR6HKf8ykkDB8dEDTcR/8FKB1KB2/1ZhU7ByKYMgGvJ6Vnlw8zf2Jla8lwJqz3mkrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5JFnNCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5JFnNCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CAAC116B1;
	Tue,  2 Jul 2024 17:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941583;
	bh=cBWfMGGn+He+FKuwVkGDRL7NzlI4ytYuLCvwr5tyrac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5JFnNCSzyPmWN9CxEBcQLfz4mEsjTi2vq4oZHtJ7BfCLAWtiilB4oJW3cKW/gaUH
	 Cozth+c93txn0FgBDJuFV51ymQM2142MPufP3TbGxVM9pDq4x5SAlsf57klvRmUCMP
	 Oq/q5/CSETKCue7E4ZFmkELTraJYh4UyQ1NLsQdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.1 108/128] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes
Date: Tue,  2 Jul 2024 19:05:09 +0200
Message-ID: <20240702170230.307559942@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

commit 6d411c8ccc0137a612e0044489030a194ff5c843 upstream.

In nv17_tv_get_hd_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). The same applies to drm_cvt_mode().
Add a check to avoid null pointer dereference.

Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240625081029.2619437-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
@@ -259,6 +259,8 @@ static int nv17_tv_get_hd_modes(struct d
 		if (modes[i].hdisplay == output_mode->hdisplay &&
 		    modes[i].vdisplay == output_mode->vdisplay) {
 			mode = drm_mode_duplicate(encoder->dev, output_mode);
+			if (!mode)
+				continue;
 			mode->type |= DRM_MODE_TYPE_PREFERRED;
 
 		} else {
@@ -266,6 +268,8 @@ static int nv17_tv_get_hd_modes(struct d
 					    modes[i].vdisplay, 60, false,
 					    (output_mode->flags &
 					     DRM_MODE_FLAG_INTERLACE), false);
+			if (!mode)
+				continue;
 		}
 
 		/* CVT modes are sometimes unsuitable... */


