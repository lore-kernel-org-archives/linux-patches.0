Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032345;
	b=kBUDvr7INrw/le8RjkVxS5sIKeyX2Rkaju7BgqzAo4El3L+Jkq7jnUI0DAe7wm2DYKIg
	 yCA3w7M1Ra7cJGdVAGdGgg2fZiZhZCHSIw/5l16wjAKoB44c16IdfaUNjNfRNEJUs6zKe
	 fqjnLuHrvaIHugTRmidHd2dsyLZzkyT6/Rv/epyHWsufyQkq3wfPvsIQCofJujXQ6JU4z
	 wOyQCegegG8PA7+i/J9QBysuldbIy9rqdgJn23TkeJ0+zPoRdBXq7o7jlBlUQCqW33DSN
	 vibcZZFXkBNGIH2fhOQxz98bFt1EEc1uGIRgK/F2ibYWHciJRtqeedEVoXeg1ewcr8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jT0/ntjPUnPQ4k5955QV0MvXJZACu0j6ex7q56k2BtU=;
	b=tdYX1HQVooJvlnq5DcxKfPgbhWs6MXqBRfld84J1tSFpaOuTgrHp48k3CIvafsA2N2j3
	 Q6fUdYyOmpqJSYk02AQUYsFsafz55KWY/2qZspyL6gS/kZjrWC6ikeVuMf6INf990SqLa
	 Q9y8h4/gSCw6/xdko6QdFkc01TJ0eMD4ifwVW76NL8b5bCOR/pMNGq5XLhcooMD+c8liM
	 Z2kXoMscm963v8pEIma8MNdcdDIWvIQMRI9jN26M44EPlsUTIwMA/mkn+4VQ6Mupjb4kc
	 qOk0JDCju7do/gds02fNd4BR5qn7saF6lHAPGkU+vbGRL74UrYkmkphXd/NNpCQGsJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6VhkTn1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80367606A31C;
	Wed, 18 Nov 2026 20:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6VhkTn1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB551F000C7;
	Wed, 18 Nov 2026 20:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032345;
	bh=jT0/ntjPUnPQ4k5955QV0MvXJZACu0j6ex7q56k2BtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6VhkTn17g3gDQQqXn5boTQTdOYGIYPOGzXVCSrRuCUt/VBiP+/NK7GByyY+gtA0T
	 KtjBmVSFADBwavHpG/qH0lpL4yXh2dwxIzAuKwHH5tsDp+tHf9rYtSi6t3nqMuGEml
	 skumDf0MH6h57RpRiSK65NSWXodRdbCt5/gtrDIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1380/1756] bpf: fix cgroup_skb prog test run direct packet access
Date: Wed, 18 Nov 2026 15:58:27 +0100
Message-ID: <20261118150104.131221043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahe Tardy <mahe.tardy@gmail.com>

[ Upstream commit ed3e469d021cba343a3b32f0876f8f28b1d9bfdd ]

This is needed in the context of Tetragon to test cgroup_skb programs
using BPF_PROG_TEST_RUN with direct packet access.

Commit b39b5f411dcf ("bpf: add cg_skb_is_valid_access for
BPF_PROG_TYPE_CGROUP_SKB") added direct packet access for cgroup_skb
programs and following commit 2cb494a36c98 ("bpf: add tests for direct
packet access from CGROUP_SKB") added tests to the verifier to ensure
that access to skb fields was possible and also fixed
bpf_prog_test_run_skb. However, is_direct_pkt_access was never set to
true for this program type, so data pointers were not computed when
using prog_test_run, making data_end always equal to zero (data_meta is
not accessible for cgroup_skb).

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
Link: https://lore.kernel.org/r/20241125152603.375898-1-mahe.tardy@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 6aff0129f327 ("bpf: Use the socket of a sk_lookup test run under RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 17bc05b542eda..daafbaa488f25 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1023,6 +1023,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	case BPF_PROG_TYPE_LWT_IN:
 	case BPF_PROG_TYPE_LWT_OUT:
 	case BPF_PROG_TYPE_LWT_XMIT:
+	case BPF_PROG_TYPE_CGROUP_SKB:
 		is_direct_pkt_access = true;
 		break;
 	default:
-- 
2.53.0



