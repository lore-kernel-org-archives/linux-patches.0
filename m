Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C54D33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3269C433F0;
	Mon, 16 Jan 2023 16:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885071;
	bh=RBiS6fcv0YJXok61UF7LsTRXGo9xtxxD/KWz0I85TBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAhASoBrzEoy9nPvOv7wqzH1b5a2d/Ewox+3c9m80DAJ48hK/cLJ167MI91bIs2xF
	 vAGVCiv6CT70UfHZ2F4CZioHohCn+xfYWWMSG/ADKKyZZkuM0g867e2RIb0VG7Xwod
	 bGag/Qey/9QDl59TJTHD0cXo2YVWT0sZCBP5bHBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <zengyhkyle@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 34/86] ipv6: raw: Deduct extension header length in rawv6_push_pending_frames
Date: Mon, 16 Jan 2023 16:51:08 +0100
Message-Id: <20230116154748.506557540@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

commit cb3e9864cdbe35ff6378966660edbcbac955fe17 upstream.

The total cork length created by ip6_append_data includes extension
headers, so we must exclude them when comparing them against the
IPV6_CHECKSUM offset which does not include extension headers.

Reported-by: Kyle Zeng <zengyhkyle@gmail.com>
Fixes: 357b40a18b04 ("[IPV6]: IPV6_CHECKSUM socket option can corrupt kernel memory")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/raw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -539,6 +539,7 @@ csum_copy_err:
 static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 				     struct raw6_sock *rp)
 {
+	struct ipv6_txoptions *opt;
 	struct sk_buff *skb;
 	int err = 0;
 	int offset;
@@ -556,6 +557,9 @@ static int rawv6_push_pending_frames(str
 
 	offset = rp->offset;
 	total_len = inet_sk(sk)->cork.base.length;
+	opt = inet6_sk(sk)->cork.opt;
+	total_len -= opt ? opt->opt_flen : 0;
+
 	if (offset >= total_len - 1) {
 		err = -EINVAL;
 		ip6_flush_pending_frames(sk);


