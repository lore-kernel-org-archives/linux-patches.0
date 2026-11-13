Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585366;
	b=LqOOOQsTqE3szfb1Ala/ZaQ9LPTGPiYb4GsYTCiJjqVppOWjp8tBrUu/iuRiCrXuSSmD
	 lq7jvsvW0/03OmW+apAhUM4QtIQGMgIWSKJ9kILgXGvSi9dZ/rd13IkLzbfK5dpCOk2HJ
	 gWdAmUIXX8eLAleMcNl/e9KLg+522MWoGddF22yr2kpLc6gHS0vW7nROhnLxzlv4po44n
	 v+6tqEC4jmzpH0kG/+pBOQFlZgkQ7E2yevjuAqwCa6Z1Ul1+xZBNEmLCJUannUlnVjROj
	 ilbHSHs4+jit7WhyRnwAh+NsQ5N1lT17uAsDAtwpDkpi18tPUglE5Ybszxojro11yrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l1ltR260KS1Lysy1GkOAsOoH1ufC2Xajk3juVjxQZRU=;
	b=jDL0lRE+MD4uwtu0xY3y9OWe4J1WakEPDtdNu088GA2XmFbSM9FWIkY8IvrF4nSCk/t7
	 CQKe3/PDrFrHmq0HvWDi1XZo7/ksXPGkt1Yjo6UqyeViSe+a9UmZOzAQ5PJeBuF7UO0Ma
	 eekOYKrjzolmFh68vGIUcLdzTw0n1cFhySY8DqPi8VGZi5+WXoJCkYrQeTVLtsTMhVW+i
	 VNMKFJO9+WsGwcjYy3vyFCcWkZNpYCEEIUFLjNWWGB1syjDwkd1lF1CMoKHH8IX8xRNnS
	 hLW5H4IVUietl6WYsmbp0AK2GJOYifWLKWRa3xL+CPy5WoF+y/m5Rd37HSUXlosvU4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Li0VmUdh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9040606EBB0;
	Fri, 13 Nov 2026 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Li0VmUdh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751AE1F000CD;
	Fri, 13 Nov 2026 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585366;
	bh=l1ltR260KS1Lysy1GkOAsOoH1ufC2Xajk3juVjxQZRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Li0VmUdhmLmTwjQcaztqIdhIgh+wz9jZ4Am0dx+S7w4Zpd8RRmjbByq3aP3pxqX0G
	 kxdgKkksBfQvNqz94R/BQeJnhWnAXtt6aYAN0cdz1LD6e9dkCqFBHWAy1Ic2WC42Qe
	 1niS8cExBCqAQsRAYL48IPOOSItMvi6c05XshWho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sandeen@redhat.com,
	Stefano Garzarella <sgarzare@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 043/507] 9p: fix privport option setting wrong RDMA field
Date: Fri, 13 Nov 2026 10:45:47 -0500
Message-ID: <20261113153755.014573160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 7fb9bd3659051ff74a29387de0023bb8300e4aa7 ]

While reviewing a patch adding vsock transport to 9p, I noticed that
since commit 1f3e4142c0eb ("9p: convert to the new mount API"), the
Opt_privport case incorrectly sets rdma_opts->port instead of
rdma_opts->privport, so mounting with the privport option overwrites
the RDMA port number instead of enabling privileged port usage.

Fixes: 1f3e4142c0eb ("9p: convert to the new mount API")
Cc: stable@vger.kernel.org
Cc: sandeen@redhat.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Message-ID: <20260703102254.114446-1-sgarzare@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 274c5157135da..f426cee374148 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -406,7 +406,7 @@ int v9fs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		break;
 	case Opt_privport:
 		fd_opts->privport = true;
-		rdma_opts->port = true;
+		rdma_opts->privport = true;
 		break;
 	}
 
-- 
2.53.0



