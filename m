Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055770;
	b=Qk3mxU7+MmJ20xLPHZzYGM2WQccVZgM5D48hKVnTti2W++HziyT/q1qK3xdUanIp5TG6
	 HqombosHgO7BVvtZHoZFN3SDiZEvclq3lDHMig3k0w1KxNw5QayWwPZoiUjuV6n0JTP1U
	 mrma1CLzwIFTnjVeaz4+DwmEZLStbpamK7FFsQv2PetmUTx2XbsFVf+qd68VUpFlCD4Am
	 vAPn818i0OyNQvVtxXJ6kWjpfqXj8QbMa1+Qo81oC8WfiNbMwhDAJkEhsf2b4PnrDEaVn
	 SFCFG5R3JRK/EyAKlJZxgufYfZuz3Up08YOnxTvSAUSqIlPpGbhrIy1/nIl17tfBOCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fsaxXJ4pwGXELrZT+cCago1V1K32l07uK0R8yNYTTpg=;
	b=sCyRbD8TYB22UoLSrEFFqMdWH80ZVhb9/Iv6dNg72CdUweyA/PlUdoBIxrfo539F6RKz
	 XGCjQsOkvWfkFGlm1AGI2oJKmsNGKgFZdGTVdMRSWpEMx8R1kV93szR93BTxp7Inby4Rj
	 5W6w+Or/8qw9wgyCSYR5LB8b6DCy3HV8F+7WuOpiG/bPVv90q0NlSdlT7w2fa67cznT48
	 Gzy+cATBejZu2cVFM/n2SkeMWdehwdyo6mgeblq41zdyRtrCVQ/s3egG8ZfWNaEVZC3kd
	 TfoDftw+tNyr4yUvSFYlnsRXyZk0PYq7cS63MyhK+WM6ROPR9ixuA1DwGDA6kYqT0iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmOn6Zk2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59FA606A32F;
	Thu, 19 Nov 2026 02:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmOn6Zk2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8FC1F000C4;
	Thu, 19 Nov 2026 02:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055770;
	bh=fsaxXJ4pwGXELrZT+cCago1V1K32l07uK0R8yNYTTpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmOn6Zk28Lt9588lgMo+pCHY/JX3wOANr3gftP5RAM10bvgXWo3VD7982j+e9y+2B
	 lcbTUwDKS76BH0Lyn4tYrK8QTe6icPcnABe927JGcjZHaJ2Ky1Tnm3yyTSr30kFE3z
	 Y2iUAVvw3xxIoP1+NPhhIWNzLGiO/XmD6BT+gDiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1750/2214] floppy: flush pending work before releasing resources on init failure
Date: Wed, 18 Nov 2026 15:57:06 +0100
Message-ID: <20261118150121.601608626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f4c55a9a9534c..d89469acf919d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4735,6 +4735,8 @@ static int __init do_floppy_init(void)
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



