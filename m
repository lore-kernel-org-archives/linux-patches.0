Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626044;
	b=vgkBL4iPWNYy02A0zD8LHHF2oZ9uRGE0K+m3M3pnZev5I0gAE41Um07yXpseN/JDzJX/
	 jaLch2kflWRtzmNvKpR3EX/gpdS0uqxiV8oKUCrYIH59Qbzn7ce74Rp3DqL8m/488YJA9
	 80Hxaxs6lpgGa6x/9Wv94SN3s268EPEwE3okboqd/oLG6ik/s/tylPuSDvWhOpGNN8Ijq
	 io7CG5iOp02ke6Sxdsasmx6SEdUR2dTpqAlFKQc9zUNp3STq3VNEQuajAT+OYrX3OcfAc
	 CtJooqiuBcQ90ibqidr4CcOn7RtVxKpnxg9IPpU3IqlJp+ZdHu06Vu1Od1RzZXWF3tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBcwgs1y06wika1bGXpK7aZvr7RNBsvQriB8ptYDMsA=;
	b=zXVVIs5bQC636U8w1VAvyc7A2e93cdikGbnDfxWelWjWWxlhFbnd4n6dkSZyzde59PDN
	 NLd4/pPyKMj6NHNEKAwYo+S6uEXNFpTjqxHK8/UOIAhtQb8P9sSezZ2vgJQG7ZM0yA9I/
	 nnZw3g3WZ0Nyg5ny2PEM+frbwT/4nUyTG55flx/LmEetHgDNTg0X6sfwJ31SDCgOfO3dr
	 DAl26K5Vj+/NFNIfnlKGg4XRctFY39vp4lU7XH81taG4x6i+93XWj93pM1KZXPmD1N0L0
	 mwburaSyLFTAw2Y+fhdxBhoRRTD5wjgy1BUJhe6USz+HFMKRZcHTK4lzmu79oNsjRTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tYB/PBw7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A16606A31E;
	Wed, 25 Nov 2026 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tYB/PBw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778A71F000C4;
	Wed, 25 Nov 2026 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626044;
	bh=ZBcwgs1y06wika1bGXpK7aZvr7RNBsvQriB8ptYDMsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYB/PBw7u7tI+hYf8RZIP6ni0orvHzV9mU5ARrh3Pi6b7Uw6pLfbybBXEGAX3tMOg
	 EuUO++qvPFklTp7fM0sWKeaoPtol6gTQbHyyJ+e2TquYTP5nTMNSlTv5XSH4zP7/Z2
	 XthjZY8wWAoT6e3Z87nPL8QUw2bn4szIv12B260M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 714/816] dm-integrity: dont attempt to commit journal on disabled device
Date: Wed, 25 Nov 2026 15:37:42 +0100
Message-ID: <20261125143905.702725874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2773,6 +2773,11 @@ static void integrity_commit(struct work
 
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
@@ -5239,7 +5244,6 @@ try_smaller_buffer:
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
-
 	}
 
 	if (ic->mode == 'B') {


