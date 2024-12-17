Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86BC1F37BE;
	Tue, 17 Dec 2024 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455420; cv=none; b=GWXjhmvidEheAIhySAnWOW/LVGI0nLk/nlBvhBvwe01fOaGajTOC6sJt2aA64L+6FXOzPruRY+5lbeXgOGcZ3d0nGuxvkRlJ753AAIsc8BsuTorLtXMGkhIeR+P8pOvkGlNmNeR6RGr1F8OzqowonD6KimMM68cm/i6YQ/Bad3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455420; c=relaxed/simple;
	bh=dPlsuFrV+K8tFI/DPe7Nmwx8XN/UrmCW6q1wQGyXmqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW4PJgcy5G0SxVlhfEL44iDuhhO0SAI9/Ms3pnvxV89hrhDp1G36bJdurrfMz1QJXY8xOe+sg7OnAn051p1y98x5C8ooWGjWPnqfkv9U70gbNg6ApM1xvzGCUqo+jP+JIRG7/MidFCkopp4OgtjRg5oCk1+p+q+afI0wqLIMah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ot/RuWSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ot/RuWSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441FAC4CED7;
	Tue, 17 Dec 2024 17:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455420;
	bh=dPlsuFrV+K8tFI/DPe7Nmwx8XN/UrmCW6q1wQGyXmqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ot/RuWSgV70R9qSBxV+3OW2xtszM+TdcBICRukEyL3I1CxxTlxa5Yr5IlTOZaoHgO
	 Cg2GdMhyajdaN9MPdvTLUCx8uLSoWPA6GAXnl2On38EB8coucuhXatSSi5yLYi3JBW
	 RikPgKNcpJajYEelEXrWjyJB4m0hm3ivwnx7eqZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH 5.4 22/24] tracing/kprobes: Skip symbol counting logic for module symbols in create_local_trace_kprobe()
Date: Tue, 17 Dec 2024 18:07:20 +0100
Message-ID: <20241217170519.911164350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
avoids checking number_of_same_symbols() for module symbol in
__trace_kprobe_create(), but create_local_trace_kprobe() should avoid this
check too. Doing this check leads to ENOENT for module_name:symbol_name
constructions passed over perf_event_open.

No bug in newer kernels as it was fixed more generally by
commit 9d8616034f16 ("tracing/kprobes: Add symbol counting check when module loads")

Link: https://lore.kernel.org/linux-trace-kernel/20240705161030.b3ddb33a8167013b9b1da202@kernel.org
Fixes: b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v1 -> v2:
 * Reword commit title and message
 * Send for stable instead of mainline

 kernel/trace/trace_kprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1663,7 +1663,7 @@ create_local_trace_kprobe(char *func, vo
 	int ret;
 	char *event;
 
-	if (func) {
+	if (func && !strchr(func, ':')) {
 		unsigned int count;
 
 		count = number_of_same_symbols(func);


