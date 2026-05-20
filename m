Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5783B4028D3;
	Wed, 20 May 2026 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302934; cv=none; b=aYs7aQSy+YaCfTWizwvdqnKixWLz78cit5nvQnehWF/qMwClH27qBiv5Jryvp/UtSAExdg4gFu0Qso1HFx7e+CySrtZkfOESwJjkBLWSXL0RpIRLXDSWASEXF7cQyKzmMyv6927P3+Va23Y0Lk4jwf+TeTLZKVAmNSnN3HfziI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302934; c=relaxed/simple;
	bh=r0PQhRgr5IHpR4IrwuTdWNiQQi+bpWdz3YsfFrLFgpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWeA8IuEzp1H/IGk0vzq41wdCuKQ/3aU3W0cmKUEXuK779KZbzqoTrkg4iJDTI0ettQutYq2B+RbrBwI5O3j1jwB2NhjPJyJmYtDw/47aPyX/NIukVkOvTx8e+IPt9l94Tk/5lRCDjIddVlG+wtKrRFFonwk+oSP03v1+a5Rp58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmaE8lBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmaE8lBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24AA1F00893;
	Wed, 20 May 2026 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302930;
	bh=2b8bQNZN4WFEo7n/fcEtz15/ovos9N8CwmL7JjeFBVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmaE8lBHdOE6UHDPtMblX6+Lj9foVFkzWlGBSbGTHszMr7qVdYbZNBxJYVuMgLinZ
	 fPFzz0EVSwocbG3dDatAtpnNdmG+DUEaqj3iru/0cBDHw/Lw43HXLOkfTFGpIKGSvS
	 02kadQEpERrjV23s+4r5Pimxb6H5aNQEL1AaHWa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 454/508] netfilter: nf_conntrack_sip: get helper before allocating expectation
Date: Wed, 20 May 2026 18:24:37 +0200
Message-ID: <20260520162108.432047788@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Xiasong <lixiasong1@huawei.com>

commit eb6317739b1ea3ab28791e1f91b24781905fa815 upstream.

process_register_request() allocates an expectation and then checks
whether a conntrack helper is available. If helper lookup fails, the
function returns early and the allocated expectation is left behind.

Reorder the code to fetch and validate helper before calling
nf_ct_expect_alloc(). This keeps the logic simpler and removes the leak
path while preserving existing behavior.

Fixes: e14575fa7529 ("netfilter: nf_conntrack: use rcu accessors where needed")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_sip.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1367,6 +1367,10 @@ static int process_register_request(stru
 		goto store_cseq;
 	}
 
+	helper = rcu_dereference(nfct_help(ct)->helper);
+	if (!helper)
+		return NF_DROP;
+
 	exp = nf_ct_expect_alloc(ct);
 	if (!exp) {
 		nf_ct_helper_log(skb, ct, "cannot alloc expectation");
@@ -1377,10 +1381,6 @@ static int process_register_request(stru
 	if (sip_direct_signalling)
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 
-	helper = rcu_dereference(nfct_help(ct)->helper);
-	if (!helper)
-		return NF_DROP;
-
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;


