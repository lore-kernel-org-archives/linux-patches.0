Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9B2E545
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F9BC433C8;
	Tue,  1 Aug 2023 09:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882693;
	bh=l6YLr1su2QZhLLZH1fzO5sng1hjkDi8xcJQpF7E/Vl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUGZEs0MnWTezG5JbmGj4lKzEq1WtBAeGyXbayjxB5wT8bW2Xpb6qVYTWjdmMfRo/
	 wppgJMvsFBeghj6wIYzIZy4sq9ILsF6RHenm7Sd/jD6JXqlWLFaUJBO+a3yHtyAWVn
	 Mu0XbqfzgqnDy4O4vuNpdQILK+VvsEhfVNJU3R9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 197/228] net: dsa: qca8k: fix search_and_insert wrong handling of new rule
Date: Tue,  1 Aug 2023 11:20:55 +0200
Message-ID: <20230801091929.988452547@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

commit 80248d4160894d7e40b04111bdbaa4ff93fc4bd7 upstream.

On inserting a mdb entry, fdb_search_and_insert is used to add a port to
the qca8k target entry in the FDB db.

A FDB entry can't be modified so it needs to be removed and insert again
with the new values.

To detect if an entry already exist, the SEARCH operation is used and we
check the aging of the entry. If the entry is not 0, the entry exist and
we proceed to delete it.

Current code have 2 main problem:
- The condition to check if the FDB entry exist is wrong and should be
  the opposite.
- When a FDB entry doesn't exist, aging was never actually set to the
  STATIC value resulting in allocating an invalid entry.

Fix both problem by adding aging support to the function, calling the
function with STATIC as aging by default and finally by correct the
condition to check if the entry actually exist.

Fixes: ba8f870dfa63 ("net: dsa: qca8k: add support for mdb_add/del")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/qca/qca8k-common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -281,7 +281,7 @@ void qca8k_fdb_flush(struct qca8k_priv *
 }
 
 static int qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
-				       const u8 *mac, u16 vid)
+				       const u8 *mac, u16 vid, u8 aging)
 {
 	struct qca8k_fdb fdb = { 0 };
 	int ret;
@@ -298,10 +298,12 @@ static int qca8k_fdb_search_and_insert(s
 		goto exit;
 
 	/* Rule exist. Delete first */
-	if (!fdb.aging) {
+	if (fdb.aging) {
 		ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
 		if (ret)
 			goto exit;
+	} else {
+		fdb.aging = aging;
 	}
 
 	/* Add port to fdb portmask */
@@ -847,7 +849,8 @@ int qca8k_port_mdb_add(struct dsa_switch
 	const u8 *addr = mdb->addr;
 	u16 vid = mdb->vid;
 
-	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid);
+	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid,
+					   QCA8K_ATU_STATUS_STATIC);
 }
 
 int qca8k_port_mdb_del(struct dsa_switch *ds, int port,


