Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044681;
	b=NRjsoyTxQs4LAPoZ47Noy2lqWVbl7uTqJCsMxV5QlnBryHzIgj3ppXdUbZMqIQk5t4QS
	 /fe2RzWJcgDX9o7E7py2f3GE9ex7nVvcwrHxZizmYvZvxL3nlQXDFA9ggWvs3xyvGB/ZW
	 g4qnh6Gd5Yj340DdAaQrmejmntoZkQQZw2v4QPf7+Uqb9LkAjHTFDvwHiPMPWQ7s6X9JD
	 3wVONUXfvC0vwrvWL9OESikHw5bN12AqP4+2+P7+YvKC0jSa73zJbSPaIqnc+M0yotzzT
	 eGYc8gW4jKwCjNy7Nf9RXZM1MNvwZeCeuL0hQDQS+Ey2k0sW9Y0yeWFfhd0C/upmA6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uuJ9/O9G/TkMi66evVKabv5JvVUYbj1CvQk/U9sp9iQ=;
	b=jZT3x1WJOAAi2JzyngCZEWmVYL5aA1KqbkzhJenfkc9AsqF7XN/bKWvvBzJHa4CzuN27
	 UC/iEpYJD7g6SP6GtXemY9dLF0o8OM/WeBNme2lpKGtXB8lzCtVZu2rxPk1TwKyFt87vU
	 g2ZGkLXEf/5ItyXVV/qDXDSmU7jGuKuot61i3c/+xZEJHkqHo5sHWE6C1UEmjqkwtyR7f
	 Zhpsgpqy81xZtjKJY/StDY41bsTO/1Zc0YCtEXDrtTjlj9j0a6bwubE90B19If579cBAi
	 /Pte8TI32KJlWjNahLyT/ru7ABrDD9bdG2+cMHob1YUi4uw6DCAaEFI+8Oodc9uzbqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2INUZrPK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937EC606A334;
	Wed, 18 Nov 2026 23:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2INUZrPK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81891F000C4;
	Wed, 18 Nov 2026 23:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044681;
	bh=uuJ9/O9G/TkMi66evVKabv5JvVUYbj1CvQk/U9sp9iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2INUZrPKcx15wDe+5ZxPiXWk++XWe3i6MpyKuas/Y9hkml6ExLhPIHiQ8IGInjkds
	 9fMlQWW8q52exu5PAUe8nyaip4cWSW0GLue9PrGYCKOl70UgLBnjIyMw6RSIgGtO1j
	 P3xvD6/r8OMvqKCEb0y/AOKsEf700MZ8OVN8HwTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0653/2857] io_uring/net: keep recvmsg buffer select length within MAX_RW_COUNT
Date: Wed, 18 Nov 2026 15:28:07 +0100
Message-ID: <20261118150225.072254610@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

Commit 18d3f56eb6e6500a65d81cf265f0fe74fd9ecab6 upstream.

io_recvmsg() takes the transfer length from the ring provided buffer when
sqe->len is 0, and such a buffer can be up to 4G. min_ret is an int, so 2G
or more makes it negative and the (ret < min_ret) block is skipped, and the
oversized length reaches the socket layer unchanged: an empty socket then
completes with 0 instead of arming poll, and a short read is reported as
complete. Clamp the length to MAX_RW_COUNT, as io_recv() does.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20261023112209.87979-1-chenyichong@uniontech.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.1 has the older io_buffer_select() interface]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -805,6 +805,7 @@ retry_multishot:
 		buf = io_buffer_select(req, &len, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
+		len = min_t(size_t, len, MAX_RW_COUNT);
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
 			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);


