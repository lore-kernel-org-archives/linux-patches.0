Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90EE258CD9;
	Mon, 23 Mar 2026 16:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282961; cv=none; b=ru4IZ8RVHhf2dHAJ2C06KHnG7zH5PDsAL6VS1e2WJcz5EehW9HSnasdGRN4ygveyePhJ8bSGRLhdMSZWjxYoC3D/Oi2EWKcVzIJ4DebY+p9KH/2vyeebkWieqXy8aFxiOILZgAQLMrnV+g9UHIuZNGcC/Vp/XmBo+yvNd0I7MTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282961; c=relaxed/simple;
	bh=1ZjLfw+LMGO5yIQQIsuPXz30GBQSBi3VA2Daig9Ftps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ac2gaHVqnF5MUZUXjruP1d7u1pD5EdQdfWLv5Dk6NEpA/VEfPoPyS3iR678+gGSvnZdB8l6wY8aTo5DQk3UGPzHVCJTu2Hcct3x/obdW4tvpb53aR3/8Lns9V3uhefKEwb3TqTu6/TxHuL4bQ6KQpTWUMdiUqqpJZhu9CXaqPXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrT8Q3Va; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrT8Q3Va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2F6C4CEF7;
	Mon, 23 Mar 2026 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282961;
	bh=1ZjLfw+LMGO5yIQQIsuPXz30GBQSBi3VA2Daig9Ftps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrT8Q3VaST1Ur+lD7SqxiDy9pYWROCRJ+buv48dwouZTKjdMKcFr1JHXZOakYGycf
	 OnOopplQB6q3b3/18Z1ftZdXCVzXD5pSHBvxG3hpuOn6R1QUUPQ4dfAh6eMZgDGmB6
	 R4Y8BKI1Kr1MfKCEm0wSdyIOf6U7JIXXPfRS5Oto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 350/481] kprobes: Remove unneeded goto
Date: Mon, 23 Mar 2026 14:45:32 +0100
Message-ID: <20260323134533.634120709@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit 5e5b8b49335971b68b54afeb0e7ded004945af07 ]

Remove unneeded gotos. Since the labels referred by these gotos have
only one reference for each, we can replace those gotos with the
referred code.

Link: https://lore.kernel.org/all/173371211203.480397.13988907319659165160.stgit@devnote2/

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 5ef268cb7a0a ("kprobes: Remove unneeded warnings from __arm_kprobe_ftrace()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |   45 +++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1082,20 +1082,18 @@ static int __arm_kprobe_ftrace(struct kp
 
 	if (*cnt == 0) {
 		ret = register_ftrace_function(ops);
-		if (WARN(ret < 0, "Failed to register kprobe-ftrace (error %d)\n", ret))
-			goto err_ftrace;
+		if (WARN(ret < 0, "Failed to register kprobe-ftrace (error %d)\n", ret)) {
+			/*
+			 * At this point, sinec ops is not registered, we should be sefe from
+			 * registering empty filter.
+			 */
+			ftrace_set_filter_ip(ops, (unsigned long)p->addr, 1, 0);
+			return ret;
+		}
 	}
 
 	(*cnt)++;
 	return ret;
-
-err_ftrace:
-	/*
-	 * At this point, sinec ops is not registered, we should be sefe from
-	 * registering empty filter.
-	 */
-	ftrace_set_filter_ip(ops, (unsigned long)p->addr, 1, 0);
-	return ret;
 }
 
 static int arm_kprobe_ftrace(struct kprobe *p)
@@ -1447,7 +1445,7 @@ _kprobe_addr(kprobe_opcode_t *addr, cons
 	     unsigned long offset, bool *on_func_entry)
 {
 	if ((symbol_name && addr) || (!symbol_name && !addr))
-		goto invalid;
+		return ERR_PTR(-EINVAL);
 
 	if (symbol_name) {
 		/*
@@ -1477,11 +1475,10 @@ _kprobe_addr(kprobe_opcode_t *addr, cons
 	 * at the start of the function.
 	 */
 	addr = arch_adjust_kprobe_addr((unsigned long)addr, offset, on_func_entry);
-	if (addr)
-		return addr;
+	if (!addr)
+		return ERR_PTR(-EINVAL);
 
-invalid:
-	return ERR_PTR(-EINVAL);
+	return addr;
 }
 
 static kprobe_opcode_t *kprobe_addr(struct kprobe *p)
@@ -1504,15 +1501,15 @@ static struct kprobe *__get_valid_kprobe
 	if (unlikely(!ap))
 		return NULL;
 
-	if (p != ap) {
-		list_for_each_entry(list_p, &ap->list, list)
-			if (list_p == p)
-			/* kprobe p is a valid probe */
-				goto valid;
-		return NULL;
-	}
-valid:
-	return ap;
+	if (p == ap)
+		return ap;
+
+	list_for_each_entry(list_p, &ap->list, list)
+		if (list_p == p)
+		/* kprobe p is a valid probe */
+			return ap;
+
+	return NULL;
 }
 
 /*


