Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026107;
	b=yaltB0d9y9TfdbJwQif5EkGt/kGM5+SOQTqYJKnxcM6r0Md0NdIMoIHGpdZmqa6xXP/8
	 fx1vVcS9tteN5GkUHcARHkgOY1++XwDNKTtFmKZU9sPWFthBq2anwV8Rck9T9NBRHq+bv
	 MhhXEj+vKGV8GozYYrvyMNod3EDNxG/4OJS0NiBdGj4kUE4tgdYzM9tnj1aTD3Y1Jcjgp
	 MEQv4D/wv12aMU0DRAPhC8GHXvI0rl0NosMwF1aGKqZKVYgxmARjBzwAXK5Og/1R+/2lg
	 YpwA2iAHTTUs6oKDEpIEW0PJFN7GfB9WxQlp1ZmDkoszjcqp9uCtdgzC8cwrUIs9s+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZFce25d+2Oot1y+si6VhhmD8jVoGDi/S7koVOmYIixE=;
	b=BAL1269bNIMuaed3BIvNcCzbWd5l5LG3CK3UQz2F4e6Kc/ymODquqEJV8dtyRp+CoyBL
	 UHvSZnGOsB2NUkQc+57ickySVEny6t/TAEnGiRiPHCaJwwx1DLdBgYf4ZhQ/w/qtBLiBi
	 +uh/m8y98LQWd9qyQhGBnRKA3pHEZagBP1mxt9pii+G+iUnWRItV66GigTw05SDs+01O/
	 bzcb7zdUU24PBC3hO5lU9wtSCeoyiV5RGPHcXNR9AgH5viscnA2lXlrmyQAbl5TCkSKfp
	 eqDjwROt/M2UDi95v4YSTN1iqJ7QTg+VgKzkH383fSYnLRdnpr5OX78+b6Xw3F6/YBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/AGGPyA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE37A606A33A;
	Wed, 18 Nov 2026 18:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/AGGPyA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6191F000C6;
	Wed, 18 Nov 2026 18:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026107;
	bh=ZFce25d+2Oot1y+si6VhhmD8jVoGDi/S7koVOmYIixE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/AGGPyAi0MKY9QXXZU3LgsVxE5mdXSZ8tXLYrJXGyaVVG4UTSANmrLEtwLRMbmx9
	 0E4asgMdw0rTCU7S2z9DXJ5u0kFgoRQ6ysE9S9Qr7asvUe10vPo9DrjODfnP9fiVRS
	 3OLfvaXUpKifIFr7MuAxyu6hpruJR5ZCSkRFucLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1316/2151] bpf: test_run: Fix false -EBADMSG after skb leaves CHECKSUM_COMPLETE
Date: Wed, 18 Nov 2026 15:50:51 +0100
Message-ID: <20261118150210.032393392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Skokov <skokovmaksimevg@gmail.com>

[ Upstream commit 36edb1c7738dade8ed83ec4e0aef000e538b2095 ]

With BPF_F_TEST_SKB_CHECKSUM_COMPLETE, bpf_prog_test_run_skb() computes
skb->csum over the packet from the network header to the end and marks
the skb CHECKSUM_COMPLETE. After the program has run, it recomputes the
checksum and returns -EBADMSG if it does not match skb->csum.

bpf_skb_change_tail() resizes the skb with __skb_trim_rcsum() and
__skb_grow_rcsum(), which move a CHECKSUM_COMPLETE skb to CHECKSUM_NONE
and leave skb->csum as it is. The post-run check still compares against
that stale value, so a correct program fails with -EBADMSG. After a
trim, skb->csum still covers the removed bytes. After a grow, later
writes cannot update skb->csum, even with BPF_F_RECOMPUTE_CSUM, because
skb->csum is only adjusted for CHECKSUM_COMPLETE skbs.

skb->csum only holds the packet checksum while ip_summed is
CHECKSUM_COMPLETE. With CHECKSUM_NONE the stack does not rely on it and
validates the packet in software, so there is nothing to compare. Only
do the check if the skb is still CHECKSUM_COMPLETE after the run. A
program that keeps the skb CHECKSUM_COMPLETE but leaves skb->csum stale
still gets -EBADMSG.

Dropping the checksum offload is documented behaviour of
bpf_skb_change_tail() ("implicitly linearizes, unclones and drops
offloads"), and the stack does the same in other places, for example
skb_forward_csum(). The test harness has to accept CHECKSUM_NONE either
way, whether or not the helper is later taught to keep
CHECKSUM_COMPLETE.

Fixes: a3cfe84cca28 ("bpf: Add CHECKSUM_COMPLETE to bpf test progs")
Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009174755.22026-2-skokovmaksimevg@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 963fee5d01e24..f6648d88b76a5 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1127,7 +1127,13 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		memset(__skb_push(skb, hh_len), 0, hh_len);
 	}
 
-	if (kattr->test.flags & BPF_F_TEST_SKB_CHECKSUM_COMPLETE) {
+	/*
+	 * A helper such as bpf_skb_change_tail() may have downgraded the skb
+	 * from CHECKSUM_COMPLETE. skb->csum is then unused by the stack and
+	 * there is nothing to validate.
+	 */
+	if ((kattr->test.flags & BPF_F_TEST_SKB_CHECKSUM_COMPLETE) &&
+	    skb->ip_summed == CHECKSUM_COMPLETE) {
 		const int off = skb_network_offset(skb);
 		int len = skb->len - off;
 		__wsum csum;
-- 
2.53.0



