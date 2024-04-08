Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EB87D3FD;
	Mon,  8 Apr 2024 14:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585034; cv=none; b=sRTIJfuWFMjTWHCJ4PsN6ScCs31hrwF/kMs98gJcuXT8maL3HVt+56WfopQylsmB7CeLDTEwOKfW6xP27TNirkUyi+LG8xmlK3V1IvqDRmwMhFnIzRHB4SNYLyQg6R2Wr62m9ZlGc3Kl5xUJrVIyqA9lbuLm5Fu7jYt2bqqQWHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585034; c=relaxed/simple;
	bh=mGX2+ToTnV+NZymyioXocs2e9msMu/gdR7g79kj5XJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZe0Q3QuREMNAmnpalgLtaoi2Q1yjP9x5BRURzEdn/5DjME6cS+jy+iK6o+UPFsh8vzjA2P6cmEPj8FVxmsn5CdHk2cpUSE6Ea/pnCyRDgW4w5Dklu813Y5bEYN8bFwNNvrvbJtCQGlBdJVYegNiCqmwIHb+kBUBQ5sSt9f60TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLHM6dXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLHM6dXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2703C433F1;
	Mon,  8 Apr 2024 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585034;
	bh=mGX2+ToTnV+NZymyioXocs2e9msMu/gdR7g79kj5XJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLHM6dXhhDyfT5QtjQ9/iILZQbQ4m/SWUOjSmH2DQpnydbQwdwvMkdijKQgAB2yCs
	 rBqfv2Sb3c2DaJ4bEbkjkt3uliwieWfV9uSrl2EZF+YGK8GZ+l4207pM+3KLNRkDlv
	 xn7WFcgQ9iBnEBBzrp1hFFqFIU+aJWT0E0I+t8/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 640/690] vboxsf: Avoid an spurious warning if load_nls_xxx() fails
Date: Mon,  8 Apr 2024 14:58:26 +0200
Message-ID: <20240408125422.851145224@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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


