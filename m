Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051694;
	b=Ga3E8YDlSYdOsWqBC1PN5OFjgopmQdyL6GL/oKwQ7Q8QqrL42cz8NAgXodremg0+E+bQ
	 iQiKxjefWKFSGW6H68MSIlHMRa10zEGdy1nnsqWVHJ7gzvM/JAOVZm6hvKECP49jd8rip
	 3NZCYpzGaAty8i5j92tvlq6bAemNwMaGqmj4Q8I3wsU+MS8XdNLBepSd0Wpbswiu7sVk5
	 TaGKnLKpE6fOiCssz5af+SP0P5Xy63Zz3Zm/NfOT+EUAYKHdYWRCX2ra8uahza7A06hpX
	 3kmvO4NfFMi5DhfMEqt1Y4UzfRkL099tVafXHeOyTKVS3NC2FF7rxLg/YEJShDhslzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dS3cWKkockooykIJrvoz0cMhqVlo3g8d5sMBEuqOkhU=;
	b=ShhO/dnirDoKwbXjSRCvV8Ujet03JSktW3Zd1nfMaCnKfvQ5Y4lU0MYNmBKR+6f6K59P
	 JYa+XwMOlZQUf3tA+2vk/hXVM9RYhsbPwhfM/ItwIzcnkSah4hFV4KY1O6fXI+kJ5reCH
	 fch4AiRQEC7Z/6B+kpEH1rjO4bOjp24DDizF2PFenYsR2osM40TJCjSP8L4lhorKHUwIv
	 Lun+Jc45IZec8+pa1NytdG3+EbCrslhsJpRbj3FxmoILMqwsCBoiIUAI5o3iQkTdc/6KG
	 84O8IEs3ZUS/oUcXgHX7fR8WOIFqh5uRUSIZBf06+H/KHn2tA6ynJzogpyF0E4ARClw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lsXMaGcP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25627606A325;
	Thu, 19 Nov 2026 01:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lsXMaGcP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757641F000C4;
	Thu, 19 Nov 2026 01:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051694;
	bh=dS3cWKkockooykIJrvoz0cMhqVlo3g8d5sMBEuqOkhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsXMaGcPU3Gc9t39zjW5syZu4oco/xJiu8bN+DRrxbgr9yq4RfLljmKOAZmx/8f7f
	 VgmYYcV2v99Y8MD/Q8Y1qNFa1FeGbbjzSgMj2U16uMHWg1t66HKiNE77E0tdnRYaHQ
	 9q2jCPkyhqH/sV7NfNgzU5wwy+xhoSQTMBTSafA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com,
	Anuj Bolewar <bolewara@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 0297/2214] media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path
Date: Wed, 18 Nov 2026 15:32:53 +0100
Message-ID: <20261118150022.068611167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Anuj Bolewar <bolewara@gmail.com>

commit 6802ad4b6b267dda02209b5811edac7825c8a5f6 upstream.

hackrf_alloc_urbs() frees the URBs it allocated so far when one
allocation fails, but leaves the entries in dev->urb_list[] and
dev->urbs_initialized untouched. The caller, hackrf_start_streaming(),
then calls hackrf_free_urbs() on the error path, which walks
dev->urbs_initialized entries and calls usb_free_urb() a second time on
the already-freed URBs, causing a use-after-free (slab-use-after-free
Write in usb_free_urb()).

Drop the redundant cleanup loop inside hackrf_alloc_urbs() and let
hackrf_free_urbs(), which the caller already invokes on error, own the
cleanup of the successfully allocated URBs.

Reported-by: syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=832ce9fa3face1b7d44d
Fixes: 969ec1f6bd92 ("[media] hackrf: HackRF SDR driver")
Cc: stable@vger.kernel.org
Signed-off-by: Anuj Bolewar <bolewara@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/hackrf/hackrf.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -665,7 +665,7 @@ static int hackrf_free_urbs(struct hackr
 
 static int hackrf_alloc_urbs(struct hackrf_dev *dev, bool rcv)
 {
-	int i, j;
+	int i;
 	unsigned int pipe;
 	usb_complete_t complete;
 
@@ -681,11 +681,8 @@ static int hackrf_alloc_urbs(struct hack
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
 		dev_dbg(dev->dev, "alloc urb=%d\n", i);
 		dev->urb_list[i] = usb_alloc_urb(0, GFP_KERNEL);
-		if (!dev->urb_list[i]) {
-			for (j = 0; j < i; j++)
-				usb_free_urb(dev->urb_list[j]);
+		if (!dev->urb_list[i])
 			return -ENOMEM;
-		}
 		usb_fill_bulk_urb(dev->urb_list[i],
 				dev->udev,
 				pipe,


