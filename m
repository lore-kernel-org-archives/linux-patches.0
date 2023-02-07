Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285263212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8278DC433EF;
	Tue,  7 Feb 2023 13:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775523;
	bh=Gr9uIgVDAHyauhn8f87dNgCiKUiY0/qJ3erdheKXwwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pcc7AZAuING5gW8QazX69zZ62pPZWoMqjvyJZBdzpqAfh7RqU3bQG1N2WLfBRSrDl
	 OJYyNsL/hcwkF24Bq/k1e03+oPZAGA6vIz2TwFqG9+fMLHcupPw3exQODuGaW1mceg
	 nZlWVEcN8mWqzcqVvkc281QgSAqSv70OPivY+GVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalia Petrova <n.petrova@fintech.ru>,
	Simon Horman <simon.horman@corigine.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 068/120] net: qrtr: free memory on error path in radix_tree_insert()
Date: Tue,  7 Feb 2023 13:57:19 +0100
Message-Id: <20230207125621.650205883@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Natalia Petrova <n.petrova@fintech.ru>

commit 29de68c2b32ce58d64dea496d281e25ad0f551bd upstream.

Function radix_tree_insert() returns errors if the node hasn't
been initialized and added to the tree.

"kfree(node)" and return value "NULL" of node_get() help
to avoid using unclear node in other calls.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Cc: <stable@vger.kernel.org> # 5.7
Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20230125134831.8090-1-n.petrova@fintech.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -83,7 +83,10 @@ static struct qrtr_node *node_get(unsign
 
 	node->id = node_id;
 
-	radix_tree_insert(&nodes, node_id, node);
+	if (radix_tree_insert(&nodes, node_id, node)) {
+		kfree(node);
+		return NULL;
+	}
 
 	return node;
 }


