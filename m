Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585437;
	b=uQaunmocpoCql3VBvWrEdqVqslfirOUkTsQsUqfB1iN7/yUZ/fbZZky9BcZSIFR1xc/d
	 ghteK+xwKStxhPvhygIRRkzkaKUUV5Zh/mZfEvrjsDcfW4iaPcNAEp9u9S/Fdmi5i0y/F
	 90i4G/Ps119LDkpj8xNyM1DVArp/xmWLF5mqzN/ld+ljMdeGwltw1qb87Js4oY4PibaJW
	 +OSzOiv63duQmicxvrT332KbAUEsF3Jd795k3vDtI78X6LKO5N740uYGMmvZVqIrMMnrZ
	 cMoMhc12Qx69/9O6/c8EGv818dEWe7xPN3x02sLqUDj+8/U5kIWlm2toNkyg+N8Q5Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XP0/Mu5q4s6zSUYXpXIPJ+8v6lafPqN86uXGa9NHacA=;
	b=VuWUUgUAQenEH2I87qzYwBj8shp2p1Ge9sQIiIhHnXCdgVPixNqZbYP87CVQw3/h/I2J
	 U84SJYUNK4ITH+4ZdjRGKOHcesIsMIqIMBRH9PTK5xNnFi5wH9kcLdim0I/idab5MJ9NJ
	 JZ3z7F+HqO5G6oqhIToROiqRltFPLh8Gve8gPbYkglCTlVAUFIvE81nnoKlIM9kMqIXlF
	 5XIsYJzqsaSPvToMwqNXQY73/Zz91UIckLbC/adKJzjc5iWzQnzT01SVHLjDGWM1R3pDy
	 PGwTnF/0auwaYqFqyhJXlwpkiAjtzXGCLM5Ws8A54qBaEouZp9n2syIiQVqprrgPrZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIzLBx7p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A31606A8A3;
	Fri, 13 Nov 2026 15:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIzLBx7p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB2B1F000C4;
	Fri, 13 Nov 2026 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585436;
	bh=XP0/Mu5q4s6zSUYXpXIPJ+8v6lafPqN86uXGa9NHacA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIzLBx7pJzns3zW+9nfKMRRZjWLWzk2DN02XsvX5qJ9J8ZI5mtYemOFxZ3RlE0v9c
	 EJYwsOuKR/ZiHva3sxdz8vLdyCkL4PdG+zHE6Lpg/E4ix3ew/t4JspCs/QLGXvRHDJ
	 Xry5JFAE4YQvnmBsdcxCEeqilF4Fw1UuX9Iy8Gbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 055/507] net/9p/usbg: fix out_req buffer leak in disable_usb9pfs
Date: Fri, 13 Nov 2026 10:45:59 -0500
Message-ID: <20261113153755.432428761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit 5f9807270c7bda8f86b312ed1a8acd7716600555 ]

usb9pfs->out_req is allocated with alloc_ep_req(), which also
allocates the request's data buffer (req->buf). disable_usb9pfs()
frees it with plain usb_ep_free_request(), which only frees the
usb_request structure itself and leaks req->buf on every close.

Use free_ep_req() instead, matching the allocator, as documented by
its own comment ("Requests allocated via alloc_ep_req() *must* be
freed by free_ep_req()").

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-5-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index e215d047de16c..af01323db69c0 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -287,7 +287,7 @@ static void disable_usb9pfs(struct f_usb9pfs *usb9pfs)
 	}
 
 	if (usb9pfs->out_req) {
-		usb_ep_free_request(usb9pfs->out_ep, usb9pfs->out_req);
+		free_ep_req(usb9pfs->out_ep, usb9pfs->out_req);
 		usb9pfs->out_req = NULL;
 	}
 	dev_dbg(&cdev->gadget->dev, "%s disabled\n",
-- 
2.53.0



