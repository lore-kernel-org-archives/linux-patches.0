Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E73C1774C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43272C433C8;
	Wed,  9 Aug 2023 11:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579526;
	bh=7WqIXVJjjXn4YyVH0aXGZLycQ7Al6o78RONUKWpTe4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJ/6BWa9dLSRmcONz/BFKJni8tZYCXSSlf7pjAMc3kuNW+CekUy4TlnqPZCnDTt1b
	 PXocMGQx6HXIBmQFgH5Z2Yat5a0vzHbngfYWbaIdZj1XcQ+BAEek50apvDhfkCERVI
	 ihM1wSTdGt14rsVdMaEIOQ0moFH1XGMIHN27CZIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengcheng Yang <yangpc@wangsu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/323] samples/bpf: Fix buffer overflow in tcp_basertt
Date: Wed,  9 Aug 2023 12:37:41 +0200
Message-ID: <20230809103659.178192322@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit f4dea9689c5fea3d07170c2cb0703e216f1a0922 ]

Using sizeof(nv) or strlen(nv)+1 is correct.

Fixes: c890063e4404 ("bpf: sample BPF_SOCKET_OPS_BASE_RTT program")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Link: https://lore.kernel.org/r/1683276658-2860-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/tcp_basertt_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/tcp_basertt_kern.c b/samples/bpf/tcp_basertt_kern.c
index 4bf4fc597db9a..653d233714ad0 100644
--- a/samples/bpf/tcp_basertt_kern.c
+++ b/samples/bpf/tcp_basertt_kern.c
@@ -54,7 +54,7 @@ int bpf_basertt(struct bpf_sock_ops *skops)
 		case BPF_SOCK_OPS_BASE_RTT:
 			n = bpf_getsockopt(skops, SOL_TCP, TCP_CONGESTION,
 					   cong, sizeof(cong));
-			if (!n && !__builtin_memcmp(cong, nv, sizeof(nv)+1)) {
+			if (!n && !__builtin_memcmp(cong, nv, sizeof(nv))) {
 				/* Set base_rtt to 80us */
 				rv = 80;
 			} else if (n) {
-- 
2.39.2



