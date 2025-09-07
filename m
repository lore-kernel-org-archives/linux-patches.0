Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720A222F74D;
	Sun,  7 Sep 2025 20:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275981; cv=none; b=NRzxYyNjBW/iRE3LH1tT5NRVjyWRUfn+/0SffSVYGMy/nFgshpbK1DfJw/SzXhfuHfBEfIWpFdJeyjb827I/5kdxmbdVnTNvjJyAgYMhlgmVzdHnsJEtUVwKG2dtBM//ifc97Ghw+ldAImQncxkxuJIgTTkHhYRftwo+VxGWQ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275981; c=relaxed/simple;
	bh=LFjSyzjGEfmSQzaovEz4g3FNiDhdpObhpwlwTT4VTPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4liXNTG78giqeqJ5AsQmla7xvu+5uF4zaX5iqVYl8m4tiqJl5ZJZclQ/vnEzQISGP5bb76urtSOvbB7K2u50kcBeNyyRzaxyHyhq/Njf6f1UViSVIA/HUCkL198ArYSM0v+eSR0BYZ33IUrFD0AxEhkQzZEoJt7l3cwvi06UIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNw6ig/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNw6ig/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B217DC4CEF0;
	Sun,  7 Sep 2025 20:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275981;
	bh=LFjSyzjGEfmSQzaovEz4g3FNiDhdpObhpwlwTT4VTPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNw6ig/AIjU4FTELJoMNMGtgaWQ0Kv1vC66hUmExeVSL5N98LwTcO5hPudgsD3ORE
	 MtCfbtLY8JmW1TnNhkgnVeeGG6/gs1opyOgVbXtAFBkfKXMCV86A28rjbUsl4RBxbX
	 ejCOAtquU69ucZ+AWer3lA435gx16SVg9fxPoan0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/64] ppp: fix memory leak in pad_compress_skb
Date: Sun,  7 Sep 2025 21:58:07 +0200
Message-ID: <20250907195604.085282027@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 4844123fe0b853a4982c02666cb3fd863d701d50 ]

If alloc_skb() fails in pad_compress_skb(), it returns NULL without
releasing the old skb. The caller does:

    skb = pad_compress_skb(ppp, skb);
    if (!skb)
        goto drop;

drop:
    kfree_skb(skb);

When pad_compress_skb() returns NULL, the reference to the old skb is
lost and kfree_skb(skb) ends up doing nothing, leading to a memory leak.

Align pad_compress_skb() semantics with realloc(): only free the old
skb if allocation and compression succeed.  At the call site, use the
new_skb variable so the original skb is not lost when pad_compress_skb()
fails.

Fixes: b3f9b92a6ec1 ("[PPP]: add PPP MPPE encryption module")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250903100726.269839-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 5cb06e04293e3..91a19ed03bc7d 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1752,7 +1752,6 @@ pad_compress_skb(struct ppp *ppp, struct sk_buff *skb)
 		 */
 		if (net_ratelimit())
 			netdev_err(ppp->dev, "ppp: compressor dropped pkt\n");
-		kfree_skb(skb);
 		consume_skb(new_skb);
 		new_skb = NULL;
 	}
@@ -1854,9 +1853,10 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 					   "down - pkt dropped.\n");
 			goto drop;
 		}
-		skb = pad_compress_skb(ppp, skb);
-		if (!skb)
+		new_skb = pad_compress_skb(ppp, skb);
+		if (!new_skb)
 			goto drop;
+		skb = new_skb;
 	}
 
 	/*
-- 
2.50.1



