Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018675;
	b=GkZ17ikVq22PdAhun8Mjg1jSny5jSfrtpq9qrsuowumGJLgOoS7Fkm9ycybKx1G2MrR8
	 03Nqh6UbJkJAkp9S3cKjVuvSXDZXKbD2zHOIXt5VZNdnY19Tmhp9Z9WOy6lH8HFN/EbIo
	 L6AjIpLn2q7alL4bJleL7/oe5DNkjVZmzAFjfudTv6GCHN/hf52OUPUtvS8AY3wDDHUmU
	 TCyMm0GZ7wO/KZA3dUTqRrNe61g+l4HI8D14pAvsvjkDafGNoWYq6bsLie0KQENk2ZJjK
	 wtLQHKwLZgUnBnklbxdofxH3FyZMbpgf72uXBsej5FxaoCS25GCY/6YVo/OyMU1Rdwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPJNneFp4UFMyD6j9eqYS+YKnE+pcFiijxrFEW4LPmw=;
	b=eo6ewsVyokk99G2sxLALUsqUMquUnLINJ4UgVPXLWjP1W4wPxOos2jubvGh8WRT1CxtM
	 rHaROn7FHipQo7eggkIN6zaaHLnBFmHpWE7IIjp8KQBPQb/mA+LyIRM1JTYw4AAHfwM3B
	 FFLwkVE2EO9ACYtsoAXYnnCRvhNbN15fvgp9wq8q6dcJjELfI651/NRkIqXD8DtzjSLIH
	 nX6DFeliHb5+CaJOHfgQOKnEKb1JHHz+lp5jCRAAe2VU13Df/HcHHeu9SnarkA2nJh4gm
	 3Cl8gtCsf7TVy8c2tt7W7c7YcwBnVhTnhyFKD0MiVLa97cDB82SbMIQCP9kTcrJwSyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViMuXzWa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DD3606A31C;
	Wed, 18 Nov 2026 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViMuXzWa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777281F000C5;
	Wed, 18 Nov 2026 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018675;
	bh=HPJNneFp4UFMyD6j9eqYS+YKnE+pcFiijxrFEW4LPmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViMuXzWaWFuZIQqsqzB+W7xKjNlJHOU/VqlfWTlad+743daiWsvESv2e/9XXNma6b
	 iALgYGUq1DJAbhO9lR2amvHIGdOZ8EIBlpDxPZq2VHCPiw39R9atkmR5sGEkCuow88
	 jBpiJXPOiLdQ2arLJJJS2Vx7eKqfxgDwUPaTOgpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1324/2651] floppy: flush pending work before releasing resources on init failure
Date: Wed, 18 Nov 2026 15:42:44 +0100
Message-ID: <20261118150335.669074408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 74c2e2eeb7e51cdeb5e3eceaf324cfcf8dcd0d32 ]

do_floppy_init() probes each FDC with user_reset_fdc(), which queues a
redo_fd_request() work item on floppy_wq that may still be pending when
the probe finishes. When no controller is found, the error path calls
floppy_release_irq_and_dma() to free the IRQ and DMA channel, and only
later destroys the workqueue. destroy_workqueue() drains the queued work
last, so it can run after the IRQ and DMA are already gone:

  floppy0: no floppy controllers found
  work still pending

The flush used to be here. Commit 070ad7e793dc ("floppy: convert to
delayed work and single-thread wq") renamed the label out_flush_work to
out_release_dma and dropped it. Restore it so the work drains before the
IRQ and DMA are released, as floppy_module_exit() already does.

Fixes: 070ad7e793dc ("floppy: convert to delayed work and single-thread wq")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260722034435.13432-1-kmehltretter@gmail.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 7465e10f36d46..53b05cab9b753 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4744,6 +4744,8 @@ static int __init do_floppy_init(void)
 		}
 	}
 out_release_dma:
+	/* Drain the queued redo_fd_request() before releasing IRQ and DMA. */
+	flush_workqueue(floppy_wq);
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 out_unreg_driver:
-- 
2.53.0



