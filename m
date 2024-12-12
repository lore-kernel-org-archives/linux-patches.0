Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A261487CD;
	Thu, 12 Dec 2024 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016754; cv=none; b=QcSRuN0ChsOTIDB00/NoEZTS8tao5CU9k08K+z/MpDmaJV1SXK1BUUzuzsKiZPMZ0Kak1BE3n7b15eoduw2m+vqeb9RDC1gjhqgPRAN0Y83wopYXiowIqrur6mwd4tqEFvP0h8pGFEFeZknHy47j4/Imi0JgfNmQlKNe1GOLHNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016754; c=relaxed/simple;
	bh=wS8+QfuK5Mn9lJZHrd5ufEHRcWR41O64fec9AfA69K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0Kekfa47athxjCcnKBdDwqg8inKerzaW1DjIaCBqcUV0T6ggsNmg/RtUptuRZudWeKOM5RyUfKFbspR1z+q/8orLKTqhTwjh9xBMfCVmGUkWR0bg1O3DZ6jH5GZBXmi7bkaMG7tUg6Q63+RnEfxfJgkYoUMNaqytEK18oLQesw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vx45bvmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vx45bvmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2A1C4CECE;
	Thu, 12 Dec 2024 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016754;
	bh=wS8+QfuK5Mn9lJZHrd5ufEHRcWR41O64fec9AfA69K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vx45bvmMyL2UAewztCerqqwXOEvVIOmT3tCoUUuXBLgI1k3Im21p6XQPEuXZjzWDh
	 IbtXQeX5mXyENbzv9mb8OeedrKaPoJCJ5xdEaVmWqzxSs2n63Up32Oh5B2i/NRsqtN
	 yeouBn0b7CEEx7yENU8w909Jdn15kMN0SvchyLoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/466] Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()
Date: Thu, 12 Dec 2024 15:57:37 +0100
Message-ID: <20241212144318.165784175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit 7c4f78cdb8e7501e9f92d291a7d956591bf73be9 ]

bt_sock_alloc() allocates the sk object and attaches it to the provided
sock object. On error l2cap_sock_alloc() frees the sk object, but the
dangling pointer is still attached to the sock object, which may create
use-after-free in other code.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014153808.51894-3-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index ba437c6f6ee59..18e89e764f3b4 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1886,6 +1886,7 @@ static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock,
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
+		sock->sk = NULL;
 		return NULL;
 	}
 
-- 
2.43.0



