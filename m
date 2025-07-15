Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B892472AE;
	Tue, 15 Jul 2025 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585643; cv=none; b=dMyacPTrDC7nEQN3M4f9fH/bubfQMNOvA4ZSywOY1oFRRpUQ0HYO8xmKDt/hv257/C48hLO3rvUN6iOfAY7/bobplazhx1lk22Rvhyv3CCabd0w7/Bq7pmiAjq2K9WO/T5hHXKSmzjZ8EM7EeCFSazmknvW+9H/5mjIzbMIWdXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585643; c=relaxed/simple;
	bh=5nbe3jQ/JAfpCwothgCGTCSEMVCwq34PoJt5XtjGXCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti0z3FCu+4oJU30WE/lrAzqkaBN3LyaLK3KNZfLmlGn6QIC7NY7PUBZT7ARFkpWBJVx7cFXavfikRnUyLwaR5bURwxTdiDV8tsCjGV4Wnn/C7WNRrYEwBIejPvn4NuJlaL1KOeEOmfN8sTzbHw7lPZvcbEB8d4pyhrMKdLM0pCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEkLZ2jR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEkLZ2jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA4CC4CEE3;
	Tue, 15 Jul 2025 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585643;
	bh=5nbe3jQ/JAfpCwothgCGTCSEMVCwq34PoJt5XtjGXCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEkLZ2jRXzl9PPerhap1bI7eJzBczKCWwhHzyj7hirUi3TAboMkQz+WOovp2ZH7HV
	 PDidXzIvmjlRsYodg4YIhJCwjn00V8tYoNbidbjLzN6fm3G1nx8ulsvO/0mXcIZ11N
	 XARJpDknbeZKD9OFKEIp4J2HKQlEtUPz/q6QabR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 087/163] maple_tree: fix mt_destroy_walk() on root leaf node
Date: Tue, 15 Jul 2025 15:12:35 +0200
Message-ID: <20250715130812.216350824@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit ea9b77f98d94c4d5c1bd1ac1db078f78b40e8bf5 upstream.

On destroy, we should set each node dead.  But current code miss this when
the maple tree has only the root node.

The reason is mt_destroy_walk() leverage mte_destroy_descend() to set node
dead, but this is skipped since the only root node is a leaf.

Fixes this by setting the node dead if it is a leaf.

Link: https://lore.kernel.org/all/20250407231354.11771-1-richard.weiyang@gmail.com/
Link: https://lkml.kernel.org/r/20250624191841.64682-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5335,6 +5335,7 @@ static void mt_destroy_walk(struct maple
 	struct maple_enode *start;
 
 	if (mte_is_leaf(enode)) {
+		mte_set_node_dead(enode);
 		node->type = mte_node_type(enode);
 		goto free_leaf;
 	}


