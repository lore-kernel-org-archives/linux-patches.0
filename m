Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A329248BA1;
	Wed, 15 Jan 2025 10:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938407; cv=none; b=SRal0vug50N3YsQH+lg0pcMboXRFlGCtbLJEaZ799HXbAREH8peA3GnMeZtTaToMftTtQgsq9jWiFN/NMjEPcdvbLbXhMgNBVOS+TgAYI2i9Ln/I/sJnTOB079GyZlffNtH06kNZRs2M2WozolqdUmVBNs33Lz8iJlciUoYxgPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938407; c=relaxed/simple;
	bh=nQEh4tnBgs8U/FRWQJ1rdAGoSsKjfen3e1eioWtwnRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPHSwrRfkAfFDf5UMk49T4jpbOP4rksUQ0CohwxQclyumEDH//LBFlkptN9LeO4YvCON9K/1vv8SHFc3ZXCkRxWtTu/6HCMXCJ4QDvTX/UW+ksCYqTrTph4t5wB+1gpMsNRkDC1YyD5dJG+Q5eLVEA3KMVuplEF4PY+y+nxWCzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYRbMv3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYRbMv3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC96BC4CEE2;
	Wed, 15 Jan 2025 10:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938407;
	bh=nQEh4tnBgs8U/FRWQJ1rdAGoSsKjfen3e1eioWtwnRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYRbMv3I4mfqR4P/n0dnuydzauxw1CHhjlZxt6LwzWn0b11Lb/1Jv+o0EW4MKcwZ1
	 oxsauI3Er9bV38naYjO+3Y1NfemuHJXNsh5tfMXoYhXvpoTcYzclbPYnPF992Em94X
	 Km1v4KrA+35+p2OgknoaeX0B4sgaOlP1zZcAxWKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 174/189] io_uring/eventfd: ensure io_eventfd_signal() defers another RCU period
Date: Wed, 15 Jan 2025 11:37:50 +0100
Message-ID: <20250115103613.346350199@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jens Axboe <axboe@kernel.dk>

Commit c9a40292a44e78f71258b8522655bffaf5753bdb upstream.

io_eventfd_do_signal() is invoked from an RCU callback, but when
dropping the reference to the io_ev_fd, it calls io_eventfd_free()
directly if the refcount drops to zero. This isn't correct, as any
potential freeing of the io_ev_fd should be deferred another RCU grace
period.

Just call io_eventfd_put() rather than open-code the dec-and-test and
free, which will correctly defer it another RCU grace period.

Fixes: 21a091b970cd ("io_uring: signal registered eventfd to process deferred task work")
Reported-by: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/eventfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -38,7 +38,7 @@ static void io_eventfd_do_signal(struct
 	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 
 	if (refcount_dec_and_test(&ev_fd->refs))
-		io_eventfd_free(rcu);
+		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
 void io_eventfd_signal(struct io_ring_ctx *ctx)


