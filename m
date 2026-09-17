Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7F04A207F;
	Thu, 17 Sep 2026 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668082; cv=none; b=sOCld3HyKb0epa1ik2hcbj1aBoch23MeVFbPYiTkRyMyXpWfmz5JcW4ytL+ysIySL5MkZsZLjoADlvpbh0sEzKDBr4PoyWrVbHF9JOBbl9oJOwiAmk/OfebYzGzI+vItw6WChwfa32wBrIP20awwQi9n44s4y4j6ibZxXeqcfD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668082; c=relaxed/simple;
	bh=udPg7d8BmU0zT3VjwWAEOiybMdQVNlpFveE9T1TzgXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SBLWGjEndy4SZAaeV0g6psVjWh8Ti2PjG+Z2RJTtE1gmmjz7MW2Kq6VEJ2ORi48cb/k+kfZjoOUk/YLVN9oN8Fmi2N5G4F+ijgSTsoOLTvOHUGCwlc2NQhcUWZWZ7u0jh8wsX/g8fAIrn+Jws7UmGvumF1u9m72dJ7mywzzLqfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdHSKV8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdHSKV8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F641F000FF;
	Thu, 17 Sep 2026 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668081;
	bh=QTX61FSdrP2H4+KKDIZhImJgtaByMy/cYHpmQ55GwC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdHSKV8hNN2S6jCKUK85wf9Ly/mBSwxiyRIb5agd/BdjYMvhi9ArIlDdZJFFUdws3
	 NqZm+SmAbctGQ4NXe82qZmZAKF5e3k5natvL4AVk+Etf1rhn/4I35gb3sxGmGFWn3I
	 6YquVGKfMMECRwdr807t1l1N3fNHfcnQSYYwZ0aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0307/1102] apparmor: propagate -ENOMEM correctly in unpack_table
Date: Thu, 17 Sep 2026 16:04:10 +0100
Message-ID: <20260917151547.329003389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 1c8a839442823ce5c627d645730d8c61d828aafa ]

Currently, if the `kvzalloc` in `unpack_table` fails, it returns NULL.
This is masked by `aa_dfa_unpack` which interprets NULL as a -EPROTO,
leading to confusing error messages in `apparmor_parser` [1].

The fixed behavior correctly propagates -ENOMEM on allocation failure.

Link: https://gitlab.com/apparmor/apparmor/-/issues/592
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/match.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 4e3ada0e7461f..b43aaad86b249 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -27,13 +27,13 @@
  * @blob: data to unpack (NOT NULL)
  * @bsize: size of blob
  *
- * Returns: pointer to table else NULL on failure
+ * Returns: pointer to table else ERR_PTR on failure
  *
  * NOTE: must be freed by kvfree (not kfree)
  */
 static struct table_header *unpack_table(char *blob, size_t bsize)
 {
-	struct table_header *table = NULL;
+	struct table_header *table = ERR_PTR(-EPROTO);
 	struct table_header th;
 	size_t tsize;
 
@@ -74,20 +74,21 @@ static struct table_header *unpack_table(char *blob, size_t bsize)
 		else if (th.td_flags == YYTD_DATA32)
 			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
 				     u32, __be32, get_unaligned_be32);
-		else
-			goto fail;
+		else {
+			kvfree(table);
+			table = ERR_PTR(-EPROTO);
+			goto out;
+		}
 		/* if table was vmalloced make sure the page tables are synced
 		 * before it is used, as it goes live to all cpus.
 		 */
 		if (is_vmalloc_addr(table))
 			vm_unmap_aliases();
-	}
+	} else
+		table = ERR_PTR(-ENOMEM);
 
 out:
 	return table;
-fail:
-	kvfree(table);
-	return NULL;
 }
 
 /**
@@ -323,8 +324,11 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 
 	while (size > 0) {
 		table = unpack_table(data, size);
-		if (!table)
+		if (IS_ERR(table)) {
+			error = PTR_ERR(table);
+			table = NULL;
 			goto fail;
+		}
 
 		switch (table->td_id) {
 		case YYTD_ID_ACCEPT:
-- 
2.53.0



