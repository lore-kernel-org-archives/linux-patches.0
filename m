Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590230;
	b=ip90EI2CVL3Yi2/7J0a3LCFC0hkkunhc9egFuIDqUV6l6faz35zJILdUGVPQQVSwXvJ9
	 ySndkl/qnZ/6HvpCT2/4KOYVJlbHdLxwdMMekdbX26/mbdHIQIAMGme/NcH/ckukKBsP/
	 dqzqAVmDc+rQAP4/QtQK/APCLS3E47uCL25d6/XQ80HvRXtLADiH0kYK026lK3PyJ+h/U
	 A6trpdFQHG+laedl61NtTHvSnFOn5So+WmHuZWOKdTkeyvGBCV1InQLS9SsJs0/Ia8BCH
	 6JVoq4c9hWO4XZ2E+n/AxdfGSlkg3t7H+RffCVl0AH7Jg2wZVp9iThgunwjmGtV9org==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p3KyQQBF6OkvUys9i2ePeOfFIaRnJxtuIX/4Y57xhIU=;
	b=Xc/x3on6z2ZQLJxDppdprCMld2JCYtlFNNSiOyg2bUSfl/98JpkhJV3ExGNYzl+tbuPb
	 O7kX/jVLwSyCgBubPhYXufVqLDQl1BOMt/1oNRASfok9fam9jr/yNU+5Vu3UyBCNP9pL5
	 Te1KHSXiKtN4cuJlGn3hnBZOp9GRunRYrXSA1ESeUkuzBJJszzXKtdcpD1ZxOKbRFGTNv
	 LnZ5hENFcHEjU4cvBH0lDCGXdoOz+jDuw8dZj8F/1QQ55vDPH4zPn+Z4ibgmO3gLFw+9o
	 SWV6HoWY8LqGKHhiM7s+j/7vhwnJBLzfBpR+eZiYqDqfxRSeBAKSbxhfcEJK4YbrkKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BfhL0AAQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65E4606C0B6;
	Fri, 13 Nov 2026 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BfhL0AAQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632741F000C4;
	Fri, 13 Nov 2026 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590230;
	bh=p3KyQQBF6OkvUys9i2ePeOfFIaRnJxtuIX/4Y57xhIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfhL0AAQSBplGHhXfAthvkIx6SGthRyICpofaln/QveSfP80eLQkeVoXdMLg5NG1Y
	 HGSKVWfoi92gnDeB9fpyBq+3XxOSZcMNHSFNroCu2RxW/uv7Rea3cCspTYkALYyvQ+
	 nCZZRjL9IliWqmN5+WLqtj+0CXV+7hwn/dyPvibI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/686] net/9p/usbg: always reset completion when disconnecting
Date: Fri, 13 Nov 2026 10:45:21 -0500
Message-ID: <20261113153827.371039027@linuxfoundation.org>
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

[ Upstream commit 08c6b9f484a406d9d87c5b2580725d2e0597f3b9 ]

When some tx or rx transfers were pending while closing the connection,
the completion handler could catch one pending completion call. To
ensure a normal start when mounting again, we have to reset the
completion and flush any pending completions.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-3-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index f1773749d9124..0b04363c39793 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -467,6 +467,7 @@ static void p9_usbg_close(struct p9_client *client)
 	mutex_unlock(&usb9pfs_lock);
 
 	disable_usb9pfs(usb9pfs);
+	reinit_completion(&usb9pfs->send);
 }
 
 static int p9_usbg_request(struct p9_client *client, struct p9_req_t *p9_req)
@@ -755,6 +756,7 @@ static void usb9pfs_disable(struct usb_function *f)
 		usb9pfs->client->status = Disconnected;
 	spin_unlock_irqrestore(&usb9pfs->lock, flags);
 	usb9pfs_clear_tx(usb9pfs);
+	reinit_completion(&usb9pfs->send);
 }
 
 static struct usb_function *usb9pfs_alloc(struct usb_function_instance *fi)
-- 
2.53.0



