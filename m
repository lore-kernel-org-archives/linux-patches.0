Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060036;
	b=rtU9QRk0EcQO4PRiMy14YdE+DraqT0lIXpMGtuBgHiGQc4fcQfd2y8CccWojl240+rs/
	 YxUNY/Jd0gVVBy2NfIIU9wY3RhsSLJPHrX9960ujJ85tdczbSizNjV4Yy3LUrITqR4MB6
	 LfMlP8/kQBhKFmuNsCMj803eFW4OI2cjRyfDGcRzOISBgUZ0csKZDrhtVVivat5zJJqDD
	 KXFbm/b+PyCZfiZDps+cOiVfPsOXEgXzPo3sSabS26Dok6dR5P2l3Nxnk0CVzbCqae1yA
	 eaaE4Srhp7A9mlhYhFOfK2KcEF46qZru2T0BtCk5mdyr/ClA/itwRf47Ro1yiXf0Yag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dU2igYKQgprvPmT62HmPx8FjnVLKNka3ZIfnXKJJ6PM=;
	b=GEdPe/DoOL47CSmpmxBD84SUWncs+so+6yB0ToDVgOJMBAHhTofShZdQq/spCfz6SDPm
	 fJ8zVLbjpPSf7HYvTV8mB+hqkc87kTTZqyZWnOSz1QllfbxwXhw+WLSLSRn+9meWAHwbG
	 fYjUfzx9w/1P0U+ZLyJE3X3Fn+bKJK2YDkUezAOhus+7f9Qbb5VgPr17VA2TvFLnXvYvo
	 cUe/PO0/Eu5Opk1tc6zDqMc0hb2TIDT4yELy2/s8XXOaG8zAf2mDxiS7wb663w/7ZMCBf
	 1dPglSQTVoV97tqmUARcW5dnNmVkXRSB2DUMWx17tiK2braF42WxCI7DnQiqoFb3GtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjEbyg9s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085A7606A325;
	Thu, 19 Nov 2026 03:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjEbyg9s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5834B1F000C4;
	Thu, 19 Nov 2026 03:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060035;
	bh=dU2igYKQgprvPmT62HmPx8FjnVLKNka3ZIfnXKJJ6PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjEbyg9s88qUcoue2/kC0EYgVKLwz2ccSJ8Q0GOAIYAAguxz/wWDj9DegTC7WPwhW
	 wVjb0i5yvMFZltFUOXkj7sVUJ58efe32FtHjGNZ1E6GPWDCxezmSxXCjN49//4xiG3
	 /xvm/aaG7rW4CSTm3v1sVbOswj3qLlM0FK+/OO1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1054/1848] 9p/xen: fix refcount leak in p9_xen_response() on wrong tag
Date: Wed, 18 Nov 2026 15:51:32 +0100
Message-ID: <20261118150001.417685931@linuxfoundation.org>
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

From: Yifei Gao <gyf161023@gmail.com>

[ Upstream commit 4d183e6f153245aca2534e372152583b868dd925 ]

p9_xen_response() looks up the request for an incoming reply with
p9_tag_lookup(), which takes a reference on the returned p9_req_t. When
the tag does not resolve to a request in REQ_STATUS_SENT, the function
warns and continues the loop without dropping that reference, permanently
leaking the p9_req_t and its msize buffers. The reply header, including
the tag, is supplied by the backend, so a malicious or buggy 9P backend
can leak kernel memory on every crafted response.

Drop the reference before continuing.

Fixes: 728356dedeff ("9p: Add refcount to p9_req_t")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Message-ID: <20260806144255.4167019-1-gyf161023@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
[ sashal: changed p9_req_put(priv->client, req) to p9_req_put(req) to match the one-argument API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 45a16494bd79f..3a41984275256 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -233,6 +233,8 @@ static void p9_xen_response(struct work_struct *work)
 		req = p9_tag_lookup(priv->client, h.tag);
 		if (!req || req->status != REQ_STATUS_SENT) {
 			dev_warn(&priv->dev->dev, "Wrong req tag=%x\n", h.tag);
+			if (req)
+				p9_req_put(req);
 			cons += h.size;
 			virt_mb();
 			ring->intf->in_cons = cons;
-- 
2.53.0



