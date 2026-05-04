Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959453D300A;
	Mon,  4 May 2026 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904046; cv=none; b=PTy1/mdWuzM/EmZbPx5A3KjmgQhpUJdiOfK9l090KqyM1eWOcigm521SWabjzZfrqcG/VwKDreqLg6ijMevsgEAHrIm1zPYPCISgAyrugKKJfuHvTubR/5kRs4Dp6xfTkYc9tXo6Yk4BxJfuJyWQWszIHF14rvt+12o66car6hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904046; c=relaxed/simple;
	bh=SVCzj+qpUZHu1fzM3axBmAORABBL9NRd9OwhYZBt7cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD3OxFF0Gj8GEvEkiq9ILsCjbStEWK11T+rk2hJm5A2nTUBEYBZjtzsCVQUZjPfQyZGQuuPHVjM3QiijDiFN1Ng+8KfPB92zAQRv69aggaHNmB7AJJcgMcxZ4bdnVsnWN8RKGU4Jc5Ifr3T+Z4KPW1JbJys+SBg9IoNF6UtuwdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcPpiNxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcPpiNxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B224C2BCB8;
	Mon,  4 May 2026 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904046;
	bh=SVCzj+qpUZHu1fzM3axBmAORABBL9NRd9OwhYZBt7cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcPpiNxZtE4s5uJdCh7pALvm2NFgrgANwV7/uExFAV8a6OydQA3kPV7Bkb8qpRMag
	 orJPNavS7MccrXqpL4/ERNA4gMddDuq0PrtjATpruIVNxEm72zCgLDO61gq5dT7THE
	 3r07Ht5gesiIFsOpz72ksmUK8GfWyM1bU/vfQZ3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 130/275] tracing/fprobe: Reject registration of a registered fprobe before init
Date: Mon,  4 May 2026 15:51:10 +0200
Message-ID: <20260504135147.731871557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 6ad51ada17ed80c9a5f205b4c01c424cac8b0d46 upstream.

Reject registration of a registered fprobe which is on the fprobe
hash table before initializing fprobe.
The add_fprobe_hash() checks this re-register fprobe, but since
fprobe_init() clears hlist_array field, it is too late to check it.
It has to check the re-registration before touncing fprobe.

Link: https://lore.kernel.org/all/177669364845.132053.18375367916162315835.stgit@mhiramat.tok.corp.google.com/

Fixes: 4346ba160409 ("fprobe: Rewrite fprobe on function-graph tracer")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -4,6 +4,7 @@
  */
 #define pr_fmt(fmt) "fprobe: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/fprobe.h>
 #include <linux/kallsyms.h>
@@ -98,7 +99,7 @@ static bool delete_fprobe_node(struct fp
 }
 
 /* Check existence of the fprobe */
-static bool is_fprobe_still_exist(struct fprobe *fp)
+static bool fprobe_registered(struct fprobe *fp)
 {
 	struct hlist_head *head;
 	struct fprobe_hlist *fph;
@@ -111,7 +112,7 @@ static bool is_fprobe_still_exist(struct
 	}
 	return false;
 }
-NOKPROBE_SYMBOL(is_fprobe_still_exist);
+NOKPROBE_SYMBOL(fprobe_registered);
 
 static int add_fprobe_hash(struct fprobe *fp)
 {
@@ -123,9 +124,6 @@ static int add_fprobe_hash(struct fprobe
 	if (WARN_ON_ONCE(!fph))
 		return -EINVAL;
 
-	if (is_fprobe_still_exist(fp))
-		return -EEXIST;
-
 	head = &fprobe_table[hash_ptr(fp, FPROBE_HASH_BITS)];
 	hlist_add_head_rcu(&fp->hlist_array->hlist, head);
 	return 0;
@@ -140,7 +138,7 @@ static int del_fprobe_hash(struct fprobe
 	if (WARN_ON_ONCE(!fph))
 		return -EINVAL;
 
-	if (!is_fprobe_still_exist(fp))
+	if (!fprobe_registered(fp))
 		return -ENOENT;
 
 	fph->fp = NULL;
@@ -360,7 +358,7 @@ static void fprobe_return(struct ftrace_
 		if (!fp)
 			break;
 		curr += FPROBE_HEADER_SIZE_IN_LONG;
-		if (is_fprobe_still_exist(fp) && !fprobe_disabled(fp)) {
+		if (fprobe_registered(fp) && !fprobe_disabled(fp)) {
 			if (WARN_ON_ONCE(curr + size > size_words))
 				break;
 			fp->exit_handler(fp, trace->func, ret_ip, fregs,
@@ -718,12 +716,14 @@ int register_fprobe_ips(struct fprobe *f
 	struct fprobe_hlist *hlist_array;
 	int ret, i;
 
+	guard(mutex)(&fprobe_mutex);
+	if (fprobe_registered(fp))
+		return -EEXIST;
+
 	ret = fprobe_init(fp, addrs, num);
 	if (ret)
 		return ret;
 
-	mutex_lock(&fprobe_mutex);
-
 	hlist_array = fp->hlist_array;
 	ret = fprobe_graph_add_ips(addrs, num);
 	if (!ret) {
@@ -731,7 +731,6 @@ int register_fprobe_ips(struct fprobe *f
 		for (i = 0; i < hlist_array->size; i++)
 			insert_fprobe_node(&hlist_array->array[i]);
 	}
-	mutex_unlock(&fprobe_mutex);
 
 	if (ret)
 		fprobe_fail_cleanup(fp);
@@ -793,7 +792,7 @@ int unregister_fprobe(struct fprobe *fp)
 	int ret = 0, i, count;
 
 	mutex_lock(&fprobe_mutex);
-	if (!fp || !is_fprobe_still_exist(fp)) {
+	if (!fp || !fprobe_registered(fp)) {
 		ret = -EINVAL;
 		goto out;
 	}


