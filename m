Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD4488203;
	Thu, 17 Sep 2026 18:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670959; cv=none; b=uUwFx7j0uT5w8M1NoW6qo/TU7FJxVY2nrMJExsJDyCVRCc/GzkQdiqowPf7i+85olAk7Cw20I/dLrBmjdBMrgMzOcfVxcg89qsZpKgFf1zLVWTDbuaJWtpU3HYT3kyPRTYb+7TEBPi8bM2gJ6xSNB70OjXiyLUP2TUrFSFfkLI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670959; c=relaxed/simple;
	bh=tB7riHS2f9+Q+djh2GemY7cN0HxH8GDdsrQcEkgeUWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/dbCw3wdi/gJZHlnnWfV7iv41OIvQlenPi764rccxhwlXaf/C0b1l9NGpMcNXzai2LxIN4b1fnH/Ulkui11IBvnhMlDcpPQbQfr3RNyDKMHCGXDcHyXFCo9beP1a/JKsHBEUrX8JIgFMI0XN5dk2Pc909yQ1EASd5QQKg6r36U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNY76G3Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNY76G3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F391D1F000FF;
	Thu, 17 Sep 2026 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670957;
	bh=Lt9MuJMsHrc1+UITz6XfBZcQVTHZwjPq1aeLKFsp/nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNY76G3QV4AdqPJw2Af6rgv/QRRdBuPkz47PXtaRaUlU5F+xNzxIN59KXeA0cxJSz
	 GzGmaWontSHYQwsR6koluy2FBbsQx/6ojqIl7Kgj0XdFZMODYwGUvTljrvA64fW8Be
	 WDPH9drS9gtAK58hKcTzYJwGyLXC6LrBAIs1G2kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 0824/1102] tracing: Keep the entry count when the histogram stats allocation fails
Date: Thu, 17 Sep 2026 16:12:47 +0100
Message-ID: <20260917151601.192975195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 06f5634ec5584954177f9a22e36b3bfb398a971b upstream.

print_entries() uses n_entries both as the number of sort entries and as
its own return value, so the -ENOMEM it stores when the stats allocation
fails overwrites the count that the cleanup still needs:

	n_entries = tracing_map_sort_entries(map, ...);
	if (n_entries < 0)
		return n_entries;
	...
			if (!stats) {
				n_entries = -ENOMEM;
				goto out;
			}
	...
 out:
	tracing_map_destroy_sort_entries(sort_entries, n_entries);

tracing_map_destroy_sort_entries() takes an unsigned int and loops up to
it, so -ENOMEM arrives as 4294967284. It walks an array of at most
map->max_elts pointers and calls destroy_sort_entry(), which dereferences
and frees, on whatever lies past the end.

Reading the hist file of a trigger with a .percent value, with that
allocation forced to fail:

  BUG: KASAN: vmalloc-out-of-bounds in tracing_map_destroy_sort_entries+0xa0/0xb0
  Read of size 8 at addr ffffc90000045000 by task init/1
   tracing_map_destroy_sort_entries+0xa0/0xb0
   hist_show+0x6f7/0x1df0
   seq_read_iter+0x2b8/0x1190
   vfs_read+0x176/0xa40
  The buggy address belongs to a 4-page vmalloc region starting at
  ffffc90000041000 allocated at tracing_map_sort_entries+0x5c/0xd50

A few pages further the fault is fatal. The registers at the oops confirm
the bound: the loop's end pointer less the array start, over the pointer
size, is 4294967284.

Return the error in a separate variable and leave n_entries holding the
count, the way tracing_map_sort_entries() does on its own error path.

The stats block is only entered for a value carrying .percent or .graph,
which __create_val_field() has rejected since v6.3, so this cannot be
reached in mainline as it stands. It becomes reachable again with
"tracing: hist: let values keep the percent and graph modifiers", so it
should be applied first.

Cc: stable@vger.kernel.org
Fixes: abaa5258ce5e ("tracing: Add .percent suffix option to histogram values")
Link: https://patch.msgid.link/20260907060323.480728-1-donggeunyoo.kernel@gmail.com
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260907053113.1CED91F00A3A@smtp.kernel.org/
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5637,7 +5637,7 @@ static int print_entries(struct seq_file
 {
 	struct tracing_map_sort_entry **sort_entries = NULL;
 	struct tracing_map *map = hist_data->map;
-	int i, j, n_entries;
+	int i, j, n_entries, ret;
 	struct hist_val_stat *stats = NULL;
 	u64 val;
 
@@ -5647,6 +5647,8 @@ static int print_entries(struct seq_file
 	if (n_entries < 0)
 		return n_entries;
 
+	ret = n_entries;
+
 	/* Calculate the max and the total for each field if needed. */
 	for (j = 0; j < hist_data->n_vals; j++) {
 		if (!(hist_data->fields[j]->flags &
@@ -5656,7 +5658,7 @@ static int print_entries(struct seq_file
 			stats = kcalloc(hist_data->n_vals, sizeof(*stats),
 				       GFP_KERNEL);
 			if (!stats) {
-				n_entries = -ENOMEM;
+				ret = -ENOMEM;
 				goto out;
 			}
 		}
@@ -5677,7 +5679,7 @@ static int print_entries(struct seq_file
 out:
 	tracing_map_destroy_sort_entries(sort_entries, n_entries);
 
-	return n_entries;
+	return ret;
 }
 
 static void hist_trigger_show(struct seq_file *m,


