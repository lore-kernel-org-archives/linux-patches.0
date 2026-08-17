Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41B8429CEE;
	Mon, 17 Aug 2026 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974469; cv=none; b=OAhwpM9g33rhFsdeQUL0DFURndakvr2zWM4qJ80hk0V0636PtmuqlOig9vtNpIHI5MCAD+CFux14HleS/cD8rJHi9LnWdPm3DXWrmPhfcUNd7EtxiDnoouvJmTkM6K52xMRKxi9boU7sRXrZ/+ciFGKjGmOEX2322vGXzSKJSVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974469; c=relaxed/simple;
	bh=pZjZjF5DSbvBbrZRBs+VYMpTHoPvvX/56phcai7SvWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqJLuJFdSXaEDgxZzW32uUlfR6VMzZPTpGAiNcN+959pn5RbkYldaC58mtk22BvepDqWX4WmhH77h6DlMsQrS3Xk9p6kyFQHpRO4OYs9ikXh5ZgYokZEDHfiJ8VNHOeJ0ImLqm+/kkAl0bnh9QWcm+vJafJ0296ESbRW6TPkyfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRNaZUGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRNaZUGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F69A1F00A3A;
	Mon, 17 Aug 2026 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974466;
	bh=7ROx+2JSHkC3wEpjpF8cvmNnkBpIhAQTHmauKMFYWDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRNaZUGJUMQCVkKvdiHlnz1V3F5LHNsb1tgXaSTtXEdZJ6dkfv/kR9A+RuZPEzCBQ
	 sHOlmumiqiymlVmDP331AqkDXPtiQQZs6l77E56WkrgyCO0ohTaPI7FWNFgGW6A2Cv
	 mi06xyjkFZuOyaxjSv8jSlA7/HUWt0Yq5rz0m2dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Mina Almasry <almasrymina@google.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 216/271] net: devmem: prevent net-iov / page mixing
Date: Mon, 17 Aug 2026 15:32:21 +0200
Message-ID: <20260817132545.666648553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 53a43508ee332d8bffe40590c3d189c92a551f9f upstream.

We should either have net_iov or page backed frags in a single skb,
otherwise it blows up down the stack. Don't allow mixing in
zerocopy_fill_skb_from_devmem().

Fixes: bd61848900bff ("net: devmem: Implement TX path")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/e3199788c4732545627a4721097ebb71ad737bab.1785150502.git.asml.silence@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/datagram.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -712,6 +712,9 @@ zerocopy_fill_skb_from_devmem(struct sk_
 	size_t virt_addr, size, off;
 	struct net_iov *niov;
 
+	if (i && skb_frags_readable(skb))
+		return -EFAULT;
+
 	/* Devmem filling works by taking an IOVEC from the user where the
 	 * iov_addrs are interpreted as an offset in bytes into the dma-buf to
 	 * send from. We do not support other iter types.


