Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC661F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC0EC433CB;
	Tue,  1 Aug 2023 09:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881810;
	bh=N2PVZbYfREo011eLV7nsxoVrjET1+U6Z2wAvDlEEUrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXx7XOc0IYVrDMJvfPB5C74k06caDY+YHY4XPiLWT0BZrPicDmxAE8lJVWYDbC4sn
	 T3JzHFn5DPnGEV19QXAsHy4rrIlvAK/4kq9b15GN05cdGQAx7jCBwV4PDA1zapYYRh
	 /7DOLQO+N73lVDXEsugJF6iMR9eDH9TMAoqfXt18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/155] tracing/probes: Fix to record 0-length data_loc in fetch_store_string*() if fails
Date: Tue,  1 Aug 2023 11:19:09 +0200
Message-ID: <20230801091911.500453479@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 797311bce5c2ac90b8d65e357603cfd410d36ebb ]

Fix to record 0-length data to data_loc in fetch_store_string*() if it fails
to get the string data.
Currently those expect that the data_loc is updated by store_trace_args() if
it returns the error code. However, that does not work correctly if the
argument is an array of strings. In that case, store_trace_args() only clears
the first entry of the array (which may have no error) and leaves other
entries. So it should be cleared by fetch_store_string*() itself.
Also, 'dyndata' and 'maxlen' in store_trace_args() should be updated
only if it is used (ret > 0 and argument is a dynamic data.)

Link: https://lore.kernel.org/all/168908496683.123124.4761206188794205601.stgit@devnote2/

Fixes: 40b53b771806 ("tracing: probeevent: Add array type support")
Cc: stable@vger.kernel.org
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe_kernel.h | 13 +++++++++----
 kernel/trace/trace_probe_tmpl.h   | 10 +++-------
 kernel/trace/trace_uprobe.c       |  3 ++-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_probe_kernel.h b/kernel/trace/trace_probe_kernel.h
index 1d43df29a1f8e..2da70be83831c 100644
--- a/kernel/trace/trace_probe_kernel.h
+++ b/kernel/trace/trace_probe_kernel.h
@@ -37,6 +37,13 @@ kern_fetch_store_strlen(unsigned long addr)
 	return (ret < 0) ? ret : len;
 }
 
+static nokprobe_inline void set_data_loc(int ret, void *dest, void *__dest, void *base)
+{
+	if (ret < 0)
+		ret = 0;
+	*(u32 *)dest = make_data_loc(ret, __dest - base);
+}
+
 /*
  * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
  * with max length and relative data location.
@@ -55,8 +62,7 @@ kern_fetch_store_string_user(unsigned long addr, void *dest, void *base)
 	__dest = get_loc_data(dest, base);
 
 	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
+	set_data_loc(ret, dest, __dest, base);
 
 	return ret;
 }
@@ -87,8 +93,7 @@ kern_fetch_store_string(unsigned long addr, void *dest, void *base)
 	 * probing.
 	 */
 	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
+	set_data_loc(ret, dest, __dest, base);
 
 	return ret;
 }
diff --git a/kernel/trace/trace_probe_tmpl.h b/kernel/trace/trace_probe_tmpl.h
index 98ac09052fea4..3e2f5a43b974c 100644
--- a/kernel/trace/trace_probe_tmpl.h
+++ b/kernel/trace/trace_probe_tmpl.h
@@ -247,13 +247,9 @@ store_trace_args(void *data, struct trace_probe *tp, void *rec,
 		if (unlikely(arg->dynamic))
 			*dl = make_data_loc(maxlen, dyndata - base);
 		ret = process_fetch_insn(arg->code, rec, dl, base);
-		if (arg->dynamic) {
-			if (unlikely(ret < 0)) {
-				*dl = make_data_loc(0, dyndata - base);
-			} else {
-				dyndata += ret;
-				maxlen -= ret;
-			}
+		if (arg->dynamic && likely(ret > 0)) {
+			dyndata += ret;
+			maxlen -= ret;
 		}
 	}
 }
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 78ec1c16ccf4b..debc651015489 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -168,7 +168,8 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
 			 */
 			ret++;
 		*(u32 *)dest = make_data_loc(ret, (void *)dst - base);
-	}
+	} else
+		*(u32 *)dest = make_data_loc(0, (void *)dst - base);
 
 	return ret;
 }
-- 
2.39.2



