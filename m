Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742F41C07C2;
	Tue, 15 Oct 2024 12:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997150; cv=none; b=YXZdSEpQx0fvn/1DoGhj+SU33YAPb9vro+rsIgnPqdT0WuEJuDs7rYKkBRxWLXL0HJCOaupMLPBtr6Kkmd7yg4PBTbw4X/5ZKhh9QIQDJcngf6H3cDCF2ndyxJFbdy6vNkLv6UGxNznMweDfmZF8SrAtyMRr4/4qWYWjmZZmwCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997150; c=relaxed/simple;
	bh=Ft63Cp8ZRZ8i/wtG2TgXLuWYuZUMiw46OUDNTHHJXaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL0f+MsjT8vewa4fMo1FtSPyvB3XgfMMTD/GwiwhvrB8v9GjfXneYzo5eEdr/sX2bZucUGFJckMzCjBaVjd/I3ZQu077X65Zg5UL4c08fEjYoLwStkHXwxmYfICBR2YjzC7AGFf4p+rTtlPEjYB1J2Xqeb7USfPuthId13I+CiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxAaRc6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxAaRc6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA13C4CECF;
	Tue, 15 Oct 2024 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997150;
	bh=Ft63Cp8ZRZ8i/wtG2TgXLuWYuZUMiw46OUDNTHHJXaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxAaRc6Cgjr3JtpyohNUrLR3O5qunrxfSJS0PSR9iqutgEOEg5SKAjOCYmNdGuyPA
	 Jw+w42Cu+NZvVFErj9EeItVdX8ZrKWmZJpkMIdY0Si5eXiSMkWNNgz3ertSCFYWZAM
	 FHL7onEbmNkDbWcunOXPD8w6FrT81WH0sD9NJ1PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/518] netfilter: nf_tables: reject expiration higher than timeout
Date: Tue, 15 Oct 2024 14:39:33 +0200
Message-ID: <20241015123919.669120035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c0f38a8c60174368aed1d0f9965d733195f15033 ]

Report ERANGE to userspace if user specifies an expiration larger than
the timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a788f3e8fe2bb..9e2695bedd2ce 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5635,6 +5635,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					    &expiration);
 		if (err)
 			return err;
+
+		if (expiration > timeout)
+			return -ERANGE;
 	}
 
 	if (nla[NFTA_SET_ELEM_EXPR] != NULL) {
-- 
2.43.0



