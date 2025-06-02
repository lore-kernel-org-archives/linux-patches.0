Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271611C5D72;
	Mon,  2 Jun 2025 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874130; cv=none; b=RklkeJaiD67anPZO4T92235FDGkI1m9nTygwvbQhZz9jXe+SkP3t81H1xb9Dh3j2SGbX7oPEwQCKj3iMR6oN0ts7MaJn+BkS3i9naMRRkxWHMS2eOAWh5NMz3C8u1/OVRC/LnGHcWKWZGn3oEBH18eFIu5pwftmWpddQtSC4xBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874130; c=relaxed/simple;
	bh=6V0OOaHSQVLwQd3Y+xfi0Ms2C8fkuSBCQKGOICl7M88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7UDdJjURUAmMDHjfETrKotqYJJoOzL50x+diU02tNsCMbxowA7sT/jhbevAsrxaqfKWcsuGzhcuraaDN85nTckb9hzWNmvbNhz8OVK/oNhaazuDHdNAPaz+4HRrQYYIBLZa1Zxp5j8Xmkx/n3M8NCR5CmwZIzDPK3qge2OXQSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQf1AakB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQf1AakB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A515DC4CEEB;
	Mon,  2 Jun 2025 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874130;
	bh=6V0OOaHSQVLwQd3Y+xfi0Ms2C8fkuSBCQKGOICl7M88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQf1AakBQO7NRmJC/phNQPGwmKYHvwS5IXICuzaPssXkDKDVvUzP3ScZD1VdHekpE
	 HOKyHlvSbaEIciZOmdY9IH20SEG1I2zbuLIL2rhiJFdvHZqoekuArirdx0V+tdPy9X
	 dRZRKMw/pqw7Sih2dwNqtg0Chpzo5n27UBN0+Xl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 366/444] llc: fix data loss when reading from a socket in llc_ui_recvmsg()
Date: Mon,  2 Jun 2025 15:47:10 +0200
Message-ID: <20250602134355.768082985@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>

commit 239af1970bcb039a1551d2c438d113df0010c149 upstream.

For SOCK_STREAM sockets, if user buffer size (len) is less
than skb size (skb->len), the remaining data from skb
will be lost after calling kfree_skb().

To fix this, move the statement for partial reading
above skb deletion.

Found by InfoTeCS on behalf of Linux Verification Center (linuxtesting.org)

Fixes: 30a584d944fb ("[LLX]: SOCK_DGRAM interface fixes")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -888,15 +888,15 @@ static int llc_ui_recvmsg(struct socket
 		if (sk->sk_type != SOCK_STREAM)
 			goto copy_uaddr;
 
+		/* Partial read */
+		if (used + offset < skb_len)
+			continue;
+
 		if (!(flags & MSG_PEEK)) {
 			skb_unlink(skb, &sk->sk_receive_queue);
 			kfree_skb(skb);
 			*seq = 0;
 		}
-
-		/* Partial read */
-		if (used + offset < skb_len)
-			continue;
 	} while (len > 0);
 
 out:


