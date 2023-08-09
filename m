Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CC2174EE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF05EC433C7;
	Wed,  9 Aug 2023 10:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578332;
	bh=6Opm0v4QTJfA2PYL/Yq+G06NjkHBnNxXPsiKFR9+9AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpmH8xPdfxXh3B1I69ipMZgNp8ygCYdhmD6AtMmvtXmeYshHGC+gUdGz1IjXhpKLH
	 agoHqE+jJznt0MyP9YDDWM/LdJJXjlVegl9MeCp1DJ4u/XRzLvaf+S7PoavitrtUrB
	 eX2PCy2LTjIbVKLPccmJjlY2KQWEvSyu9+HTuGKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Alex Elder <elder@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 004/127] net: ipa: only reset hashed tables when supported
Date: Wed,  9 Aug 2023 12:39:51 +0200
Message-ID: <20230809103636.771672308@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Elder <elder@linaro.org>

commit e11ec2b868af2b351c6c1e2e50eb711cc5423a10 upstream.

Last year, the code that manages GSI channel transactions switched
from using spinlock-protected linked lists to using indexes into the
ring buffer used for a channel.  Recently, Google reported seeing
transaction reference count underflows occasionally during shutdown.

Doug Anderson found a way to reproduce the issue reliably, and
bisected the issue to the commit that eliminated the linked lists
and the lock.  The root cause was ultimately determined to be
related to unused transactions being committed as part of the modem
shutdown cleanup activity.  Unused transactions are not normally
expected (except in error cases).

The modem uses some ranges of IPA-resident memory, and whenever it
shuts down we zero those ranges.  In ipa_filter_reset_table() a
transaction is allocated to zero modem filter table entries.  If
hashing is not supported, hashed table memory should not be zeroed.
But currently nothing prevents that, and the result is an unused
transaction.  Something similar occurs when we zero routing table
entries for the modem.

By preventing any attempt to clear hashed tables when hashing is not
supported, the reference count underflow is avoided in this case.

Note that there likely remains an issue with properly freeing unused
transactions (if they occur due to errors).  This patch addresses
only the underflows that Google originally reported.

Cc: <stable@vger.kernel.org> # 6.1.x
Fixes: d338ae28d8a8 ("net: ipa: kill all other transaction lists")
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20230724224055.1688854-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_table.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -311,16 +311,15 @@ static int ipa_filter_reset(struct ipa *
 	if (ret)
 		return ret;
 
-	ret = ipa_filter_reset_table(ipa, IPA_MEM_V4_FILTER_HASHED, modem);
-	if (ret)
+	ret = ipa_filter_reset_table(ipa, IPA_MEM_V6_FILTER, modem);
+	if (ret || !ipa_table_hash_support(ipa))
 		return ret;
 
-	ret = ipa_filter_reset_table(ipa, IPA_MEM_V6_FILTER, modem);
+	ret = ipa_filter_reset_table(ipa, IPA_MEM_V4_FILTER_HASHED, modem);
 	if (ret)
 		return ret;
-	ret = ipa_filter_reset_table(ipa, IPA_MEM_V6_FILTER_HASHED, modem);
 
-	return ret;
+	return ipa_filter_reset_table(ipa, IPA_MEM_V6_FILTER_HASHED, modem);
 }
 
 /* The AP routes and modem routes are each contiguous within the
@@ -329,11 +328,12 @@ static int ipa_filter_reset(struct ipa *
  * */
 static int ipa_route_reset(struct ipa *ipa, bool modem)
 {
+	bool hash_support = ipa_table_hash_support(ipa);
 	struct gsi_trans *trans;
 	u16 first;
 	u16 count;
 
-	trans = ipa_cmd_trans_alloc(ipa, 4);
+	trans = ipa_cmd_trans_alloc(ipa, hash_support ? 4 : 2);
 	if (!trans) {
 		dev_err(&ipa->pdev->dev,
 			"no transaction for %s route reset\n",
@@ -350,12 +350,14 @@ static int ipa_route_reset(struct ipa *i
 	}
 
 	ipa_table_reset_add(trans, false, first, count, IPA_MEM_V4_ROUTE);
-	ipa_table_reset_add(trans, false, first, count,
-			    IPA_MEM_V4_ROUTE_HASHED);
-
 	ipa_table_reset_add(trans, false, first, count, IPA_MEM_V6_ROUTE);
-	ipa_table_reset_add(trans, false, first, count,
-			    IPA_MEM_V6_ROUTE_HASHED);
+
+	if (hash_support) {
+		ipa_table_reset_add(trans, false, first, count,
+				    IPA_MEM_V4_ROUTE_HASHED);
+		ipa_table_reset_add(trans, false, first, count,
+				    IPA_MEM_V6_ROUTE_HASHED);
+	}
 
 	gsi_trans_commit_wait(trans);
 


