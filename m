Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057758;
	b=lDq8taY7Wt4KZUw8rX99i/ItOXqjVJWEcfX76Z+NGQW2hZHER1b3NAoKHymuEywL686k
	 XyNv0j/XPxiL7kUq8kJEwrcXOE4+JH5L5kgn88AKgl/dERUPWl/1AWTUnHb4gb2ao4zMY
	 jQBdQFgkJHJMCEr9LZHA61njs86d4IOB6GfLDFoMC5fScQJ62TOWqE4ixOA2r8nqTwVRw
	 xHyxiCnO9I0qWpAyAhceGuraHu/Ch/8xtn8hIaqPnz5aBUyttQxtJh/eL05l2YO6QPYRp
	 LhMyaBmRZLz0XNihghCjXpNLXNys5ow/r6z7I7jy2qedDaQW194JmpZIvSwM7CKw3vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rXl6DRVrLSW2AsPLDu3Ek6WFX6jcqnV3Dg+rUC7fe1I=;
	b=c950gZLdxVAtvW3koCuhibshoO+v05nbLDD0ep/7uec0cUOHSjCS0HT9EvEOk4D2pUq7
	 GZWNF0t43soKz6lIWWKUcRH1Gq/lllRe7KQNXpm1FyUW1wtnALSuSXKd2CY9sLdgBB2c4
	 vp1ksdwvqvIs4POjTEk/E9xt5kolwnuG59CmggUVC4JV/zMPcLxY3lRgFarVJYch6IS7c
	 hFl74OmVjIMdryGua9WGnOyYogFlvNhnd1TYrs5QlKal9TG3xaUI5X1gfIMHH7BanKMiv
	 duvwOSx4s/WbMcGy7PBdqVAHVh/BQEr3ZkrEKJWbSwNoR17q91SyfntOjTJ8IgJ6Neg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xdIqBRcw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5531606A320;
	Thu, 19 Nov 2026 03:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xdIqBRcw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435F81F000C4;
	Thu, 19 Nov 2026 03:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057757;
	bh=rXl6DRVrLSW2AsPLDu3Ek6WFX6jcqnV3Dg+rUC7fe1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xdIqBRcw5gdnlaeuRb93KtiecMVKa6kiQKFG41/LFxToAGmd5lyfm4cz74OuJZYHx
	 g2WYEUx4qK+p+MMdqwL1veen8L9fuL/1EqcWdJwBFz97vxa8xhnOaTK68BXVSQIGQz
	 566F6qrbnmokMKgQ/XLILawTz+ZnZ5h9DOOqLHgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com,
	Anuj Bolewar <bolewara@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 0243/1848] media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path
Date: Wed, 18 Nov 2026 15:38:01 +0100
Message-ID: <20261118145922.051166930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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


