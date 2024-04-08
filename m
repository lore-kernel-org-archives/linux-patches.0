Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AC881727;
	Mon,  8 Apr 2024 13:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582638; cv=none; b=pnhZ0SsqQL5lH0J2CvxmN5CegJkdWSEWapwixIQCLNczsZxYqcHnDCGHnXv0sIbMzUpZqgt5AHszZTvvXs5WId8JyacU1DzVjm5hHjxnBvyriUazfF7ANXQHVlAn1Pv4w9b2TOH0d0iHc5ixSkvKQf4A5bQpiyJwNfMOHN52p30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582638; c=relaxed/simple;
	bh=j3zNujywYCzU46xoqD+r1yA8xpWX7gCnjCjuapawjaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAR1GzJOZHj4VdHhR9LhqaXsu3gO9QMwoJrnjAqCGhcicsNaQW+pisiYPWcScAM4iYe3Pim870K8teCmLlPYS/hbyY81M9r7enuA9EMKsDlI/SXQ+YmJIFzoz8OQUmRyfwA7plIE1GuAK7KCVxX5Djz8TByHu7N92E+rRVdRM40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ku6nPpBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ku6nPpBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4B0C433C7;
	Mon,  8 Apr 2024 13:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582638;
	bh=j3zNujywYCzU46xoqD+r1yA8xpWX7gCnjCjuapawjaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ku6nPpBueFpLGSNZCoWqbrYvEdBy/DYhZ0fwJFeeQTw8PC0J/GSmRAYsoazY+wW45
	 jnCc9yT2BuDcPj0IcWXr3m3p4fMV/x56J0108ifFSButWim6l5WNHpGkiMAbWxh+Fr
	 rWDrENN/cEsCQJbbpKtfaFkgO6IF9J+OiJgSMX7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.8 092/273] vboxsf: Avoid an spurious warning if load_nls_xxx() fails
Date: Mon,  8 Apr 2024 14:56:07 +0200
Message-ID: <20240408125312.158275442@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit de3f64b738af57e2732b91a0774facc675b75b54 upstream.

If an load_nls_xxx() function fails a few lines above, the 'sbi->bdi_id' is
still 0.
So, in the error handling path, we will call ida_simple_remove(..., 0)
which is not allocated yet.

In order to prevent a spurious "ida_free called for id=0 which is not
allocated." message, tweak the error handling path and add a new label.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d09eaaa4e2e08206c58a1a27ca9b3e81dc168773.1698835730.git.christophe.jaillet@wanadoo.fr
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/vboxsf/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/vboxsf/super.c
+++ b/fs/vboxsf/super.c
@@ -151,7 +151,7 @@ static int vboxsf_fill_super(struct supe
 		if (!sbi->nls) {
 			vbg_err("vboxsf: Count not load '%s' nls\n", nls_name);
 			err = -EINVAL;
-			goto fail_free;
+			goto fail_destroy_idr;
 		}
 	}
 
@@ -224,6 +224,7 @@ fail_free:
 		ida_simple_remove(&vboxsf_bdi_ida, sbi->bdi_id);
 	if (sbi->nls)
 		unload_nls(sbi->nls);
+fail_destroy_idr:
 	idr_destroy(&sbi->ino_idr);
 	kfree(sbi);
 	return err;


