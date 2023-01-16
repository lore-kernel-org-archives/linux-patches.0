Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5028546B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C991AC433D2;
	Mon, 16 Jan 2023 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885688;
	bh=09RjYj8WVkNF8C+5Po1Uw03h90Lrw1lbgeEp+14AyCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNi30DqNajoUdo3QWIIZfW6+H4bexUarsnhMo4nT/Bg+jD+2EHZrwg91og4W1iGob
	 xd6vucp70JRhHbX60Yan3g8mYIfDFgfIQOto5CGZWCL1uw5wouakIqDhng/9p23FTc
	 kbW80NtmO2WEXzv+7pmwgbYbyMppdQS2yGtWzPvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@mellanox.com>,
	Jiri Pirko <jiri@mellanox.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/658] bonding: Export skip slave logic to function
Date: Mon, 16 Jan 2023 16:43:54 +0100
Message-Id: <20230116154916.131290654@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 119d48fd4298594beccf4f2ecd00627826ce2646 ]

As a preparation for following change that add array of
all slaves, extract code that skip slave to function.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Stable-dep-of: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 47 ++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 246bcbd650b4..0e797730bab3 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4040,6 +4040,29 @@ static void bond_slave_arr_handler(struct work_struct *work)
 	bond_slave_arr_work_rearm(bond, 1);
 }
 
+static void bond_skip_slave(struct bond_up_slave *slaves,
+			    struct slave *skipslave)
+{
+	int idx;
+
+	/* Rare situation where caller has asked to skip a specific
+	 * slave but allocation failed (most likely!). BTW this is
+	 * only possible when the call is initiated from
+	 * __bond_release_one(). In this situation; overwrite the
+	 * skipslave entry in the array with the last entry from the
+	 * array to avoid a situation where the xmit path may choose
+	 * this to-be-skipped slave to send a packet out.
+	 */
+	for (idx = 0; slaves && idx < slaves->count; idx++) {
+		if (skipslave == slaves->arr[idx]) {
+			slaves->arr[idx] =
+				slaves->arr[slaves->count - 1];
+			slaves->count--;
+			break;
+		}
+	}
+}
+
 /* Build the usable slaves array in control path for modes that use xmit-hash
  * to determine the slave interface -
  * (a) BOND_MODE_8023AD
@@ -4109,27 +4132,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	if (old_arr)
 		kfree_rcu(old_arr, rcu);
 out:
-	if (ret != 0 && skipslave) {
-		int idx;
-
-		/* Rare situation where caller has asked to skip a specific
-		 * slave but allocation failed (most likely!). BTW this is
-		 * only possible when the call is initiated from
-		 * __bond_release_one(). In this situation; overwrite the
-		 * skipslave entry in the array with the last entry from the
-		 * array to avoid a situation where the xmit path may choose
-		 * this to-be-skipped slave to send a packet out.
-		 */
-		old_arr = rtnl_dereference(bond->slave_arr);
-		for (idx = 0; old_arr != NULL && idx < old_arr->count; idx++) {
-			if (skipslave == old_arr->arr[idx]) {
-				old_arr->arr[idx] =
-				    old_arr->arr[old_arr->count-1];
-				old_arr->count--;
-				break;
-			}
-		}
-	}
+	if (ret != 0 && skipslave)
+		bond_skip_slave(rtnl_dereference(bond->slave_arr), skipslave);
+
 	return ret;
 }
 
-- 
2.35.1



