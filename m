Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D920D4F8;
	Wed, 23 Apr 2025 15:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422259; cv=none; b=sFBLFail8DNLWcky1O64NgRDifh2mKaDdjnat+QBr7zuxmjvA0SFgHx+KP8FGgIeap1AUFzKry9bHrji7Wo/vhiLEgOFwEfsJkwobvm0JYtoGUDJK+m+9UtoUQu+HTNjkSlWH4bPfcrORLqNB3VmfkByX7ZXoAKRnA71/6zIIwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422259; c=relaxed/simple;
	bh=XGsmt1r0WH9G2vdwFK7D/br0g9K4Lw1kezZM7kti14A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux/jGVGqBhaRsTbuE7UlfTLI3uVKae0siw07s7r07FhV2jerjfEwRdiCUORnFJd8+hd/6cFSrrHwhb6C5D2J09rT52M4Oi1U28druOhGDzlkrxL/sfd6kR6ec7C3dBJINNZ8Ztl5cQJxXlu6Moqf41iPZPItAn8K4t9kaJDHuWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wpQChQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wpQChQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFEAC4CEE2;
	Wed, 23 Apr 2025 15:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422259;
	bh=XGsmt1r0WH9G2vdwFK7D/br0g9K4Lw1kezZM7kti14A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wpQChQMPkr9fodUpoAnZm/5J0y5mlbDZxRI+r8a2V8iBKqbozcSmBivX91qH4pUv
	 5al36j7JJoFOGxP6p/Oz9t/+lhipBxC5s8TsH1o7oh152ERwaYQz28CxRktUfZ2GrR
	 4pt8ZL93OcDbEsQvid+XeClkmvLFFo7r1CBASVGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 309/393] ftrace: fix incorrect hash size in register_ftrace_direct()
Date: Wed, 23 Apr 2025 16:43:25 +0200
Message-ID: <20250423142656.094705862@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 92f1d3b40179b15630d72e2c6e4e25a899b67ba9 ]

The maximum of the ftrace hash bits is made fls(32) in
register_ftrace_direct(), which seems illogical. So, we fix it by making
the max hash bits FTRACE_HASH_MAX_BITS instead.

Link: https://lore.kernel.org/20250413014444.36724-1-dongml2@chinatelecom.cn
Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash while in use")
Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 580ceb75f8c38..650493ed76cd4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5420,9 +5420,10 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	/* Make a copy hash to place the new and the old entries in */
 	size = hash->count + direct_functions->count;
-	if (size > 32)
-		size = 32;
-	new_hash = alloc_ftrace_hash(fls(size));
+	size = fls(size);
+	if (size > FTRACE_HASH_MAX_BITS)
+		size = FTRACE_HASH_MAX_BITS;
+	new_hash = alloc_ftrace_hash(size);
 	if (!new_hash)
 		goto out_unlock;
 
-- 
2.39.5



