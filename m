Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2206F2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C997C433D2;
	Wed, 12 Apr 2023 08:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289627;
	bh=ShKdpR7u0c3tQjVyi6MWYk+RhLY7BMN7253481F0Bbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5OUoD+TNh8DNE16XmORQ3Uqri4FJ1THhQ1jTbIgxEHqKfati9sOf7yBiyuqSlBQv
	 KzLgq1A7eRjfdXnmPM5DfTqcliD9RFFijRrEitq/dyTvdNUw7HZG1ZF/r7EnzEU104
	 770H9YEfE30YCsRHXloeIGlb/ZoOjFQOF0DN+D0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.2 171/173] maple_tree: add smp_rmb() to dead node detection
Date: Wed, 12 Apr 2023 10:34:57 +0200
Message-Id: <20230412082845.089398450@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 0a2b18d948838e16912b3b627b504ab062b7d02a upstream.

Add an smp_rmb() before reading the parent pointer to ensure that anything
read from the node prior to the parent pointer hasn't been reordered ahead
of this check.

The is necessary for RCU mode.

Link: https://lkml.kernel.org/r/20230227173632.3292573-7-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -534,9 +534,11 @@ static inline struct maple_node *mte_par
  */
 static inline bool ma_dead_node(const struct maple_node *node)
 {
-	struct maple_node *parent = (void *)((unsigned long)
-					     node->parent & ~MAPLE_NODE_MASK);
+	struct maple_node *parent;
 
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
+	parent = (void *)((unsigned long) node->parent & ~MAPLE_NODE_MASK);
 	return (parent == node);
 }
 
@@ -551,6 +553,8 @@ static inline bool mte_dead_node(const s
 	struct maple_node *parent, *node;
 
 	node = mte_to_node(enode);
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
 	parent = mte_parent(enode);
 	return (parent == node);
 }


