Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590233;
	b=4J3yqEhlF3YAxi+v+q1on0gOWhxauF9casiW9Dm/52LXtJmFy0S85jSopv7G8TOpyQMH
	 iOA3VtcAIk31vGi+4Q7OIo9QU8nCTeXdK29tnIRnWM64Y/SxdmYQHKIBecklvT6n29017
	 Zb9U4Ux4wMmfY0HXJ/1sZYACWSwR2NjAQEMREjQ9cF5UtpjrEdo/d2BzXhU0rUyWm0hsS
	 KH9+6jRie7087/0QaKodAi1PFc/bsW7Vl3gemxPuILFaW9cfZqDEdHOafMamYFqukxf0w
	 ydRdf7VUNjCpw71FNlTh6hem9/3rZ4KUpA13RU/B/AJgCaZq/XX3gKxPWujICtmrYiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPKxzb+SNFFVdmhL7ON19hoAhaG1YwRiSd4TNxhqPaI=;
	b=cYL20c7D3h3uQdndkuu71tdQ0L/5jzTugq2SYKx9IeZfnwEKCm/LK/To6D8L3M7JdFbS
	 jKUDFhiiCyDMY/+jvZEMMFirY7YD9s0RCF2CqtwHqhW0mpNyJ8sjP65RwBxobjkH9c9Mf
	 UUQ4kNV2JHeJh0g+LOfGI0h4x+OrvoDK0g9RWzGjhLCAZeLIpJs7sPAyk50W+6UR9I33O
	 +UoJhrK1ENzr8QSIfFRRJ/ycaJkAnBDUTeCWl4G1h7+gACYHC8HOeDdjW7A+8aam8nVJn
	 lSM3DfcQyvmx7iuV8tcEfyosF0KZddTLxSVH6oAhbgL1XXBUTLadc2N0Sz+1uvps0Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGyh3+lJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B016075E07;
	Fri, 13 Nov 2026 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGyh3+lJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50CD1F000C5;
	Fri, 13 Nov 2026 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590233;
	bh=JPKxzb+SNFFVdmhL7ON19hoAhaG1YwRiSd4TNxhqPaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGyh3+lJyjUCWwHCvT96lzJoMPu/THELUSLae5TKxOmiAybuySm4IT2AGQ4fwRHKz
	 AbeMhTeyTQkOYM0GI9eePdbEjLbxx+NT6mvJ1mT86ZLy/85sDYZwXluXw5ZzCceoSP
	 AcQa0upRRN/+tOo9tsR4SkKN3V3LMSq4u5T2oi+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/686] net/9p/usbg: fix out_req buffer leak in disable_usb9pfs
Date: Fri, 13 Nov 2026 10:45:23 -0500
Message-ID: <20261113153827.443115923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index c58d57232369e..301123725a671 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -286,7 +286,7 @@ static void disable_usb9pfs(struct f_usb9pfs *usb9pfs)
 	}
 
 	if (usb9pfs->out_req) {
-		usb_ep_free_request(usb9pfs->out_ep, usb9pfs->out_req);
+		free_ep_req(usb9pfs->out_ep, usb9pfs->out_req);
 		usb9pfs->out_req = NULL;
 	}
 	dev_dbg(&cdev->gadget->dev, "%s disabled\n",
-- 
2.53.0



