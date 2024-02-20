Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAADB151CCC;
	Tue, 20 Feb 2024 21:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464969; cv=none; b=PuCwI/6zMXrDHMIYyXh+OUbF41aHHzM8OyipD3qHY8ekKirW0zPM47XeycM/3AfD6Dw+O53gbQDOao5bbHvMsHWhxHrbGj28ahcqZPnhudMMnvJ9BK05WYl86bN6ROZBLxAPt1ZAm4sZmLxKtG0qkYopsNP79l6RW7T/xgCjfP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464969; c=relaxed/simple;
	bh=9XsyvbbfSiUtIjgGisNN00fhRprmFLX56tl3A6m641M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDdjSET2uP/RwLOxslEQitz6JjctP93Ft5/TzyZJJqWXDQXNaHmXm3Vy/XOXsZruslm3rhielhAhPIiLZukcXCUagxk8rzCvrXGitssBl1siHZE62KO/K5hpKv5Kog/ChGci68La5rN0RCoo3T7JKQMGpbwlHT2894NGkgF0TWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxlZK/3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxlZK/3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B107C433C7;
	Tue, 20 Feb 2024 21:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464969;
	bh=9XsyvbbfSiUtIjgGisNN00fhRprmFLX56tl3A6m641M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxlZK/3GAFikBMSIFM7wCU4WAk3dhmuNCLyaA44stXvi0b0sbdaDqaU+fzZ3eIiU/
	 cv4Wi9jFzURsVrymiQOri6GfjoHg2Zp+x2coHfMPXW6g5LuXXwJjd1Y0neDcnNwccF
	 Mpf5NGVZ7x0w+/YUhbNFLugvlHAvYED2FG/QS8Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.7 165/309] tracing/probes: Fix to set arg size and fmt after setting type from BTF
Date: Tue, 20 Feb 2024 21:55:24 +0100
Message-ID: <20240220205638.318619804@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 9a571c1e275cedacd48c66a6bddd0c23f1dffdbf upstream.

Since the BTF type setting updates probe_arg::type, the type size
calculation and setting print-fmt should be done after that.
Without this fix, the argument size and print-fmt can be wrong.

Link: https://lore.kernel.org/all/170602218196.215583.6417859469540955777.stgit@devnote2/

Fixes: b576e09701c7 ("tracing/probes: Support function parameters if BTF is available")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1172,18 +1172,6 @@ static int traceprobe_parse_probe_arg_bo
 		trace_probe_log_err(ctx->offset + (t ? (t - arg) : 0), BAD_TYPE);
 		goto out;
 	}
-	parg->offset = *size;
-	*size += parg->type->size * (parg->count ?: 1);
-
-	ret = -ENOMEM;
-	if (parg->count) {
-		len = strlen(parg->type->fmttype) + 6;
-		parg->fmt = kmalloc(len, GFP_KERNEL);
-		if (!parg->fmt)
-			goto out;
-		snprintf(parg->fmt, len, "%s[%d]", parg->type->fmttype,
-			 parg->count);
-	}
 
 	code = tmp = kcalloc(FETCH_INSN_MAX, sizeof(*code), GFP_KERNEL);
 	if (!code)
@@ -1207,6 +1195,19 @@ static int traceprobe_parse_probe_arg_bo
 				goto fail;
 		}
 	}
+	parg->offset = *size;
+	*size += parg->type->size * (parg->count ?: 1);
+
+	if (parg->count) {
+		len = strlen(parg->type->fmttype) + 6;
+		parg->fmt = kmalloc(len, GFP_KERNEL);
+		if (!parg->fmt) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		snprintf(parg->fmt, len, "%s[%d]", parg->type->fmttype,
+			 parg->count);
+	}
 
 	ret = -EINVAL;
 	/* Store operation */


