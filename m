Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054359;
	b=lkRGluEl5D4mXBsvyCmp7jwszA3CloO2oWzF1aHHPZ5pWdLGhXjoNQvjerne8krbGi97
	 snAN+7b6STfrS3O38Lmsl9lTOhcyGNGVl6w48TzjCPrWtutge99T/0pCWUVmfCRRgiRkR
	 rkw0oGpltMcAA4ZtKKmSfZet4vnbikpaDiNxOjOy2Rx9ndocYeCRz732cBE2Ejd1BVg1P
	 /r3PQywln2Or9mlNImeT0mO85JjogUqXFRq0HkPqrNYncLubs4qkmNmK5dqhPw43u1Oig
	 3GRozQJbqKWRlc4spfdx/Y1B+ie7B0VB82FTdO+CVDpJSwcm03DTrae70M0r8iXPrHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mu4jFI56ET+B6XY3BivOz3Q5XC7AvtuYZttrESSeUg4=;
	b=hP1CP3i8w2tv/PNfD4av33pYFMg5kx/5zeFeWly8L0OLWC8dEi39qTqYKEhsXKYFXZde
	 gGN/tGj7akJiDR9XDJEH1Eu+gEGZoBUkY4HbOaUgwBEwUSYlGhOy99f4k+86b4ynrt9l3
	 j2uRsEwE6xHtGRzyHNnKYhho/dalJqAB/ODSHcu6D1KTckW1+FT3vOR1ZQLO4b3K9OyWY
	 /0UffoX6pVFzi2eNrkMgbCGDmPSq/YS6F29KC44uMNyl+XXkRGq8w+WTJINC5JEjSJlBi
	 ULRdVl3OZ1YghtimC+2kVXtYeq7EPswLpMSwtf2XlF6eana4nATpJGjD4zEb0x9AsxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JIL6fomS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72075606A320;
	Thu, 19 Nov 2026 02:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JIL6fomS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5ED1F000C4;
	Thu, 19 Nov 2026 02:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054358;
	bh=mu4jFI56ET+B6XY3BivOz3Q5XC7AvtuYZttrESSeUg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIL6fomSlQbbvuMDv3FE5nZqbwX1VwvOoktij+mjKg9PJpCwiHh8bfc9fLrIuRRA/
	 PSVBw1lYNo4pOR0hpZ70h7PntSuD6NrCu1Bcpw4JzLvfNeumPRTNCrqg4Zxvnmo0vm
	 huG6wzYYePvgGBQLvp8RaHtmqykXCDvrfOk35WK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1205/2214] assoc_array: fill the segment cache in one place
Date: Wed, 18 Nov 2026 15:48:01 +0100
Message-ID: <20261118150100.057181123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1159eaf9acb3de1417fb86b382b5e41b46eb17a4 ]

The loop that records the segment of each leaf in a full node is written
out twice in assoc_array_insert_into_terminal_node(): for the node at
its own level, and again at the far end of a shortcut that replaces it.
Make it assoc_array_fill_segment_cache().

The second copy did not look for metadata pointers, because that path is
only taken for a node holding nothing but leaves, so the function finds
none there.  The new key's segment is still set by each caller, from the
walk the first time and from the key the second.

No functional change.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Stable-dep-of: 48691075b0ad ("assoc_array: don't chain a new shortcut onto an existing one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 56 +++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index a9295e8ca5d4d..600b2d85bccb6 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -515,6 +515,38 @@ static bool assoc_array_insert_in_node(struct assoc_array_edit *edit,
 	return false;
 }
 
+/*
+ * Fill in the edit script's segment cache for a full node: the segment at
+ * this level of each leaf's index key, or 0xff for a metadata pointer.
+ * The new key's segment, in the last entry, is left to the caller.  Returns
+ * true if there are any metadata pointers.
+ */
+static bool assoc_array_fill_segment_cache(struct assoc_array_edit *edit,
+					   const struct assoc_array_ops *ops,
+					   const struct assoc_array_node *node,
+					   int level)
+{
+	struct assoc_array_ptr *ptr;
+	unsigned long base_seg;
+	bool have_meta;
+	int i;
+
+	have_meta = false;
+	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
+		ptr = node->slots[i];
+		if (assoc_array_ptr_is_meta(ptr)) {
+			edit->segment_cache[i] = 0xff;
+			have_meta = true;
+			continue;
+		}
+		base_seg = ops->get_object_key_chunk(
+			assoc_array_ptr_to_leaf(ptr), level);
+		base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
+		edit->segment_cache[i] = base_seg & ASSOC_ARRAY_FAN_MASK;
+	}
+	return have_meta;
+}
+
 /*
  * Handle insertion into a terminal node.
  */
@@ -534,7 +566,6 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 
 	node	= result->terminal_node.node;
 	level	= result->terminal_node.level;
-	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = result->terminal_node.slot;
 
 	pr_devel("-->%s()\n", __func__);
 
@@ -566,19 +597,8 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 
 	/* We need to find out how similar the leaves are. */
 	pr_devel("no spare slots\n");
-	have_meta = false;
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		ptr = node->slots[i];
-		if (assoc_array_ptr_is_meta(ptr)) {
-			edit->segment_cache[i] = 0xff;
-			have_meta = true;
-			continue;
-		}
-		base_seg = ops->get_object_key_chunk(
-			assoc_array_ptr_to_leaf(ptr), level);
-		base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
-		edit->segment_cache[i] = base_seg & ASSOC_ARRAY_FAN_MASK;
-	}
+	have_meta = assoc_array_fill_segment_cache(edit, ops, node, level);
+	edit->segment_cache[ASSOC_ARRAY_FAN_OUT] = result->terminal_node.slot;
 
 	if (have_meta) {
 		pr_devel("have meta\n");
@@ -791,13 +811,7 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	/* This now reduces to a node splitting exercise for which we'll need
 	 * to regenerate the disparity table.
 	 */
-	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		ptr = node->slots[i];
-		base_seg = ops->get_object_key_chunk(assoc_array_ptr_to_leaf(ptr),
-						     level);
-		base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
-		edit->segment_cache[i] = base_seg & ASSOC_ARRAY_FAN_MASK;
-	}
+	assoc_array_fill_segment_cache(edit, ops, node, level);
 
 	base_seg = ops->get_key_chunk(index_key, level);
 	base_seg >>= level & ASSOC_ARRAY_KEY_CHUNK_MASK;
-- 
2.53.0



