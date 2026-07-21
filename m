Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312E53DDB03;
	Tue, 21 Jul 2026 22:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674193; cv=none; b=DW9rNTwMM9hUnkEzubCvC8L0d5P8blDJMlgSwNTLK60r0GFMmvTkW14sd7G77cMjt/Il7OwZ7QPsj8xas7Vyql4DOI2m5ZcpbJYKEULnhX+pBdh2ElS3cJArGgOq6eVG2Mfy0tJfhkQTefqat2Gmy+HLmpu4Oh/JGAPEnSO/OLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674193; c=relaxed/simple;
	bh=IfP7vmlYqi1juFtWCc/uHD59MRvcjHMb7jYFm2sd7lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsR/EK8VZHz6rD3Sae9SM8bDk1yPUCXwepTf8pnKKSTvBEpvciPpJg5yt0+XZ7kfX15ufsi8PGhI664kndbnksbAnST0ABCQJH2RlsVaFdmL62TMmuBsBWdNMO2/h5+NTZoyar0B7DsJwC4tfVzQIvGlmMgKDe9ZASxXeNzyuzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sB9FGsR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sB9FGsR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689B51F000E9;
	Tue, 21 Jul 2026 22:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674191;
	bh=Hr+ZdGplIuu6Hg6DTkVzUbL+vrSRrRgAp3DzAS3d7DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sB9FGsR7mPvaLeqUOHlFoY46s/8pVg1Zxn0V8B46VRUcsqVdKb1c+u1nWJcKV20r+
	 9lx+tLKEvx2/R3XMlkzbajLvx/GsJU6bCehq65VWDbWlgh0K1ndN5QSh+NFKChjGlw
	 8kiPMWwDE83O0cEmc+jYJZUFYxR5UGNsPUi6o5ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 446/699] netfilter: xt_cluster: reject template conntracks in hash match
Date: Tue, 21 Jul 2026 17:23:25 +0200
Message-ID: <20260721152405.761859042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wyatt Feng <bronzed_45_vested@icloud.com>

commit 5feba91006ec92da57acc1cc2e34df623b98541e upstream.

xt_cluster_mt() treats any non-NULL nf_ct_get() result as a fully
initialized conntrack and passes it to xt_cluster_hash().

This causes a state confusion bug when the raw table CT target attaches
a template conntrack to skb->_nfct before normal conntrack processing.
Templates carry IPS_TEMPLATE status but do not have a valid tuple for
hashing yet, so xt_cluster_hash() can hit its WARN_ON() path on the
zeroed l3num field.

Reject template conntracks before hashing them. This matches existing
netfilter handling for template objects and avoids hashing incomplete
conntrack state.

Fixes: 0269ea493734 ("netfilter: xtables: add cluster match")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/xt_cluster.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -107,7 +107,7 @@ xt_cluster_mt(const struct sk_buff *skb,
 	}
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL)
+	if (!ct || nf_ct_is_template(ct))
 		return false;
 
 	if (ct->master)


