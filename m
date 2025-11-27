Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707D7333456;
	Thu, 27 Nov 2025 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255650; cv=none; b=QdUhbsuhhQtbsyKM0V+ZYGBSSNs9SJGY+FB8pNARHv3eJ2wOYuPkWJaj+GeI9l5ycDV5GuCrW6Bmtdh8t97FofXK9gRbxAminU7fCAdQ67D/NqDq1r8rsUAc7KBki2LEYG4S9gEGiy3bPcYJqWvbcMGksG2rkojYixsB7TGe484=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255650; c=relaxed/simple;
	bh=2d36g/xIm7B5awsCU+CEiqlQEKwT4pq+JaOfDJmEizg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBd3VZhqHPPyQdJAT3KV2EPEEp8imt+p1LgksY4olzX3VaEgFStucM48bV9j4Yy37ngUezvyCOnP9jL8N/v0hbgEWU/v5J29wwtkcjUbJVC9aHbCnYgka1GYe1kc/WWgA2WIn076jcWmFQHKHamkjhwnDOq+U+kakcMGSuS5y9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovjJl2FN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovjJl2FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB246C4CEF8;
	Thu, 27 Nov 2025 15:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255650;
	bh=2d36g/xIm7B5awsCU+CEiqlQEKwT4pq+JaOfDJmEizg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovjJl2FNeSfa7EnXmICCCartZDiW9Ff1+G1mv3i4b67jzTShCucf0+BvSnLHEllEt
	 cUQRXjTuLkqLlR6XX8NbZTakT3z33ngIzVDjqc3oZ/c4eaE7KKGMhFJI+FnWNbbjqy
	 j0GC6TiSlIU4p3f7uUv/j+mu/AaBQI2aRVNm1YII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-462435176@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 033/175] io_uring/cmd_net: fix wrong argument types for skb_queue_splice()
Date: Thu, 27 Nov 2025 15:44:46 +0100
Message-ID: <20251127144044.177614050@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 46447367a52965e9d35f112f5b26fc8ff8ec443d upstream.

If timestamp retriving needs to be retried and the local list of
SKB's already has entries, then it's spliced back into the socket
queue. However, the arguments for the splice helper are transposed,
causing exactly the wrong direction of splicing into the on-stack
list. Fix that up.

Cc: stable@vger.kernel.org
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-462435176@google.com>
Fixes: 9e4ed359b8ef ("io_uring/netcmd: add tx timestamping cmd support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cmd_net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -126,7 +126,7 @@ static int io_uring_cmd_timestamp(struct
 
 	if (!unlikely(skb_queue_empty(&list))) {
 		scoped_guard(spinlock_irqsave, &q->lock)
-			skb_queue_splice(q, &list);
+			skb_queue_splice(&list, q);
 	}
 	return -EAGAIN;
 }


