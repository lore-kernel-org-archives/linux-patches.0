Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704691;
	b=xfSlET9oo9f8ykm75uAZDs61l5xZt5Qw4ug+A+6ji47S2hexI/6alQ3yKNraS/9fQ+n7
	 xwlJf+0dACSnfQMsszcViLJGjRVD3TuGtmKXU830fMs8WUpTWzAAT5vyMWjeh0wNcVbla
	 A8Pa5DWrF9QBy1OJosyDwZZFDylT2xP0piyVSU6sGf1KHPoxOL2U4Dc7gZp09hTFQDpMz
	 VffBxE2OzYJPO2OxYcUfxhYkvw6rzuaY3W+pov9Y+VPd2ZnERMJbIUXiOPQ2tTyXIrfTB
	 w52fco2UwngnW2HXtHZI7T2/X+WltYx/9p8mSLk0XPTt9D/gsjvyhCyAG1Gv11TFzhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uh+mfhMG7SUt2rx6m8cz1vsPK2f62SvHtuhR1u0fxKU=;
	b=nEq1YovkZ0I4zhORQfvUlOVwePsEgGNnj0gttsDvjHOcX4dC3b8od+3KI5KmLp46SWs0
	 aEl12DKE3vt7SEt08xDf3A7300ziZySISXiGWfnIi9nKkORu0Vn0tMNctoRNRlb583I+t
	 pxQU94EvYRBpZG8qImC/Ze+kn+8hflvtGT9NKp8k5DVEn++9WaVOVccTRcTPCGJLVylrg
	 OJyLfTzubXd53vTwlehgrJHkGy+PRj9i0wY/woxltftE6IEjfsPw2Av9hOC4t2g6owE7p
	 2INYEqQ9L+01ZBUJiS81x6o7b+lZCqmoFxGRwrl8qfZZu40isJDshvuHMVob72idXkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcCmH6vu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C42606A321;
	Thu, 26 Nov 2026 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcCmH6vu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFEA1F000C0;
	Thu, 26 Nov 2026 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704691;
	bh=uh+mfhMG7SUt2rx6m8cz1vsPK2f62SvHtuhR1u0fxKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcCmH6vuV0R6t9kg8/bYRgDjxLNwmDSj+/tRzbMuRjcZQy3gSLS6QQtoiEYJ9R7JP
	 cUywVzEj8FeC0N0MsH5rOIhUyCrRMvCyThkDltscaR2KdGCVQxVcpy+9WEnsQqE84K
	 gKMF2w7w0Btl+ka+omS+De2v7Y4nmtVyTW5YhSYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 211/265] dm-integrity: dont attempt to commit journal on disabled device
Date: Thu, 26 Nov 2026 15:39:01 +0100
Message-ID: <20261126143619.976246494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2240,6 +2240,11 @@ static void integrity_commit(struct work
 
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
@@ -4293,7 +4298,6 @@ try_smaller_buffer:
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
-
 	}
 
 	if (ic->mode == 'B') {


