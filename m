Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07FB24503E;
	Tue, 29 Apr 2025 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947486; cv=none; b=tVCb1//uRJ1B/NBmy+i5cOh49Q8dhLLr1YbY4rgBPr3A6eNj4i15mxDWEbAoab+CQg1K3QG8TyM06r5Ye2QZbnPVEFGcdKWEjcPVYP7cR4zUN+71jArrzUKATUO89q1HMnGIANlJZA1CqkTdbTMYN70VcrlEfyBlcCTuhhecGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947486; c=relaxed/simple;
	bh=j0hL/FUGLJH8Xr8dje9n/KIbQL+EdafUc0Ku5esgKoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEAM5jREUHPQ23ztHgGfl79Z7/naMww8ahVtAGnk9ioPIE8SN0yQyJzS5HVVnKxuWUM05uTXkAJRaI8EMHyF3D+96Q/3p786dUWz2XUPId9U9WV5jRzYgsvzx9eNQNuKXiLfTqNqgnNtmp/1Nw0ytR68uYaf3pTyAd541CLyrcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0D9nDzfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0D9nDzfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477BCC4CEE3;
	Tue, 29 Apr 2025 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947486;
	bh=j0hL/FUGLJH8Xr8dje9n/KIbQL+EdafUc0Ku5esgKoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0D9nDzfjIRuVnZPP22SHj2/rMIIoCZ2TlgQWZnR0VyvSGd9bMOPfFPi0iPqI0g0kE
	 8DC6sOb99yu8cGXqIptoQA4tfbQVYmYTsznkjirJN9VAE7/fLWiufbJqFKNCPz0g9I
	 fzPFnqNFfP7SW1cqXS9iTG6jOhfp60wHCKxA8hxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/280] tracing: Add __print_dynamic_array() helper
Date: Tue, 29 Apr 2025 18:39:03 +0200
Message-ID: <20250429161115.113574699@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

[ Upstream commit e52750fb1458ae9ea5860a08ed7a149185bc5b97 ]

When printing a dynamic array in a trace event, the method is rather ugly.
It has the format of:

  __print_array(__get_dynamic_array(array),
            __get_dynmaic_array_len(array) / el_size, el_size)

Since dynamic arrays are known to the tracing infrastructure, create a
helper macro that does the above for you.

  __print_dynamic_array(array, el_size)

Which would expand to the same output.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://lore.kernel.org/r/20241022194158.110073-3-avadhut.naik@amd.com
Stable-dep-of: ea8d7647f9dd ("tracing: Verify event formats that have "%*p.."")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/stages/stage3_trace_output.h | 8 ++++++++
 include/trace/stages/stage7_class_define.h | 1 +
 samples/trace_events/trace-events-sample.h | 7 ++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/trace/stages/stage3_trace_output.h b/include/trace/stages/stage3_trace_output.h
index c1fb1355d3094..1e7b0bef95f52 100644
--- a/include/trace/stages/stage3_trace_output.h
+++ b/include/trace/stages/stage3_trace_output.h
@@ -119,6 +119,14 @@
 		trace_print_array_seq(p, array, count, el_size);	\
 	})
 
+#undef __print_dynamic_array
+#define __print_dynamic_array(array, el_size)				\
+	({								\
+		__print_array(__get_dynamic_array(array),		\
+			      __get_dynamic_array_len(array) / (el_size), \
+			      (el_size));				\
+	})
+
 #undef __print_hex_dump
 #define __print_hex_dump(prefix_str, prefix_type,			\
 			 rowsize, groupsize, buf, len, ascii)		\
diff --git a/include/trace/stages/stage7_class_define.h b/include/trace/stages/stage7_class_define.h
index bcb960d16fc0e..fcd564a590f43 100644
--- a/include/trace/stages/stage7_class_define.h
+++ b/include/trace/stages/stage7_class_define.h
@@ -22,6 +22,7 @@
 #undef __get_rel_cpumask
 #undef __get_rel_sockaddr
 #undef __print_array
+#undef __print_dynamic_array
 #undef __print_hex_dump
 #undef __get_buf
 
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 55f9a3da92d5f..999f78d380aee 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -319,7 +319,7 @@ TRACE_EVENT(foo_bar,
 		__assign_cpumask(cpum, cpumask_bits(mask));
 	),
 
-	TP_printk("foo %s %d %s %s %s %s %s (%s) (%s) %s", __entry->foo, __entry->bar,
+	TP_printk("foo %s %d %s %s %s %s %s %s (%s) (%s) %s", __entry->foo, __entry->bar,
 
 /*
  * Notice here the use of some helper functions. This includes:
@@ -363,6 +363,11 @@ TRACE_EVENT(foo_bar,
 		  __print_array(__get_dynamic_array(list),
 				__get_dynamic_array_len(list) / sizeof(int),
 				sizeof(int)),
+
+/*     A shortcut is to use __print_dynamic_array for dynamic arrays */
+
+		  __print_dynamic_array(list, sizeof(int)),
+
 		  __get_str(str), __get_str(lstr),
 		  __get_bitmask(cpus), __get_cpumask(cpum),
 		  __get_str(vstr))
-- 
2.39.5



