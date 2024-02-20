Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8B4151CCC;
	Tue, 20 Feb 2024 21:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464963; cv=none; b=YLENNOj6G30bt9+IMOIRYfDe31SLBVU04a1czgIDEKMncqbppB74TivzSniQDbOA3E3pdZLakqtF9sT0xaFCXXF+V8ljUi5A1Qb7gPvPfcTduULs+sVbefeyPTu1jISMZyI4KqdtiqNYs0Dbq4zHAYfcYculpISSlVsFqG9KMCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464963; c=relaxed/simple;
	bh=oKilM+6F9QS1fDxCRnfABopqYDPXb71S53cQowLCTII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qur5SsM4TGS7ldMTxRxs4xQQJE0uyEVs6a07FIWp5scsaODnL3kzfbpWTDcSqFVuopKK0/y7RmxHk2Qu/SrqmOvdI8zbzjoyeqdukUPU1ku+k0YxU8ZQp4OU+jbbJOKKz/eT/ZiIBV6JgV0G3O6/CjG9YkjiqZ8BBxyJZVa+0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgmEn5In; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgmEn5In"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D36C433F1;
	Tue, 20 Feb 2024 21:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464963;
	bh=oKilM+6F9QS1fDxCRnfABopqYDPXb71S53cQowLCTII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgmEn5InPMxlCYu1I8GWQZCgv4Xt4DAvwui/q9zYhylGIhCV/I4lZ3j+fkVXNaweB
	 px7qN+cl+G2fDDtGL7gh0TEoA7uJNyBul5m91foufRepP3Qr4oZGE7iEMqog104mKN
	 VJofb6SXRCewE2sjY3Ih2cxjLsJbZ0RBtgg5Q/+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 163/309] tracing/synthetic: Fix trace_string() return value
Date: Tue, 20 Feb 2024 21:55:22 +0100
Message-ID: <20240220205638.259870890@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@toblux.com>

commit 9b6326354cf9a41521b79287da3bfab022ae0b6d upstream.

Fix trace_string() by assigning the string length to the return variable
which got lost in commit ddeea494a16f ("tracing/synthetic: Use union
instead of casts") and caused trace_string() to always return 0.

Link: https://lore.kernel.org/linux-trace-kernel/20240214220555.711598-1-thorsten.blum@toblux.com

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: ddeea494a16f ("tracing/synthetic: Use union instead of casts")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -441,8 +441,9 @@ static unsigned int trace_string(struct
 	if (is_dynamic) {
 		union trace_synth_field *data = &entry->fields[*n_u64];
 
+		len = fetch_store_strlen((unsigned long)str_val);
 		data->as_dynamic.offset = struct_size(entry, fields, event->n_u64) + data_size;
-		data->as_dynamic.len = fetch_store_strlen((unsigned long)str_val);
+		data->as_dynamic.len = len;
 
 		ret = fetch_store_string((unsigned long)str_val, &entry->fields[*n_u64], entry);
 


