Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3124321459;
	Tue, 26 Aug 2025 11:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208707; cv=none; b=q2cq+eyxi4EgFnwbyfIpXoGoB5BrwmbdPTpI9NPC7M/IJ8fe3YAfym7x/I9QRLClkjg0q8BfTQPXpG5Oqu8UFsSwWcWxbMN5fCY22BUtHzyaTap9A0c46xLEiMr2VLrwBcYMW6HdYxNhL/sklME6aR1XS/OfrZuN+JRFZZHtjwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208707; c=relaxed/simple;
	bh=eonc+YTQcAvmFph/X10/P4V3qM8083B8oU+bRDgOurE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISIu11Ts6Dn+qp3DWd/KXDKlbtx3nPNxQqv01GEcXc17Wvt8l3GIDV0kRns/VRvL6s8RNGNcWDAyb7/F9VrPCSh81xxN9Ee+r3eeq4y8sH167+B3W4vaU4TM1oneNzYtdV30eT3Xz1bncPlQlObIcmmrHY7agxV3TfObcvRlP2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWf+2uKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWf+2uKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426E9C4CEF1;
	Tue, 26 Aug 2025 11:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208707;
	bh=eonc+YTQcAvmFph/X10/P4V3qM8083B8oU+bRDgOurE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWf+2uKWcjySTDk6QMByYvThYQk4GsjMxiMMJU8jxgFdf5bqjFnYPPDGQx2u6o/0D
	 nriIFXycQUEzPoR1g/Jmu1ZqxBjVN4P2py/XN2JCKqTvw9WVyStda6K72ZX16yBz2+
	 6Ak1nZvn0bFgVAHYgetnvTKEyL8EA+lu5IVzq3RI=
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
Subject: [PATCH 6.12 215/322] ftrace: Also allocate and copy hash for reading of filter files
Date: Tue, 26 Aug 2025 13:10:30 +0200
Message-ID: <20250826110921.187994313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4569,13 +4569,17 @@ ftrace_regex_open(struct ftrace_ops *ops
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
 
@@ -6445,9 +6449,6 @@ int ftrace_regex_release(struct inode *i
 		ftrace_hash_move_and_update_ops(iter->ops, orig_hash,
 						      iter->hash, filter_hash);
 		mutex_unlock(&ftrace_lock);
-	} else {
-		/* For read only, the hash is the ops hash */
-		iter->hash = NULL;
 	}
 
 	mutex_unlock(&iter->ops->func_hash->regex_lock);


