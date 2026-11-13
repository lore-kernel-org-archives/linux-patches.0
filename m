Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591010;
	b=hMi8kWa+5IgB0Za0dsNAS84bYL98Fcojc0uhfAfFGYVLSaQsagI2Kg+GzX4uJ3jaQkVa
	 A8yBLdrrfSv66MJj7TGAkbGLr7pVRjRxbMZ00qRtHQ3tFFsZ4sbvJw4GI3pMVv8TVMVcF
	 7bjVUFBLxgawDp4DetjojJuq31j8cTzucbiAzKVXAv64OCujCyUJ+YfDheWdZSsvoglR8
	 YtZU8lg3EooOHAECOd5LHUJsk2KiVgJO4i+4g/xtpl+dGFWTku5Ek6IvzB9RBiMhCSMGN
	 dOLJqiLPGgi6SNxDx4Mrv1MfZUp1iC36nndUXht3jAB7xG+/aIx66hkPKBpDLrdsGYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vyOFvsV8d2VX9Y9AU60/JXXGfFABnpiO7JsqnlBvuEU=;
	b=RZFKpgLcOa4TMyhpbMvndIRQW+HB3bF3XyGWSkX2u09nnvQm92zhvl6cqxZkwh+Xbu1+
	 3SyysUtcDkT1gaFl6xWRXNOmqUYY088pCI3JkCibJt3eJxse57jUbz0psIETIirECvTJ0
	 ft/KMaZgB2jjaba7MOB2PjWS/9RO6hbD2mEYopyZ8TfjHuiH/pBnVU4Ts4cczMaPFaf9X
	 ROWEKH230V+ubg1aJFn7rEpmfhTDoraYdvQFLzReqCdJmQAxpQXx4iDzveEkbnMjHKBEa
	 bNtxIN9bXBCSDMqOMZH3P/16AOdtthvTDosPhkqLsQP63kPC0duAs4fIxDpl5U6qHfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uw7gmfT8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1156070F1A;
	Fri, 13 Nov 2026 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uw7gmfT8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9A11F000C4;
	Fri, 13 Nov 2026 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591010;
	bh=vyOFvsV8d2VX9Y9AU60/JXXGfFABnpiO7JsqnlBvuEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uw7gmfT8/kXdRm3nLAkApoYwZioJAFLEksAEE1ref49+N9JSaeez0w4l21BbMI/M4
	 M0rJlrNJxaFJRvHjp2mhgLIGXhvcBbI2lt9mzLAIVkwlQMezGQH2xwOcdazWHFNOcz
	 tr6iqFsbshgIXF60xou5dM2hrM5avKMQc/NzLfxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/670] net/9p/usbg: fix out_req buffer leak in disable_usb9pfs
Date: Fri, 13 Nov 2026 10:45:43 -0500
Message-ID: <20261113153818.106579948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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



