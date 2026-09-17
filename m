Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464844FDA76;
	Thu, 17 Sep 2026 17:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666300; cv=none; b=k8Pb/ep9VJJl08hh1kasHJXZxSa8riP2D8YYzWBAUDheWu2Og63gDLRmcWpNT/pLJsF+36awFDKwia47f5JNHaNOp/GQHwXajvqNu+uXrUntdlZc7idlO2usZ/a7HYv6Ttl3cbh1I9ZafTgxD45XcAYVCnTn2yrl9LPM0gY3E4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666300; c=relaxed/simple;
	bh=woaCDQoDx4S75nphXDGZZlTcHZ4OYT1rE/fEXlpRl24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKGrsFSPC3Ow/Tsn0V7ga5rCBV4HGfywO+ECFlSzf77yTCzQ0WryaHE2umaig7JEGtRoxg2Jna4OFwAxUR/48Xy/yLyDAw0nNTNaJVw2YkvpU9VPhhhDNdtgZEQ7FzdWULMizj9AZom3wm6g8z19N45waKMcHy9GlQTKOr6xo14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBaVO9pq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBaVO9pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A013B1F000FF;
	Thu, 17 Sep 2026 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666299;
	bh=A5HVOLPfmJ1fF7N7M+54J0UYz2jofKXUVKFQT/U1i78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBaVO9pq2Q1HLqOAOUAtsWKJMuTczb/3V4mIhlEGhH6+13B7vCRTXyAdHUqWgoHPL
	 f1pUxHOA+mP+wJsW7l1rV/K6WY3jqKTrI/jqZUvz5gX2EoppAksTcF40LpLtNrCbdg
	 4ieQfQ9ZAt/rP5c9E/cFlRCm2v+xHzn6/qyHSe9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 0992/1250] tracing: Keep the entry count when the histogram stats allocation fails
Date: Thu, 17 Sep 2026 16:13:07 +0100
Message-ID: <20260917151618.918206987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5664,7 +5664,7 @@ static int print_entries(struct seq_file
 {
 	struct tracing_map_sort_entry **sort_entries = NULL;
 	struct tracing_map *map = hist_data->map;
-	int i, j, n_entries;
+	int i, j, n_entries, ret;
 	struct hist_val_stat *stats = NULL;
 	u64 val;
 
@@ -5674,6 +5674,8 @@ static int print_entries(struct seq_file
 	if (n_entries < 0)
 		return n_entries;
 
+	ret = n_entries;
+
 	/* Calculate the max and the total for each field if needed. */
 	for (j = 0; j < hist_data->n_vals; j++) {
 		if (!(hist_data->fields[j]->flags &
@@ -5683,7 +5685,7 @@ static int print_entries(struct seq_file
 			stats = kcalloc(hist_data->n_vals, sizeof(*stats),
 				       GFP_KERNEL);
 			if (!stats) {
-				n_entries = -ENOMEM;
+				ret = -ENOMEM;
 				goto out;
 			}
 		}
@@ -5704,7 +5706,7 @@ static int print_entries(struct seq_file
 out:
 	tracing_map_destroy_sort_entries(sort_entries, n_entries);
 
-	return n_entries;
+	return ret;
 }
 
 static void hist_trigger_show(struct seq_file *m,


