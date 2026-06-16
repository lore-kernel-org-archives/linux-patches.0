Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3186F4508F2;
	Tue, 16 Jun 2026 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627533; cv=none; b=j79rmEHJ89fbvmzf1fmFuk9yfkafpXFlgJ3PB8t4YNzu3uoyInL6tlatRoNXpVOzG9WB6qyougN0NSjgRJrQTmazl+RLotROVZK9Vjjy2l5+oUxvChacXeUwCrp3zx44c2Yc4S6kCk1bGF28HPFVLrA944gZtW7lkH4T2MJt5Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627533; c=relaxed/simple;
	bh=Jyb9muVDZJh/85r6QgtsoAhQwpCl0vQlbq1q3+3sp88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tftznf/LoNxdyrCM1Cv56hcgUmgMCCbDklEcIPhppxjRU/B1GQTuhKffniZKq8GTOXeZxpRkVH9sCW0BTTmFoEI71FUvU+YUMXQou9LusnV5VzUe+l0QrH81FELu/WVBSgwjQexHBR1VZan3fVzdqcPmvS6VBV9J/R1IHBGS08U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDNAmjzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDNAmjzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A921F000E9;
	Tue, 16 Jun 2026 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627531;
	bh=6tLH3RI7H0vb0FLEtmuHLomYoIF6weWPoMVd68bXzlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDNAmjzr9OquNgf8JxRI3InrawvzdLzX6/0R9W796YzU87OJ80Mpqs7AB9o2dfctF
	 0UApFjlLZJuuYngTKHks8ToPweZnr8zkEZqxzxFzMSkR0pCb0dMk2KwQkyiSx2IuTn
	 1l3ZbmicwSDF5oy/+TihBuyUJKNojllWf6IsoEwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Brasili <federico.brasili@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 189/261] io_uring/kbuf: dont truncate end buffer for bundles
Date: Tue, 16 Jun 2026 20:30:27 +0530
Message-ID: <20260616145053.821640587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 70f4886bcbb929e88038c8807f1daf7fc587ae7c upstream.

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
@@ -293,7 +293,6 @@ static int io_ring_buffers_peek(struct i
 				arg->partial_map = 1;
 				if (iov != arg->iovs)
 					break;
-				WRITE_ONCE(buf->len, len);
 			}
 		}
 


