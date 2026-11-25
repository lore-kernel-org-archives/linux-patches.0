Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623490;
	b=L6oZFfoygUO9pZH2M7ZprzERaljATo/+mH6M9DtTibeacn83mg2SPVDPH78nYTI4DX47
	 B3C5xKxb+LUMR6SJ9mO+4Pem6hY4xt0cQip0UO34Zf+8zTv5FJY5hI+qRiSlaDRi1nHdb
	 kur9LbPT4EMV+IepGz1kpMSZl5N953ko6bWCXRQxrwTFjM4sdssIowouQqkJE+P3+TqZI
	 tn72tI0zCvn64Q9KORjExWkc6U8inZ6dSd+lHAZPHFxmVVYQJgcGlxCm/J6PEQAQoM3Ns
	 yMo/GQfRJlPsLyfRxkOFcVMpBhvP2oY6OZaXVo1BibUjCghzss1Hw/z0KHpgwjLKlJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4MU82XKyrqkzVjuxknFd8bTnOHlmx3RCZUVtCVzgzkg=;
	b=t1wiNDf2eS8TjZGvE4eMoxGZb+pigucApskB11xmZRSTo3VRfDLHyGy6xWvUUZryKcdQ
	 1F5Wz+8+jTinKop9rXx5JcKgAWcfBjZAovb8FeTLskn5K8TtQNTro+WVR7Xtf7TSMW+O6
	 eWwgU5Poms5I6eXnJHzurajW3WKahXiwtFZMDHuHtoF/bHn7rnEBkigz6eiV9+6P9QSTz
	 Qa8A2EPSbG0iTIaHiPwaahbp2d3DRVQtTBFY2TsbWKldOHxB1jND5qcAiOj+eqN1iHWIz
	 R+T01FTSHTXPr5TTPbwzemf6cRIq2doS8MSmI99g94P+8jMwOG9kARq/wIwUHThGspQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdBfx5iS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E49606A335;
	Wed, 25 Nov 2026 16:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdBfx5iS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7971F000CF;
	Wed, 25 Nov 2026 16:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623490;
	bh=4MU82XKyrqkzVjuxknFd8bTnOHlmx3RCZUVtCVzgzkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdBfx5iSKaQ4DjTKx5iRCRd5jUnhHAtY89Xbk98OSMwOfqzUns0btucnRlQQyPXbT
	 E7NGdUG7xH4puT5PNkEpG3xFnfYfEJC+G6XUoraiC54A+1FLQvbUsU6z60e40ssJ1f
	 u+WjKUOha5ehD3cpglxWYVara05sZUnZCG4jtlQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 875/990] dm-integrity: dont attempt to commit journal on disabled device
Date: Wed, 25 Nov 2026 15:37:22 +0100
Message-ID: <20261125143842.514522300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2906,6 +2906,11 @@ static void integrity_commit(struct work
 
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
@@ -5418,7 +5423,6 @@ try_smaller_buffer:
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
-
 	}
 
 	if (ic->mode == 'B') {


