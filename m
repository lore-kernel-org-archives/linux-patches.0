Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B7F1DB34C;
	Tue, 27 May 2025 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366173; cv=none; b=UHhR/VF+wHeO4KuMbigklz6h1eieeBwOu0gQx2Ai8VONvTkSAG2+aMg17TMQbQnPeCP+yJilB16CmVFm4eQmAiPupCzV21GYv1/qkjsrmljro5y3LArKFOAl/wL/3O/rVa6e9Jb81mfQMnNVbJqPInnIkcxAZ5eV4Kf2N8FasLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366173; c=relaxed/simple;
	bh=2fsz6B6Xb7V9iWe0tqhhnHpWJfnrw3g4WLht1+/u78g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJBDbdEuSaFLfTfEakzIngxjqlobaEyUs8OrUhxXy1GeMWZNqp0mU+gE2tkZAk11rAKjdxzo1av9oY/FYq4fUImpDa8ScK2MxwAnSIqeAjkIQCauQ7jHH3IaOxrgPPCGJOE18Fkbg+ByfQV0zpumVbhZVRlvdSgyA45IGHYTs3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wn6a9/QY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wn6a9/QY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91B0C4CEE9;
	Tue, 27 May 2025 17:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366173;
	bh=2fsz6B6Xb7V9iWe0tqhhnHpWJfnrw3g4WLht1+/u78g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wn6a9/QYW8P6iIo59qfQBhwhczS1zk4zBHVf/fBcy9Ma7YKJ4zrWmboONmgmgBVDr
	 YoMHrjYpS5yxMlx5ZC5GgUaAXrX5vz+83zExuCpvL52z9OUqKvPI8YNHZkZrN2MtAX
	 xLOGIo1lDkaL/IJXzhHHPcCtXsjbDY4vg+ZaiqnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.12 581/626] llc: fix data loss when reading from a socket in llc_ui_recvmsg()
Date: Tue, 27 May 2025 18:27:54 +0200
Message-ID: <20250527162508.584426903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -887,15 +887,15 @@ static int llc_ui_recvmsg(struct socket
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


