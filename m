Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6CF143C57;
	Tue, 23 Apr 2024 21:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908465; cv=none; b=GzQvuaB7yTUDbZ5WtHlAKfDF94ut9UaA1cqDBFL4QEitDfz68ST3CgP8Uutx62EtIHTPSX0zSzCRazhXsQs4TAeg0rGmkAOv4T/pwoZkiKVFQn+XjruCu5oa9mnppLh67WWLyPsyFIZM9VyxplyU9xGQdHvz7k3sTgb84xE+aik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908465; c=relaxed/simple;
	bh=5awk/cu7tF2a0X6Bp8+kQbnOB0yfBuD92lzS95sZ1wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLF+4qo9EHAcfizGfLz+gBeY6WMiHNrbNXfOtW3gkDIV/4Z2/wLgZ2JHMQJeeOl8YN5fl8FWu54yU4odrYZyq7mTX3InexCNjTduBheUB+LFuAWjU+j6VuAoBEuI7Xmwr27KWuQ2nO/tkXhKjHjx3QIv5kBlECf4zZW9SGjj5Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLBRDhHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLBRDhHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0082FC3277B;
	Tue, 23 Apr 2024 21:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908465;
	bh=5awk/cu7tF2a0X6Bp8+kQbnOB0yfBuD92lzS95sZ1wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLBRDhHaGay4oqBrKNqGwEuPlowzRXUsgqAbJZd6QOcXxqH0xNRVCNbEwwGLKotAs
	 oWtEwK7ZT8UEfNIzjqL7d7TGRvQeb0zf/Vn8rJ804MoAblBkUahP6cJCrlEn74TXAg
	 ZbGj97vbXODjQl6T3DQ+3mnpg5fUWvgPAjIMQ8NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.8 004/158] SUNRPC: Fix rpcgss_context trace event acceptor field
Date: Tue, 23 Apr 2024 14:37:06 -0700
Message-ID: <20240423213855.973807009@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit a4833e3abae132d613ce7da0e0c9a9465d1681fa upstream.

The rpcgss_context trace event acceptor field is a dynamically sized
string that records the "data" parameter. But this parameter is also
dependent on the "len" field to determine the size of the data.

It needs to use __string_len() helper macro where the length can be passed
in. It also incorrectly uses strncpy() to save it instead of
__assign_str(). As these macros can change, it is not wise to open code
them in trace events.

As of commit c759e609030c ("tracing: Remove __assign_str_len()"),
__assign_str() can be used for both __string() and __string_len() fields.
Before that commit, __assign_str_len() is required to be used. This needs
to be noted for backporting. (In actuality, commit c1fa617caeb0 ("tracing:
Rework __assign_str() and __string() to not duplicate getting the string")
is the commit that makes __string_str_len() obsolete).

Cc: stable@vger.kernel.org
Fixes: 0c77668ddb4e ("SUNRPC: Introduce trace points in rpc_auth_gss.ko")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rpcgss.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/rpcgss.h
+++ b/include/trace/events/rpcgss.h
@@ -609,7 +609,7 @@ TRACE_EVENT(rpcgss_context,
 		__field(unsigned int, timeout)
 		__field(u32, window_size)
 		__field(int, len)
-		__string(acceptor, data)
+		__string_len(acceptor, data, len)
 	),
 
 	TP_fast_assign(
@@ -618,7 +618,7 @@ TRACE_EVENT(rpcgss_context,
 		__entry->timeout = timeout;
 		__entry->window_size = window_size;
 		__entry->len = len;
-		strncpy(__get_str(acceptor), data, len);
+		__assign_str(acceptor, data);
 	),
 
 	TP_printk("win_size=%u expiry=%lu now=%lu timeout=%u acceptor=%.*s",


