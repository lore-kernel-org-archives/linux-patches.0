Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB8D3290B0;
	Thu, 28 May 2026 19:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998223; cv=none; b=kjWEzzg2mTX/q/7wQA4JrdCr7s+bLIwzAioNmwwdYgd/AdO7cwBM8UFhaYNbqpKIeVJWiafgs18JqE/6LO35jueqRekaqrVU+AoMvTtMI08DHfSPN7AfUxFTACFRrvAeoIT76C0DpOeRo+Se3TIqYnivkeOwPvCucc8qmGjpqPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998223; c=relaxed/simple;
	bh=pz9iy/YduGwoO5QuA7lIngy8moSZiH0V75D/IDtD2oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbyytbs8vPJobtFGPDjkwrj2108luU0FeA8ruZZLPHt3kRa0PGCHquLsy08tOgw7XzCq1gr/VLHuqINsIIyt0nOA1olQPNfgW1N2du4fPtJeRf4WDLPIsIshIFSIlpNJWPzQQd2cwDUJFN3pVR1jfwyBN3IeIRdgtYjA5+O7H7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COClk1YR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COClk1YR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17181F000E9;
	Thu, 28 May 2026 19:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998222;
	bh=fG8YIVCYpebhjwtbFgiaQz3ImU/lqBcAVx3g3Nfqgok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COClk1YRSxMu1vrcGq5hya1/MmWvA+bf0/UPj07RQrKOLYEhC1s7wTvZMy9pFLD3d
	 FOtDhWQUH0GSGhZAcyg6cv1guk/nS3RR1eK8l/xY9awVNfAAGK5Rq/uNLdsmXaebvH
	 qRa4cn4CsdLWZOYxl7OhhxeD5DlW8E2Hwg7VxmYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Rosen Penev <rosenp@gmail.com>,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.0 097/461] tracing: Do not call map->ops->elt_free() if elt_alloc() fails
Date: Thu, 28 May 2026 21:43:46 +0200
Message-ID: <20260528194649.754488750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 8f0f5c4fb9df0e19a341e0c6ed8dc4fda9124f03 upstream.

In paths where tracing_map_elt_alloc() failed to allocate objects,
the map->ops->elt_alloc() call was never successful. In this case,
map->ops->elt_free() should not be called.

Link: https://sashiko.dev/#/patchset/20260520223101.34710-1-rosenp%40gmail.com

Cc: stable@vger.kernel.org
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rosen Penev <rosenp@gmail.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 2734b629525a ("tracing: Add per-element variable support to tracing_map")
Link: https://patch.msgid.link/177933895460.108746.5396070821443932634.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/tracing_map.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -386,13 +386,11 @@ static void tracing_map_elt_init_fields(
 	}
 }
 
-static void tracing_map_elt_free(struct tracing_map_elt *elt)
+static void __tracing_map_elt_free(struct tracing_map_elt *elt)
 {
 	if (!elt)
 		return;
 
-	if (elt->map->ops && elt->map->ops->elt_free)
-		elt->map->ops->elt_free(elt);
 	kfree(elt->fields);
 	kfree(elt->vars);
 	kfree(elt->var_set);
@@ -400,6 +398,17 @@ static void tracing_map_elt_free(struct
 	kfree(elt);
 }
 
+static void tracing_map_elt_free(struct tracing_map_elt *elt)
+{
+	if (!elt)
+		return;
+
+	/* Only objects initialized with alloc_elt() should be passed to free_elt().*/
+	if (elt->map->ops && elt->map->ops->elt_free)
+		elt->map->ops->elt_free(elt);
+	__tracing_map_elt_free(elt);
+}
+
 static struct tracing_map_elt *tracing_map_elt_alloc(struct tracing_map *map)
 {
 	struct tracing_map_elt *elt;
@@ -444,7 +453,7 @@ static struct tracing_map_elt *tracing_m
 	}
 	return elt;
  free:
-	tracing_map_elt_free(elt);
+	__tracing_map_elt_free(elt);
 
 	return ERR_PTR(err);
 }


