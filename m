Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942A71D696;
	Mon, 11 Dec 2023 18:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMNm/NcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40EAC433C7;
	Mon, 11 Dec 2023 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320107;
	bh=AjsxVRU2HKRpzL3OJcXR7WphM/5gx86Q96sN9KHNy0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMNm/NcZ09HcFljYy9Mk9EekRk+T4ppMKXqOi3BjQrXiP+bTGgOYrIHjz3wqZXos2
	 09GOyahHHoZIzzH1sxqLTXbhRXOJDlasC2gwh9LOZHZQtQcgyVq7MMJSBQPmkBY81g
	 TlHDa4Zyb5AP9dPEtbp7KUkc44cv0MV/zZas1914=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 87/97] netfilter: nft_set_pipapo: skip inactive elements during set walk
Date: Mon, 11 Dec 2023 19:22:30 +0100
Message-ID: <20231211182023.568514756@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 317eb9685095678f2c9f5a8189de698c5354316a upstream.

Otherwise set elements can be deactivated twice which will cause a crash.

Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2028,6 +2028,9 @@ static void nft_pipapo_walk(const struct
 
 		e = f->mt[r].e;
 
+		if (!nft_set_elem_active(&e->ext, iter->genmask))
+			goto cont;
+
 		elem.priv = e;
 
 		iter->err = iter->fn(ctx, set, iter, &elem);


