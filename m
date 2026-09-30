Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DA646D577;
	Wed, 30 Sep 2026 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785448; cv=none; b=ahnleb0YYcXElGubWLQIL/en0M5mO7owZtuCF7d0dBmSPyFhapnPI97mViZe+dVhKJERRhvxyxsyiP/o+kgUsXIe9JVYRRubTOd8d5HuBMPwLBZEaOi+4BPg35UGRwBLJ1kskaTnnVS3eYrDWiWpZaaVHhqqYcM+ezicXuTRNwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785448; c=relaxed/simple;
	bh=OY28303UwN+S6/I1hw4xTSvV6XzMShIyGdHQGmNHMdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTs/cR55quoQoWen3lR50H6oV51g4kui2ZAsaRgFThIUMXxL2d2uLolom5unpCX8VKwz7tfeOv+0M3ipR9/u9ecaxTWSmzGZVPL/duJIE0RBhAOmObS0iLlTOA/TlBsxXFs2A7UDlF+PBlXBtkHnZowpcslZO85PicjoNLIVS98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCWJ4QT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCWJ4QT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972AF1F0089A;
	Wed, 30 Sep 2026 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785441;
	bh=zdJxtJ7Z/766iaYijt/W4aX1Pmdp8bQN+bIjw8k9aog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCWJ4QT6ZkkrylJPcKLSZGAbIUtpTl/RXc3n1Kes6M2oysmYaKbq5jAsJZSs7O/9s
	 MtF9Al5DHLhkOLzxX3cshKdFVJik2kzmVfVwMRTr/nb7TqlWYI8NBI0NLilGTdBNV0
	 LZeCVDKywHt30xTSC4wJXuFGntr5JU4qap4z0N04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 511/982] tracing: Keep the entry count when the histogram stats allocation fails
Date: Wed, 30 Sep 2026 17:20:47 +0200
Message-ID: <20260930152427.752829458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5416,7 +5416,7 @@ static int print_entries(struct seq_file
 {
 	struct tracing_map_sort_entry **sort_entries = NULL;
 	struct tracing_map *map = hist_data->map;
-	int i, j, n_entries;
+	int i, j, n_entries, ret;
 	struct hist_val_stat *stats = NULL;
 	u64 val;
 
@@ -5426,6 +5426,8 @@ static int print_entries(struct seq_file
 	if (n_entries < 0)
 		return n_entries;
 
+	ret = n_entries;
+
 	/* Calculate the max and the total for each field if needed. */
 	for (j = 0; j < hist_data->n_vals; j++) {
 		if (!(hist_data->fields[j]->flags &
@@ -5435,7 +5437,7 @@ static int print_entries(struct seq_file
 			stats = kcalloc(hist_data->n_vals, sizeof(*stats),
 				       GFP_KERNEL);
 			if (!stats) {
-				n_entries = -ENOMEM;
+				ret = -ENOMEM;
 				goto out;
 			}
 		}
@@ -5456,7 +5458,7 @@ static int print_entries(struct seq_file
 out:
 	tracing_map_destroy_sort_entries(sort_entries, n_entries);
 
-	return n_entries;
+	return ret;
 }
 
 static void hist_trigger_show(struct seq_file *m,


