Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759C518E2A
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AD0C433C8;
	Wed,  4 Oct 2023 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443152;
	bh=o5Od8cWQ0fYLVxfSZeCGK9uP4HxEo1TLsPeTMmu37yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofOEjmSeEKJ0Y3wKEFaGw8IncywF0F/hy9geK6CU64YKibJwnadvrsD+GPifPUWhV
	 Txfaja5Ft7p17R8NYrKW9v54nY+F+SJA3lkze8CUMA/wGPVIaotRcfk5NELTFIx4ql
	 UnNwCTp0CflQ+20N36YYOZ6kbbf1KnT+lLWSDnHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Florian Westphal <fw@strlen.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/259] netfilter, bpf: Adjust timeouts of non-confirmed CTs in bpf_ct_insert_entry()
Date: Wed,  4 Oct 2023 19:53:47 +0200
Message-ID: <20231004175219.918331695@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 837723b22a63cfbff584655b009b9d488d0e9087 ]

bpf_nf testcase fails on s390x: bpf_skb_ct_lookup() cannot find the entry
that was added by bpf_ct_insert_entry() within the same BPF function.

The reason is that this entry is deleted by nf_ct_gc_expired().

The CT timeout starts ticking after the CT confirmation; therefore
nf_conn.timeout is initially set to the timeout value, and
__nf_conntrack_confirm() sets it to the deadline value.

bpf_ct_insert_entry() sets IPS_CONFIRMED_BIT, but does not adjust the
timeout, making its value meaningless and causing false positives.

Fix the problem by making bpf_ct_insert_entry() adjust the timeout,
like __nf_conntrack_confirm().

Fixes: 2cdaa3eefed8 ("netfilter: conntrack: restore IPS_CONFIRMED out of nf_conntrack_hash_check_insert()")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/bpf/20230830011128.1415752-3-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 8639e7efd0e22..816283f0aa593 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -384,6 +384,8 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
+	if (!nf_ct_is_confirmed(nfct))
+		nfct->timeout += nfct_time_stamp;
 	nfct->status |= IPS_CONFIRMED;
 	err = nf_conntrack_hash_check_insert(nfct);
 	if (err < 0) {
-- 
2.40.1



