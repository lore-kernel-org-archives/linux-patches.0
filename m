Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10386246333;
	Tue, 26 Aug 2025 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213952; cv=none; b=Zj4Aos7BqYzPcvQC1WTR+JCkrOK/xI7V4QBS0x4f2nOdfgMLzHOftAToDgxrkK91BSl/dfeAFYBRF06eR5qHQKeRao5jBD6C9wvOeW0jD+n8CjUXOfT8ekqIiFA82Xm/8zBnL7XHZ15TFykK5WhYF5oW8LuAA0DBDSd8bdQbWfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213952; c=relaxed/simple;
	bh=HAM5IBXag6hi0MUCcCIY8GooGBrGm8/iuVI7BTOF8qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCD/VL+/nK2NCjuicxFBe9t9RLmrs/rAIJww9cydn+sE3ga0SoQmalqFHQ7xD05DKzk+N2H6KKC35in49IdnDLzLcoWbXfBu7fHJyT01Qy5bwXpD6G+E0BDpPPsNHFMDOvupL1HbglLNpNGQBoluLAeq5PCGTAQG0kxoZBe3ZmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpDtiJc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpDtiJc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574EEC4CEF4;
	Tue, 26 Aug 2025 13:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213951;
	bh=HAM5IBXag6hi0MUCcCIY8GooGBrGm8/iuVI7BTOF8qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpDtiJc3lkP0iWbItLnuTAKh8QCyjKUJVP3DqUqqhy61zFcqbcq/sPjKYhvx4J78n
	 U1qFqzxI8YP/2u2sCbts0UtOmrrSCHVfWExnO1LLR1d2Qh8EMrQFTNCleACO6G0ABz
	 xV62Gi06CpNhygzSHHLysCxFEGGkPojr6YL2vGXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 514/587] ftrace: Also allocate and copy hash for reading of filter files
Date: Tue, 26 Aug 2025 13:11:03 +0200
Message-ID: <20250826111006.072464444@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit bfb336cf97df7b37b2b2edec0f69773e06d11955 upstream.

Currently the reader of set_ftrace_filter and set_ftrace_notrace just adds
the pointer to the global tracer hash to its iterator. Unlike the writer
that allocates a copy of the hash, the reader keeps the pointer to the
filter hashes. This is problematic because this pointer is static across
function calls that release the locks that can update the global tracer
hashes. This can cause UAF and similar bugs.

Allocate and copy the hash for reading the filter files like it is done
for the writers. This not only fixes UAF bugs, but also makes the code a
bit simpler as it doesn't have to differentiate when to free the
iterator's hash between writers and readers.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/20250822183606.12962cc3@batman.local.home
Fixes: c20489dad156 ("ftrace: Assign iter->hash to filter or notrace hashes on seq read")
Closes: https://lore.kernel.org/all/20250813023044.2121943-1-wutengda@huaweicloud.com/
Closes: https://lore.kernel.org/all/20250822192437.GA458494@ax162/
Reported-by: Tengda Wu <wutengda@huaweicloud.com>
Tested-by: Tengda Wu <wutengda@huaweicloud.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4058,13 +4058,17 @@ ftrace_regex_open(struct ftrace_ops *ops
 	        } else {
 			iter->hash = alloc_and_copy_ftrace_hash(size_bits, hash);
 		}
+	} else {
+		if (hash)
+			iter->hash = alloc_and_copy_ftrace_hash(hash->size_bits, hash);
+		else
+			iter->hash = EMPTY_HASH;
+	}
 
-		if (!iter->hash) {
-			trace_parser_put(&iter->parser);
-			goto out_unlock;
-		}
-	} else
-		iter->hash = hash;
+	if (!iter->hash) {
+		trace_parser_put(&iter->parser);
+		goto out_unlock;
+	}
 
 	ret = 0;
 
@@ -5922,9 +5926,6 @@ int ftrace_regex_release(struct inode *i
 		ftrace_hash_move_and_update_ops(iter->ops, orig_hash,
 						      iter->hash, filter_hash);
 		mutex_unlock(&ftrace_lock);
-	} else {
-		/* For read only, the hash is the ops hash */
-		iter->hash = NULL;
 	}
 
 	mutex_unlock(&iter->ops->func_hash->regex_lock);


