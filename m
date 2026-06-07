Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D762C1595;
	Sun,  7 Jun 2026 10:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828427; cv=none; b=PzqY7z7iEYGwdYKLi+IYWwiW4/t4/GF+OvwGeFJc4JCbdghNfiBuWND90r2+dyFVQVHVDKweUbrkZtIhGBDtrHD+pc5DO1zdMQnKVwbxX28UnJcXjsZLbk9ROaHRFv230W7nI3imsPehl7Offp5fh+Su3/BMVHiYwVCD/DGoKfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828427; c=relaxed/simple;
	bh=Dd0Qge0KKnb1Owhn02FWyVwQJaHl7qMGAyhflNNxsIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJttNrfdpzLciBMBAC98nqCJEsOGt7j/8SuWtFH25PR3dKikOgEGQUlOltlgCP+cYmbQf2YLzd8xqgVM+A/jvK2BZn6KzEGX+HsKiOOlEvoDwTijr1lfCyqUO/f2XPD7ZYn+casNoS/Xb0HhcXHzHl4Vnot++AgFPuTZbDYRdps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YExn9uuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YExn9uuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37C81F00893;
	Sun,  7 Jun 2026 10:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828426;
	bh=QKRXhF9RSDLbBwkUYzC4UYKxIMMc65yg6GIv7u8jk8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YExn9uuWlhbla6ldgzI16J7jsrlN8J0+JrX2VcfmenvvXxxNW3eapIzdJvzh6dj7C
	 FmQF0mId1Fv6bBlVpg4yrKuFiyJaV65TP287JQSiORJQZE2+C5Z686utnDVpm80LUC
	 m9AG+EHQxiLs6DfFSWYDxANDAq4ct45hXFFP4slc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 137/307] Input: ims-pcu - fix usb_free_coherent() size in ims_pcu_buffers_free()
Date: Sun,  7 Jun 2026 11:58:54 +0200
Message-ID: <20260607095732.770799330@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit dab48a7e74e6a394f3aa0461a2b1fb0c7b38fcb8 upstream.

The input buffer size is pcu->max_in_size, but pcu->max_out_size is
passed to usb_free_coherent().

Change size to match the allocation size.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260522085412.45430-2-fourier.thomas@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1604,7 +1604,7 @@ static void ims_pcu_buffers_free(struct
 	usb_kill_urb(pcu->urb_in);
 	usb_free_urb(pcu->urb_in);
 
-	usb_free_coherent(pcu->udev, pcu->max_out_size,
+	usb_free_coherent(pcu->udev, pcu->max_in_size,
 			  pcu->urb_in_buf, pcu->read_dma);
 
 	kfree(pcu->urb_out_buf);


