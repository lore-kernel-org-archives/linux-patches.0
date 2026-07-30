Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FB6449B0F;
	Thu, 30 Jul 2026 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427870; cv=none; b=P4GKc8Z7kbUu63Sa3yLHsEhVLjCo0ruC6h+YVO8k11HOKw2bW6txEYDWnJrkV74np1lFffTLae0AJgqH4pY2VvGxeoZcxiG67b45516E7011eQsORud/e7KulWLz0XCgjvBjAYur0rCgFbYG+EhO8Sdsy6R6RlwV5vA+BHzIvJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427870; c=relaxed/simple;
	bh=LZ8ShmpaStcdeLWs8zzyD4Pcr1ODFm49gCkuXwwPMhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgVtQ3F37uVOcmBmk8jzuUPBod6HqDtzgxnv2mjPUT/6Z/ZDgVxwYYO9TDR/VxgW/T66/8oLJ13iDA1BEb2FXoMVNafT7Rn94grlqeXJ8Aq6RIj9Gd4/3q9azixKd8s44Hrvvx/yZCdK+33DSAwBodv9WbR7wVKJWv+q2e+Xh8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qppnqMKO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qppnqMKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF751F000E9;
	Thu, 30 Jul 2026 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427868;
	bh=pR0TMMnA9rTdAGYPXB25wC6xFCs9wJHC2zZcxnJtTqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qppnqMKOaqXy7leYW9NBJ5ES9LCLMNJu9xetPUMGiEqazhTPkhb8AdgSksr0iDbKz
	 MRNjUN6QivwyozwhSB3jZy08yuKHH16yqNLtkHhsmuiI0DEkoQ2t4ZNOPFU6slCHDp
	 Gp5nRYYPPHIaPBFMSYyRShJXwM/19NXti7n+cj0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 320/484] net/af_iucv: fix NULL deref in afiucv_hs_callback_syn()
Date: Thu, 30 Jul 2026 16:13:37 +0200
Message-ID: <20260730141430.438391329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Hidayath Khan <hidayath@linux.ibm.com>

commit 47a5116e56a6b6fe1e909f244e39cd0fc26ceee4 upstream.

afiucv_hs_callback_syn() allocates the child socket with GFP_ATOMIC.
If the allocation fails, nsk is NULL.

The connection-refused path is entered when the listen state check
fails, the accept backlog is full, or nsk is NULL. The code
unconditionally calls iucv_sock_kill(nsk) in that path.

iucv_sock_kill() does not accept a NULL socket pointer and immediately
dereferences sk via sock_flag(sk, SOCK_ZAPPED). When nsk is NULL,
calling iucv_sock_kill(nsk) results in a NULL pointer dereference.

Only call iucv_sock_kill() when a child socket was successfully
allocated.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260709191732.124092-1-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1873,7 +1873,8 @@ static int afiucv_hs_callback_syn(struct
 		afiucv_swap_src_dest(skb);
 		trans_hdr->flags = AF_IUCV_FLAG_SYN | AF_IUCV_FLAG_FIN;
 		err = dev_queue_xmit(skb);
-		iucv_sock_kill(nsk);
+		if (nsk)
+			iucv_sock_kill(nsk);
 		bh_unlock_sock(sk);
 		goto out;
 	}


