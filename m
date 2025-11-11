Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA312BE7B8;
	Tue, 11 Nov 2025 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824556; cv=none; b=ICC7XyZYv2KE9L4ddRyNrxT78/EaxROnUVIgCd2gu7NiYrWKIzXB7I25QLYbmg8wga9zB6tcCteOzWwS3nvA3aGZOFIg/Ok9Axr7l2lcDK187fltgTT4+NGWdAykyO+k++YSOwUE15aMNmIyKZ7Qb/jhi1N14GBDzLCJSRZ+I/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824556; c=relaxed/simple;
	bh=ATNOZwyJ5D25yPtGLg4KcnLuWADrxhQl08ukv0kzR8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIO6h4CAc8SCtoKK4IN6pU9sD+VtNightUJmNT6GbDbzbkBRMiHPs68Zbiv2CVC2lvrUsyWa7O+cmdXDPNBxd4FcqHvU2yymjO8ZckSW7BXY0Bv4zfCsgDNsLNjknKcdJq6IBMdQkuxB3TzzXk8ZgzpzzjlUL//yfMvDjYxfjeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00KXPD8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00KXPD8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184E9C19421;
	Tue, 11 Nov 2025 01:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824556;
	bh=ATNOZwyJ5D25yPtGLg4KcnLuWADrxhQl08ukv0kzR8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00KXPD8mH19/3DNTe0yKzrKU0VTaYe8X29Wfysv5QFnEtlTB42JwEaOHKafUVFvqP
	 HloWDCyklTZ5Nuii5jyWrrsCU1N8P4xBhzTLbgG6/bKMQAWzslY8mD9FoZ4lxHxTXU
	 dhgnNvmlTpLLcMfaiEebjmvieF3VtGQRAP9RCUQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 523/849] net: devmem: expose tcp_recvmsg_locked errors
Date: Tue, 11 Nov 2025 09:41:33 +0900
Message-ID: <20251111004549.067210126@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 18282100d7040614b553f1cad737cb689c04e2b9 ]

tcp_recvmsg_dmabuf can export the following errors:
- EFAULT when linear copy fails
- ETOOSMALL when cmsg put fails
- ENODEV if one of the frags is readable
- ENOMEM on xarray failures

But they are all ignored and replaced by EFAULT in the caller
(tcp_recvmsg_locked). Expose real error to the userspace to
add more transparency on what specifically fails.

In non-devmem case (skb_copy_datagram_msg) doing `if (!copied)
copied=-EFAULT` is ok because skb_copy_datagram_msg can return only EFAULT.

Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250910162429.4127997-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ba36f558f144c..f421cad69d8c9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2821,9 +2821,9 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 
 				err = tcp_recvmsg_dmabuf(sk, skb, offset, msg,
 							 used);
-				if (err <= 0) {
+				if (err < 0) {
 					if (!copied)
-						copied = -EFAULT;
+						copied = err;
 
 					break;
 				}
-- 
2.51.0



