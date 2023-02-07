Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B193212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71841C4339B;
	Tue,  7 Feb 2023 13:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774877;
	bh=w5JQsmd+idHfWEj3+FjUusmRJWIvJcB20o2WkD4QGys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+/kxqbAqmHqb5ZLCGGD1+pnlmUEkbvL+TaXXvwBOnCrwqprYCgKcBNRO8DdAJvIW
	 As8N4/I2fctKQf7jlBT9JdcQVVGK3Je1APEhyxrAUzeRYnVvDiUqRefeh0JqzpgpUM
	 xVkPgZesXxQ7vhB563aI5Aap4+nkjE1hcPFkL014=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/208] net/tls: tls_is_tx_ready() checked list_entry
Date: Tue,  7 Feb 2023 13:55:18 +0100
Message-Id: <20230207125637.203075920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit ffe2a22562444720b05bdfeb999c03e810d84cbb ]

tls_is_tx_ready() checks that list_first_entry() does not return NULL.
This condition can never happen. For empty lists, list_first_entry()
returns the list_entry() of the head, which is a type confusion.
Use list_first_entry_or_null() which returns NULL in case of empty
lists.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230128-list-entry-null-check-tls-v1-1-525bbfe6f0d0@diag.uniroma1.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9ed978634125..a83d2b4275fa 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2427,7 +2427,7 @@ static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)
 {
 	struct tls_rec *rec;
 
-	rec = list_first_entry(&ctx->tx_list, struct tls_rec, list);
+	rec = list_first_entry_or_null(&ctx->tx_list, struct tls_rec, list);
 	if (!rec)
 		return false;
 
-- 
2.39.0



