Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8232939FC2;
	Fri, 24 Nov 2023 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqcRlt6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097BCC433C8;
	Fri, 24 Nov 2023 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849506;
	bh=NFnreIiakvkJvlTPmh0eNCU/cO8ZJyv5XEitglfJ+MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqcRlt6zlaWEsEMQVBQIhwoNOj+8E+h10oh5lzBWTQ+ftA49XaX3XL6VfknOMsURJ
	 V5PN4zmc7P0nAnP6ssx9LX1QSVxeyRidno8516wy6f+5nAZEgveKJCxsXIENJMeOR8
	 Ot5RxTzku2jl2D1JIy0rwNph/4XSohZBN6aiZ4hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/530] netfilter: nf_tables: bogus ENOENT when destroying element which does not exist
Date: Fri, 24 Nov 2023 17:46:14 +0000
Message-ID: <20231124172034.394432837@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

[ Upstream commit a7d5a955bfa854ac6b0c53aaf933394b4e6139e4 ]

destroy element command bogusly reports ENOENT in case a set element
does not exist. ENOENT errors are skipped, however, err is still set
and propagated to userspace.

 # nft destroy element ip raw BLACKLIST { 1.2.3.4 }
 Error: Could not process rule: No such file or directory
 destroy element ip raw BLACKLIST { 1.2.3.4 }
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3bf428a188ccf..3807c6c1181fd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7205,10 +7205,11 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
-			break;
+			return err;
 		}
 	}
-	return err;
+
+	return 0;
 }
 
 /*
-- 
2.42.0



