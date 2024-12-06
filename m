Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0321494D9;
	Fri,  6 Dec 2024 14:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496081; cv=none; b=jlZ5cy84qWVu3GHD70tGn7l1UZBmMwW1qQcOFsIgtgKrqHRSHY/9E7JSv7jXTbcKIYrfCtFjyeclZP8bpK93NuvVMNRcb+Q4bvl33DbEyMQBJRFIdgR9ND1XOlKfYqooEdT14XmFWqleDCQ5xuCQenf9/TBAbjn9KkXqWn0/fxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496081; c=relaxed/simple;
	bh=bR94FCzPQb/Ae7sOuhO2rZh3O+oQdRsjqJMdjpewVuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/lXr0VjmJA4JsB4b9UD7z8KBW4DQZrfTkOzijLMRMej7BWwyfOefavhsManSfJ+XTRmWooMdC2DlZZT4LWMrGqJSk5ArNuuRn9v9CX6QojE6/jciEs+bXMHI/+1/cIo++nFgznLGjm3LGY6kmPFzmoF2zpbS4y6dvOgF7yPQko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1Jbla8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1Jbla8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99555C4CED1;
	Fri,  6 Dec 2024 14:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496081;
	bh=bR94FCzPQb/Ae7sOuhO2rZh3O+oQdRsjqJMdjpewVuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1Jbla8DkPzlmZtnvAxpX/PJIU5KQvxneTWYD7/UnjtPKansfZDK+hTYEiiyOff1F
	 b3ZUvme4T2Yby4LFbgRk0uFrw+fvP4JQLGL8vemmzhD9DAxbCjRwzx1MPyzFWnAPvs
	 mrILvCe2U5eJR5EJDXWSQFNHzHQLwYXMQykbQ6bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 044/146] maple_tree: refine mas_store_root() on storing NULL
Date: Fri,  6 Dec 2024 15:36:15 +0100
Message-ID: <20241206143529.361504398@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit 0ea120b278ad7f7cfeeb606e150ad04b192df60b upstream.

Currently, when storing NULL on mas_store_root(), the behavior could be
improved.

Storing NULLs over the entire tree may result in a node being used to
store a single range.  Further stores of NULL may cause the node and
tree to be corrupt and cause incorrect behaviour.  Fixing the store to
the root null fixes the issue by ensuring that a range of 0 - ULONG_MAX
results in an empty tree.

Users of the tree may experience incorrect values returned if the tree
was expanded to store values, then overwritten by all NULLS, then
continued to store NULLs over the empty area.

For example possible cases are:

  * store NULL at any range result a new node
  * store NULL at range [m, n] where m > 0 to a single entry tree result
    a new node with range [m, n] set to NULL
  * store NULL at range [m, n] where m > 0 to an empty tree result
    consecutive NULL slot
  * it allows for multiple NULL entries by expanding root
    to store NULLs to an empty tree

This patch tries to improve in:

  * memory efficient by setting to empty tree instead of using a node
  * remove the possibility of consecutive NULL slot which will prohibit
    extended null in later operation

Link: https://lkml.kernel.org/r/20241031231627.14316-5-richard.weiyang@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3439,9 +3439,20 @@ static inline int mas_root_expand(struct
 	return slot;
 }
 
+/*
+ * mas_store_root() - Storing value into root.
+ * @mas: The maple state
+ * @entry: The entry to store.
+ *
+ * There is no root node now and we are storing a value into the root - this
+ * function either assigns the pointer or expands into a node.
+ */
 static inline void mas_store_root(struct ma_state *mas, void *entry)
 {
-	if (likely((mas->last != 0) || (mas->index != 0)))
+	if (!entry) {
+		if (!mas->index)
+			rcu_assign_pointer(mas->tree->ma_root, NULL);
+	} else if (likely((mas->last != 0) || (mas->index != 0)))
 		mas_root_expand(mas, entry);
 	else if (((unsigned long) (entry) & 3) == 2)
 		mas_root_expand(mas, entry);


