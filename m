Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049131;
	b=UFBFA6u3va05N/sTgN6FYnBGkevuhGlLMY7Gwn8rKq2aDAHCHwy6DjVL79eMqbSqu657
	 0Vqwqdxh75vSr4aBmSAN5gAzciVi9ec97yxZuDdYlBqu6koDdTxe4NEKm0LDHbsPUkA8C
	 x0CtTUJBmqCeeR5SNDZzQeL6ZnboUgl+wXItnm5lgcUnvMl0mmHPlCLQNHyI7w8bnPjXu
	 6oQu21r1l9MpW15m7510+nNh8l19nVQgqryjg0ruglyFouf2wzEgtsGB/zJSpMj/4J9My
	 Lo+pEusmVRrPI/u+saU9xQ3iyLlm04gbGDkhyf0kf5LEal/2o/F72voVv7juC+RVz0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DkV01ZBlkYEosPyno1XGbPbk27GjCtdSUYdi3VBJpuA=;
	b=05p4V3l9MIIAoO1ASUqjApSk/srvA8g9di8M4I3itYQHpGqMw16+Dc7/kylzk0yNIerc
	 1lUJof1CcIYSLdPpG/tSiLtmDF6CjoGzuLeffTFrveJAnomkz5rTyGDVQL4RULO03cVP9
	 6xKHajW8DP7HrPLNEJeoykIKjaiBy9zzaOgvSLry58PkIvfrHP7WYw5gdKfSem/C881+9
	 dDCDA4MTvDs/Q9DpXzwjTwTX9dcAjaYRYiDKS2rjqbIKDqGAGMQkVVRvdyfVC2udU+dB8
	 P3IHXE4Xc8PrhPODxayedTaUas/NFXRcH0KBiXsmtUH8vv3yuU1QKlB5k8hQJKDrWsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6cHaZ8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07515606A338;
	Thu, 19 Nov 2026 00:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6cHaZ8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E111F000CD;
	Thu, 19 Nov 2026 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049130;
	bh=DkV01ZBlkYEosPyno1XGbPbk27GjCtdSUYdi3VBJpuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6cHaZ8QSXGwxF/R6z+b3sOC+Z7vcQy5YElOPWMnWr35w7KWxxwUiIQ8vaCVGvH/x
	 G4ZLDltFJGRXAs82UAXaZ6vrhA/QsbbYiGCVj6qQfzRLwgNUqRufnUuKagqW789LvA
	 e1gkyN6BrESShNvTYuhUhueB+3ZLcmBNKrcaKzH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2243/2857] floppy: flush pending work before releasing resources on init failure
Date: Wed, 18 Nov 2026 15:54:37 +0100
Message-ID: <20261118150322.200635871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0ddefc094e837..2725405e6a3c1 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4743,6 +4743,8 @@ static int __init do_floppy_init(void)
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



