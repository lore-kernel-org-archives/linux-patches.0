Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E193A9627;
	Tue, 16 Jun 2026 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623855; cv=none; b=ATW9wduMsxY+3GGVEwkK9A5dk9iul2qsSDm6OLQ8GUfYp55HHyWWx2Ygh+rOd6t6/5/ccbrpqbifs2QbGu7MAVqTAppewJrLgItJhlekuZOecceQrtuA1WiWG2o4xGp3zsVRsqo3gz17ghhAV8r0LBf7MFX77ugVBGcBx9C8cH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623855; c=relaxed/simple;
	bh=ixGpNYik5ZtVgoheusu5xex8nf+XjbhSlQ/UmMmkcDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwqOwyW2IB1KePLQ+NjbPV4ELkIhJn/H4urlNdMFNMR4iZHgA27PqxpXnascgOtHBKi1ZqsOK0iQI/B2Tsn9zlkkt366oY4iXi3Kl3vZSMY2/9W3bb863cClE4C2rREDN8R5AX3Ig9YQ0MDFJuR6lTnDUtab43DVDpL7+UbUG0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTDdFtqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTDdFtqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684321F000E9;
	Tue, 16 Jun 2026 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623854;
	bh=f3cslVgbC1zss3fEhuLqtiDanWeVa9TCTulYHLEcclg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTDdFtqu8ne82jcr9zqiSH1pcnYFbJUxhroUPNugDZmSfdkpHqoLk7dSabcyGP1cd
	 Ng+UH8NVDGKyzWx2oEnENQcpafSosuBo/58IWMOCoinhyANkk4gjsJ1GwcGBfTpyDS
	 g1RSumCpqZnIACQU1TSoyd4jJtycEAxCKVizN8WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Brasili <federico.brasili@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 214/378] io_uring/kbuf: dont truncate end buffer for bundles
Date: Tue, 16 Jun 2026 20:27:25 +0530
Message-ID: <20260616145121.609586468@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 70f4886bcbb929e88038c8807f1daf7fc587ae7c upstream.

If buffers have been peeked for a bundle receive, the kernel will
truncate the end buffer, if the available length is shorter than the
buffer itself. This is unnecessary, as applications iterating bundle
receives must always use the minimum size of the buffer length and the
remaining number of bytes in the bundle. The examples in liburing do
that as well, eg examples/proxy.c.

If the kernel does truncate this buffer AND the current transfer fails,
then the buffer will be left with a smaller size than what is otherwise
available.

Just remove the buffer truncation, as it's not necessary in the first
place.

Link: https://lore.kernel.org/io-uring/CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com/
Reported-by: Federico Brasili <federico.brasili@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    1 -
 1 file changed, 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -305,7 +305,6 @@ static int io_ring_buffers_peek(struct i
 				arg->partial_map = 1;
 				if (iov != arg->iovs)
 					break;
-				WRITE_ONCE(buf->len, len);
 			}
 		}
 


