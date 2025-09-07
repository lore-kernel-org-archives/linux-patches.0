Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB864315A;
	Sun,  7 Sep 2025 20:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277691; cv=none; b=NL8C2PObfIMkR3uQ0u6tTFy8MIWkR44uDjgHVsPItLAorpuoxd2gd5PYXKnWcvHMzsXo8k+M/rP9OBlAR2CXNQ2TGj53m9lkU5nzzYH8rHL+lWqnoYCrzpA4NG1Tn3G4ZrWGYY5ekk6jKTjcZqf+cXvHWvmH3qNCNolCrwdaWhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277691; c=relaxed/simple;
	bh=tnnLlZpqM4vdRtdmU8hAjrtms1Z63izcERNAQ7ZMVO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRvxfuxKoA+G7v9oluzokpSzWzG5jRDp9sxu3sq41hZrC0S0yLnoPBDjOz4wsEGPhgqg5Or2YrHiqgN293oJuC0ias1dItBx0XIO8OsARn18X2PmWTqMmtEpQQgDl+pc1DW1kg2V/hu8KJ/CdpzMC/kwViNJYGElt0ydRymKz6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWhCaNij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWhCaNij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F19C4CEF0;
	Sun,  7 Sep 2025 20:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277691;
	bh=tnnLlZpqM4vdRtdmU8hAjrtms1Z63izcERNAQ7ZMVO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWhCaNij0PN+v/23RkEfW/uTSZzMZGQ8rqeEcMITFSibbY53UcxAV3ZqGkvJUkME4
	 YBhroFPehQKYUzoEQ3FVmXHRkEAuWat495hEvkDGfIpAFhUqaW/Jg1yOMs3OLJ4snz
	 6Ze7VRV20Nj81/T0Uvr0yuJ5J1ezJ0EpmyEf1mdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 093/183] ppp: fix memory leak in pad_compress_skb
Date: Sun,  7 Sep 2025 21:58:40 +0200
Message-ID: <20250907195617.998740505@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 5e7672d2022c9..bb5343c039259 100644
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



