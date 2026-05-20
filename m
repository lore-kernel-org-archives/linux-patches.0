Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EADC3CB2F8;
	Wed, 20 May 2026 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302938; cv=none; b=oYyK31JrMFpxl/h62x7D5Ke2oDi93BZvF251t99w6Pme87kaOepRdemh58YroNOS8WlxULaVPeck1YQheV7xYwKSC+pmDnHiS51Jo19WBq1aB4hS88Fuy48zJjTgAnrEk7jfnii/D3w5xKY6+d88NPsCXFGHbMKIRFqBYd6981I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302938; c=relaxed/simple;
	bh=eisxQHVxLyUwkbRS3ZVdi9Pwty7RaPp8D4o9rNO6gHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDrBaYCJDUIFbkQkjNCtrIFqo8EaXdY9U6o4Jomd4PKVGjBfq40svuHQ7/InYrDuhizfsK8mf/21UH9KIHqt9dfm+2G9zKhNnLbBSMUodQYWEYyevy9VDVRzqAgbe9v8FhUraHb3+HP5JfiHNDuLliFECdGOT6JXCZsWSEmSIg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3D3dfuo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3D3dfuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94E21F00893;
	Wed, 20 May 2026 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302935;
	bh=wj2GFe8n3V+EV2ZSydgc6lHoPUBoREVKyfALr5zHero=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3D3dfuo3J7wUt9yBANthr7z6TZVfnYfDK/hYHYpLIqXRj2wWSouD3zxhaVfQOkOu
	 DNvbz5ZYSqX1Oy4yB9u9AkBISnU4hmEM8U4Zuv05js79pMINxxF/Lxt1O6c7NXmf7a
	 CM5H70gO35qlWDwnkvrENq6mJUTkkL3peT+Jp2Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 456/508] netfilter: nft_ct: fix missing expect put in obj eval
Date: Wed, 20 May 2026 18:24:39 +0200
Message-ID: <20260520162108.475904064@linuxfoundation.org>
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

commit 19f94b6fee75b3ef7fbc06f3745b9a771a8a19a4 upstream.

nft_ct_expect_obj_eval() allocates an expectation and may call
nf_ct_expect_related(), but never drops its local reference.

Add nf_ct_expect_put(exp) before return to balance allocation.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_ct.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1363,6 +1363,8 @@ static void nft_ct_expect_obj_eval(struc
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
+
+	nf_ct_expect_put(exp);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {


