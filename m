Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705244;
	b=MJPH2RhDjwzQgtvQmqKsE23bjqbDAJLeF9EFJyjTHpa7ua0Bwgt8VXsamebqlkCZ0CsN
	 UDOyRXxTUqRXeMCn52NBcVWgMHrjs6SqVL/8j2QOT1WAkOi18hFg1tx3yCiSArY94gaoI
	 WkXuVdsoCxA56qtoIsuHdqniLCO0vaxBY98ZTrFrC3jL1Y1TNn1zZ6O0rbSD3Dh5OgEw7
	 jF6FxuCu2caJh7jQu7soQFY5o3X35kY7B/CMIQpoe6IKQNvsaO3IcAudtxB2lXy1l7qZk
	 x3JsA+56KVf+rSSySArbq4/WJJBUlU4fzInDQJIlOm3Vfg0OHsHhfl7nCIQBctwJGyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0NMLwoq5XXU/iQoksl2SAue63IOTEhHnx7cXb0Qiglo=;
	b=b8I6ger/wsXXeCDG9M1Bq1NyRK24ZpgAENLfVP897ljijavkdTcYHXl8uj04EPIJwPtg
	 F9VIGuDYBY30CJgJN9/YBZ/p+dFiSYGpfRJxx1QBTm8VGZ6uAkb6CvgXJyGdhYo6VpcZA
	 1P0ZLUT4sHZOp7N1Uf9VZhji2cuXHLcGEuHfJcBpSGCwSACRpm9/fpcuCbIMLstNhdqhS
	 kpaz5lt+o36koL8VJJ9EjcfuLkCl1zK855OpYUKeWDSaSexVWxvJOpcQQA5dR1Gt/ADSE
	 kR5r5qQny7ICnD0GJs2wIU1L5m9IUOm4GBbFAcwP7jG5PXLvVuOe8DGesl3GwViFUng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9UjoIFu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448EF606A31C;
	Thu, 26 Nov 2026 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9UjoIFu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2511F000C0;
	Thu, 26 Nov 2026 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705243;
	bh=0NMLwoq5XXU/iQoksl2SAue63IOTEhHnx7cXb0Qiglo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9UjoIFulB2E/RaHrc+MqzlyfLMAiTS31OfcpfTotVl3iveEiruJwqeMj/P/W4q3g
	 l574YFeNlGN++INEFdfoPVpj2mIjOf8fWwkY9X8UJKa62OFQC0Vcy1McmNnLX55+r+
	 xyLHQLH3TOREpLwusmfdj9gIJeFOz054STJTp6mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/319] tracing/probes: bound symstr stores to reserved length
Date: Thu, 26 Nov 2026 15:38:22 +0100
Message-ID: <20261126144009.771637737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3e2f5a43b974c..5c6a3fd1bd163 100644
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
 
 /* From the 2nd stage, routine is same */
-- 
2.53.0



