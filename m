Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040825;
	b=MP88sb1kmMfpO8kWZZkqNQ6BBw84Lwv6/1YnZ1T2C8PeVzicTwX8MnmPHX30OFS1heys
	 lGhLJvboM8X5SDbX3YexJXsZV1a3vKUp0APp3UqyR6QpuL1UuWxl/2zZl/TLBHT29uhL2
	 1/fl9M8Tveleb7a4mjqqmE0WMSQssuMMjGZVBakLFXzVjmT4U23N22vim/5OI32uQ7HBQ
	 9hurOipm9vCx4uvDi6t8wMk1LkB2RVxpfM29mdik2sVetb2VI+jzNahjOFmwfV0cjilYt
	 qUV2roS3wH5JRP1g9u0Oi1/VNUiAGGOAx3fJqyKO8Jjw83ZVV8RwHqHMd78GQDU2gHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eqJ/KUuRCGAG6vuBEjsb3M2raCRv/8CHd1h2mAnKnDw=;
	b=ObZzLhBoPEHfBduiPtRs6zpnSpGhkrzksG5lveb++m9XJH59Wcr9f7R/+fQ5pWxQrxUc
	 IPS3M8iAm3TEWPWgUwPua+wuJ7pRVqVjWWf/7aN/falW0TW3yCMz8Yy/7/GyMHVOThqXE
	 wYbU4241P2QwQv4B75vqEUVBfemge/4MjKkgczMM25UkGrIORShpkfI9mY+0t3DAvhAm7
	 cJes3QD5syWYAXkejgpGS6C8LhNXmgFfQ7aM8u+TMBw2y74kHwFEMtFV6jIUwcwntdRKS
	 ZB/LJBTpU94zPwexlUD+oL3n9JrlNd1wJot3vwmiRoRN8teurj65C1t560M6G43ronA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R3pbN9bw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A459606A31C;
	Wed, 18 Nov 2026 22:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R3pbN9bw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F59E1F000C4;
	Wed, 18 Nov 2026 22:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040825;
	bh=eqJ/KUuRCGAG6vuBEjsb3M2raCRv/8CHd1h2mAnKnDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3pbN9bwBfh4f6IqQHiR75aq9XfsUvbgAKyXGp7pLp92y8YmPgGz2y5/KyNI7VusD
	 oQgue/L6fzQKpGBmzj5SACOpD9JnCuLNb1TxDB9HXqiwf4sV8EHPnw3wfkEpB2pNQd
	 UytBmrFmlyJMvSc2hMiGb7AmgAIdQ3+qi9lCePgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2596/3318] floppy: flush pending work before releasing resources on init failure
Date: Wed, 18 Nov 2026 15:53:38 +0100
Message-ID: <20261118150439.045688931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 790218836468d..040acaa8961b3 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4745,6 +4745,8 @@ static int __init do_floppy_init(void)
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



