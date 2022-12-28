Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19E51875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE5CC433D2;
	Wed, 28 Dec 2022 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243313;
	bh=zRmOWPRb49a4R/+sFUKzNRYqucu/8Fs+8TYCMg8/Wuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4PGgA1RCGY0FGyMpAAoXIqu8EvAtoxvgswCLhMAeS8U4Ewc6l2q8FMAlKRGYOYIS
	 05m2VxyYdHbvCgh8eOn+vIqZpSi1Dw9RA9O/Ocu4wX/lm9CSU+Ow1bvwf4uMjbuvuB
	 TJvJcyxECY0gOB8DYIa8j0UcnWpUPDuRlD2QVBEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0479/1146] bpf: Add dummy type reference to nf_conn___init to fix type deduplication
Date: Wed, 28 Dec 2022 15:33:38 +0100
Message-Id: <20221228144343.193341417@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 578ce69ffda49d6c1a252490553290d1f27199f0 ]

The bpf_ct_set_nat_info() kfunc is defined in the nf_nat.ko module, and
takes as a parameter the nf_conn___init struct, which is allocated through
the bpf_xdp_ct_alloc() helper defined in the nf_conntrack.ko module.
However, because kernel modules can't deduplicate BTF types between each
other, and the nf_conn___init struct is not referenced anywhere in vmlinux
BTF, this leads to two distinct BTF IDs for the same type (one in each
module). This confuses the verifier, as described here:

https://lore.kernel.org/all/87leoh372s.fsf@toke.dk/

As a workaround, add an explicit BTF_TYPE_EMIT for the type in
net/filter.c, so the type definition gets included in vmlinux BTF. This
way, both modules can refer to the same type ID (as they both build on top
of vmlinux BTF), and the verifier is no longer confused.

v2:

- Use BTF_TYPE_EMIT (which is a statement so it has to be inside a function
  definition; use xdp_func_proto() for this, since this is mostly
  xdp-related).

Fixes: 820dc0523e05 ("net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221201123939.696558-1-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index b35f642d117f..9b2e18c0d299 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -80,6 +80,7 @@
 #include <net/tls.h>
 #include <net/xdp.h>
 #include <net/mptcp.h>
+#include <net/netfilter/nf_conntrack_bpf.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -7988,6 +7989,19 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	default:
 		return bpf_sk_base_func_proto(func_id);
 	}
+
+#if IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES)
+	/* The nf_conn___init type is used in the NF_CONNTRACK kfuncs. The
+	 * kfuncs are defined in two different modules, and we want to be able
+	 * to use them interchangably with the same BTF type ID. Because modules
+	 * can't de-duplicate BTF IDs between each other, we need the type to be
+	 * referenced in the vmlinux BTF or the verifier will get confused about
+	 * the different types. So we add this dummy type reference which will
+	 * be included in vmlinux BTF, allowing both modules to refer to the
+	 * same type ID.
+	 */
+	BTF_TYPE_EMIT(struct nf_conn___init);
+#endif
 }
 
 const struct bpf_func_proto bpf_sock_map_update_proto __weak;
-- 
2.35.1



