Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621801;
	b=ak9JAjMfzhb3u2lwWSGbg319Le+mf9ZCfMWznrYmeAgGgfjzszBUUnc74r/qwYj1o76E
	 2xr2igGhElJyveSJFV22yPXKKnlA221Y5sfiKGLX/+T4xijr8IrkQtCIX8folUMDfTYn7
	 xBVtf4H8mcx7giUVFKXESd0FKIa+1VvC3t8T5y23vh+OefJnVo31cXfcwPIx8cJTQo92u
	 VQsM05oPQZyYhtJB4l1003LdD3u25InCoObIXiDNWsFqsPgx7nnofPV2bLfR8SzF43jKA
	 eCVoNXylhFfQNsGVNQ0RmKZo1Tye14unQcGrYTivVGQaBkf2DddxzxHjqPMaqiNWX8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3mP/S6IVQ3GFt+ssrrDjO6oho32F2tcc13Cl2hlU+JA=;
	b=0pJFEVAg2HDvFfHUtjPq3R/4NDXCFmihYuCZmKXTJZv2MIir9/ByHTpVzX92C3cHNv67
	 BHi8vq/VkgRElocvgNZlzwtbY345rZpoVlHzZvNbuZtd7nA5axwQy6BtbKhRRCDKG/neN
	 U71+5ocQBo/QU47nsB2uQuHoQHmITYCLyySHVRgkn/94TX2oST8z5mJXU4HfqguzCpbje
	 n3A0Y2Ha3nejtOqYUb+7oVxHvyXw1pIu0W4hJ2eC7E1plvu/oqgMVBpm65jwg5VMWGEaf
	 QHhAMh8NcS8cPG4z8ZM+YeFOUOMev8HMpvpip2as1iydJ08YasjMThQkOd0h5KEPzhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PYgygh/+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF24606A33A;
	Wed, 25 Nov 2026 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYgygh/+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCAE1F000D1;
	Wed, 25 Nov 2026 15:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621800;
	bh=3mP/S6IVQ3GFt+ssrrDjO6oho32F2tcc13Cl2hlU+JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYgygh/+7rYQtg+r9xVLbfLt18LNmtnD4bbr2jSBZioQJO8bEp9TmNdyctQsAQbqL
	 TMVkDiw4UUnW53PPs24hvPv+eH1tYnz4mjXTe5GZqLHzAVymzQ/SJiPeHlEJkBH4J6
	 8HNW3GQ7nk7a76lCfuoCc1mXJ/zCbhSqQ2QsRuao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 339/990] tracing/probes: bound symstr stores to reserved length
Date: Wed, 25 Nov 2026 15:28:26 +0100
Message-ID: <20261125143830.033264292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>

[ Upstream commit 2fc0b3070d6d5dcecfed43cd0e62aa0fd4b4315c ]

Traceprobe calculates dynamic string sizes before storing the values.  A
probed pointer can change between those passes, so
fetch_store_symstrlen() can reserve space for a short symbol while
fetch_store_symstring() observes a longer one.  The store path then
overwrites the trace record.

Format the symbol into a temporary KSYM_SYMBOL_LEN buffer and copy only
the bytes that fit in the reserved field, including a trailing NUL.
Update __data_loc with the length actually stored so consumers do not
read beyond the truncated value.

Link: https://lore.kernel.org/all/179378621331.55520.2052332247156241151@stu.pku.edu.cn/

Fixes: b26a124cbfa8 ("tracing/probes: Add symstr type for dynamic events")
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe_tmpl.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe_tmpl.h b/kernel/trace/trace_probe_tmpl.h
index f39b37fcdb3b5..636e0a52383f4 100644
--- a/kernel/trace/trace_probe_tmpl.h
+++ b/kernel/trace/trace_probe_tmpl.h
@@ -87,15 +87,27 @@ fetch_store_symstrlen(unsigned long addr)
 static nokprobe_inline int
 fetch_store_symstring(unsigned long addr, void *dest, void *base)
 {
+	char namebuf[KSYM_SYMBOL_LEN];
 	int maxlen = get_loc_len(*(u32 *)dest);
 	void *__dest;
+	int len;
 
 	if (unlikely(!maxlen))
 		return -ENOMEM;
 
 	__dest = get_loc_data(dest, base);
+	len = sprint_symbol(namebuf, addr);
+	if (len < 0) {
+		*(u32 *)dest = make_data_loc(0, __dest - base);
+		return 0;
+	}
+
+	len = min(len, maxlen - 1);
+	memcpy(__dest, namebuf, len);
+	((char *)__dest)[len] = '\0';
+	*(u32 *)dest = make_data_loc(len + 1, __dest - base);
 
-	return sprint_symbol(__dest, addr);
+	return len + 1;
 }
 
 /* common part of process_fetch_insn*/
-- 
2.53.0



