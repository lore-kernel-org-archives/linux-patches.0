Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705608;
	b=2L8cZi5j4+uI3vA2nzpPl2FJvmgv1pKIfpAmS41afq6EIMAmCLMeGxucXxhlyym3qMN0
	 IdyPylfB+2P3535aaCfzXjfzp/C930Q9gncNX0dGLGESPPcdGwt49H8ABzILNIZSwUWwJ
	 nEOODtMrZrYs/mZ3B4Mejzlxs5OJ+7WCzPrG19a8XnsUqKOo7NSm7P5jtQkD3GdOrsqv0
	 K0sKUfXeTKYNLjwJ21NJm+931HNp/HoqqlLiDnHiDNXlYJWfgcGQ+tavda8Fr4QFsGn+D
	 PiYqns1bqdJMFDZlxS+/Y/Manr7dIiOTBHbR45I9l1DHeN3DRh3N8C2mYanMLgTMqwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CJ/Md3MVhka8Cq88DHtEI4AVc9AdJ7QVyKlJozA6j3U=;
	b=fp86V9W1MXmpMqS7S7/uMSsTtAaXi6EWGcZpP/m69jDPunCoMCQuDSYurkzsN+2PUUHs
	 H6zj7emact4GpMCaVNpd9aD8P8rPBOVXgumYU1rGBRUMiQ5siA/YCLoGk0qodDyqH1zMC
	 nyRUBdFgbpGABUaN7nx9UqP8xuDw0uSRHhenU53sXcG7imfAL14PT2T+GzynjZ1yqY0Cx
	 eNodGF9qPDBWXCxzx4SEmxKMVlXXrwvx65Utt0HW6coc9iBwxVih8wdy9kGI0ZEJ/x6fu
	 Aspb7dla4m+oJYz9hkg0Sz2BpY8PvnN3MvSJziYbYlP8BjmG42AQUSzF65BZZRvYXLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXjc5KSy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0358606A33F;
	Thu, 26 Nov 2026 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXjc5KSy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4DD1F000D8;
	Thu, 26 Nov 2026 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705607;
	bh=CJ/Md3MVhka8Cq88DHtEI4AVc9AdJ7QVyKlJozA6j3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXjc5KSyhnUOPK2n/h3hVzAdIqXXn71ezYSxq1lDHV3Ci7A0jyQPQ3tbKF7dkMinY
	 6T08xYrLlW5EbQ1Q8P9tszKSm2H51l8nBn5BkipO371Su0yOVWC0iFS0xUHXc4fAWV
	 9piHBXRwMgn0lO5/hbn1+CRBf+MyJ+E1DWDbQPAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 254/319] dm-integrity: dont attempt to commit journal on disabled device
Date: Thu, 26 Nov 2026 15:40:22 +0100
Message-ID: <20261126144012.476754072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit e5e03918fbec31f0c896f4f43c2bd2aadf35d43d upstream.

If the device is disabled due to an error, we shouldn't attempt to flush
the journal. We jump straight to the label release_flush_bios, that will
call do_endio on all queued bios. do_endio will terminate the bios with
the error.

This fixes WARN_ON in the function pad_uncommitted reported by syzkaller.

Reported-by: syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=94dac3c75477e184f0b0
Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2345,6 +2345,11 @@ static void integrity_commit(struct work
 
 	spin_lock_irq(&ic->endio_wait.lock);
 	flushes = bio_list_get(&ic->flush_bio_list);
+	if (unlikely(dm_integrity_failed(ic))) {
+		wake_up_locked(&ic->endio_wait);
+		spin_unlock_irq(&ic->endio_wait.lock);
+		goto release_flush_bios;
+	}
 	if (unlikely(ic->mode != 'J')) {
 		spin_unlock_irq(&ic->endio_wait.lock);
 		dm_integrity_flush_buffers(ic, true);
@@ -4464,7 +4469,6 @@ try_smaller_buffer:
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
-
 	}
 
 	if (ic->mode == 'B') {


