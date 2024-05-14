Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BE653370;
	Tue, 14 May 2024 11:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685764; cv=none; b=g2rs4VWvKaldcAWs3IF82ZXFncB5ag5cAd6CbLbiRTcHmW1OF/WBAmwHsqz1sCzpdMXpZuPgFAW1G13EdgrrxDDAErwKU9ghifvTVJfiu8luhRcdmEVfjfyplFYOoa3YA6jN/x5bbvKDwxiWvibvxD6VNCwminbCe9auhI/ljL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685764; c=relaxed/simple;
	bh=xnga8GuKmJbHQfqHIjPoumh5MewSleWbqsdijOCZl1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plA5SoHrexAUA/fcka4/zkFMxKxHBFVIR6/8/rzNtXZ646YBrqP020zrs3lTTrvaj84Nvyz/XdPVzn5+1FeEY9qdIhGJFR7LDFhvnrY6BcRYVyBTqk02dG684GEUIy+ruC1nmRk/hU68o9it84eIm3PDPiJNqsm87bqnsMK8H/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECpHCahn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECpHCahn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C151C2BD10;
	Tue, 14 May 2024 11:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685763;
	bh=xnga8GuKmJbHQfqHIjPoumh5MewSleWbqsdijOCZl1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECpHCahnCZgVJ2xupwuj8s1RJ7qBonUNo6JkRoWnj4c7Ucjr1jWDI1aQmLv7e8nLH
	 SeDPeLkg9loiU1MlSXwAR/qq+yF4lOAOad8oRFteBQJTPP58480rBnoAMmjVokKAq9
	 XWy/ezP9CZnZzzYTxHYLF2KwtNQNj5FI+Rn6vsOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Marius Fleischer <fleischermarius@gmail.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 243/301] maple_tree: fix mas_empty_area_rev() null pointer dereference
Date: Tue, 14 May 2024 12:18:34 +0200
Message-ID: <20240514101041.430145574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 955a923d2809803980ff574270f81510112be9cf upstream.

Currently the code calls mas_start() followed by mas_data_end() if the
maple state is MA_START, but mas_start() may return with the maple state
node == NULL.  This will lead to a null pointer dereference when checking
information in the NULL node, which is done in mas_data_end().

Avoid setting the offset if there is no node by waiting until after the
maple state is checked for an empty or single entry state.

A user could trigger the events to cause a kernel oops by unmapping all
vmas to produce an empty maple tree, then mapping a vma that would cause
the scenario described above.

Link: https://lkml.kernel.org/r/20240422203349.2418465-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Marius Fleischer <fleischermarius@gmail.com>
Closes: https://lore.kernel.org/lkml/CAJg=8jyuSxDL6XvqEXY_66M20psRK2J53oBTP+fjV5xpW2-R6w@mail.gmail.com/
Link: https://lore.kernel.org/lkml/CAJg=8jyuSxDL6XvqEXY_66M20psRK2J53oBTP+fjV5xpW2-R6w@mail.gmail.com/
Tested-by: Marius Fleischer <fleischermarius@gmail.com>
Tested-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5085,18 +5085,18 @@ int mas_empty_area_rev(struct ma_state *
 	if (size == 0 || max - min < size - 1)
 		return -EINVAL;
 
-	if (mas_is_start(mas)) {
+	if (mas_is_start(mas))
 		mas_start(mas);
-		mas->offset = mas_data_end(mas);
-	} else if (mas->offset >= 2) {
-		mas->offset -= 2;
-	} else if (!mas_rewind_node(mas)) {
+	else if ((mas->offset < 2) && (!mas_rewind_node(mas)))
 		return -EBUSY;
-	}
 
-	/* Empty set. */
-	if (mas_is_none(mas) || mas_is_ptr(mas))
+	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		return mas_sparse_area(mas, min, max, size, false);
+	else if (mas->offset >= 2)
+		mas->offset -= 2;
+	else
+		mas->offset = mas_data_end(mas);
+
 
 	/* The start of the window can only be within these values. */
 	mas->index = min;


