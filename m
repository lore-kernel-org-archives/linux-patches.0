Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6CD1D0B86;
	Wed,  2 Oct 2024 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879192; cv=none; b=AcDUmTca2lAEV7W1f27Oj7SxBtszqHw1dbfNFZuqNudbifmK9qNZYhGcmgS8FwLDNGw4i7UoVa+uWlifS4vwtsUb+HN7ZscLzrl+VBT5mEGR7AOLgkr43ZRj86xWPsNed4B73WT0mjTJ9RWFZglbq7D0oFo0dWUYtPzcq03LzFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879192; c=relaxed/simple;
	bh=HBXHP3G0L+eHgsu8FvQtSCYu6SIpJkTetFK1YrIdPg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4aV91DkTPzQpnP54AfxYpymKo63aVBmjhJ4w44XqOLAvuTAPEEs0nNP9fhycD+Dr8aydHinoLm2RloFZTYb//CpWQf/3Uhz0PoiCBoDCUHSXeSx6mqbPLGDAbGrhb0SN35yqMv1SgrnIOiulrO+o+Q5hQvOw0UGxqp6L4f+Xkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ss0rS0ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ss0rS0ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C42C4CEC2;
	Wed,  2 Oct 2024 14:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879191;
	bh=HBXHP3G0L+eHgsu8FvQtSCYu6SIpJkTetFK1YrIdPg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ss0rS0caQu/Gpdc6Ngo2wC1lCGxm4EHmyFESRXwjl1A+kG/IkXdKdT0tU/TNIy46E
	 ugNkl54FeUxk+JueQDRVhjV4avHhZpPpAit5u76fq/1sU0Mhv+qQBL7uyJTer8GS7k
	 mfgSoLRB5uTJYi35nvZSnUSRy69jwbu4ULcWC2IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/538] netfilter: nf_tables: reject expiration higher than timeout
Date: Wed,  2 Oct 2024 14:54:34 +0200
Message-ID: <20241002125753.411925808@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8bb61fb62a2b6..842c9ac6e2341 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6705,6 +6705,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					    &expiration);
 		if (err)
 			return err;
+
+		if (expiration > timeout)
+			return -ERANGE;
 	}
 
 	if (nla[NFTA_SET_ELEM_EXPR]) {
-- 
2.43.0



