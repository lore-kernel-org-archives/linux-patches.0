Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567582E6103;
	Tue, 15 Jul 2025 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586923; cv=none; b=SIYX5OW/pKdBQlLIxlF9srR7scnPaeDWiHaFfDV/zluyobpQTV3Uh+HybIvQ5W1+4Bq/AfFmTiBIbPZzYRjqgRDoyIdfn6DjMlTw2AMmoJyPnVadEFxgZHDPCtHGN7KqHqUgpgIOriQghU7L8rjlBBXC0207X/FL4ygB/uviA54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586923; c=relaxed/simple;
	bh=+mv+U5m5AVfuyvzVoK/bdd7vIfVO0pBXZZWidzzznzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPlN2KXFKCa2c6BJgGY9VtQUfEFGeBM/NB4jsP6lvkwWKBeJqjiTX/EEKgwiTOS1azsKo6nbT9t3655PONBPj9qBZAmnj5IWArFxGdqNf+wm+dZYRk8ZCnHulppk+CfHk8MaszMQbD+IvKxH9wQihvtfJIU09ZbyiJWHnJCLQwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpedw/Qc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpedw/Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9105CC4CEE3;
	Tue, 15 Jul 2025 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586922;
	bh=+mv+U5m5AVfuyvzVoK/bdd7vIfVO0pBXZZWidzzznzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpedw/QcR8i8bjU1YhDoUZCRVRBdD/ODSPXAqOJCjOinGKSBoz0dC+frDbt2armj5
	 gzyKyDiitY8IepJtlm63VSRXkpNEQ0DjhXEXwTSSHwIAtA337qtkUsPTZDR6cMkcDr
	 JYLmFRINRmE1eZXBkQfVh5UOnrb2p9huEpZ+VhRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 100/192] maple_tree: fix mt_destroy_walk() on root leaf node
Date: Tue, 15 Jul 2025 15:13:15 +0200
Message-ID: <20250715130818.906098970@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5288,6 +5288,7 @@ static void mt_destroy_walk(struct maple
 	struct maple_enode *start;
 
 	if (mte_is_leaf(enode)) {
+		mte_set_node_dead(enode);
 		node->type = mte_node_type(enode);
 		goto free_leaf;
 	}


