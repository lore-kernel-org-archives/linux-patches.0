Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57F930E853;
	Sat, 30 May 2026 17:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162381; cv=none; b=f8KfHdEjZmvQGbhDS3gieA6EWmjYiC64IvP9Hyzc/ERwIRS2cv0crKmGsZ6cPybOgj9GZ2HFrJV3xPxX0giD+C4aYLzoehyoUP0sFJcqIPU6aMMp0lwbxInOsY1LZsn0wpp4UvevsP1cyahb4x8bcxPAt2IVb7CVXQ+7EtWeH5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162381; c=relaxed/simple;
	bh=EaxxrHiqq5jlnGPxxrLZK2++yKmQ3L/N19KcmuJ4YVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkIpbHCAJXTNJM6dmFi39pSb45RHwRzVQ+1Sr3rdRSn1Pdec8xpFHriT/ei57wmSbUj307dlxItXOK0u5DLW57Hj439gDG/1wCGyBgF6RpEDpWG4Oeg+23nuim1DOJbvIYdcLi9uAMxnB8tVIP39BnEtQaZjvpQegqM6GoKiih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1PRaA0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1PRaA0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A591F00893;
	Sat, 30 May 2026 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162380;
	bh=XKmHxdrN0yn1j2y5oKb+B3HQxpdtZtm4cYEIbB+BPKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1PRaA0PnXp0+ESesd2E/aiEE3E0f2U6hvauy6954oaXZDl0QC9D45qTsRM5zWaF7
	 GwQKiDyYfHZfdy6RegJEPFFtl8kmdVbJig8hQ5cNiBoVR8xOnmLF8hhsWCqeHPEvVN
	 YuQjAcrab8Hmb+qpRrcROdRjv7q2itd+l98KrnNo=
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
Subject: [PATCH 6.1 865/969] tracing: Do not call map->ops->elt_free() if elt_alloc() fails
Date: Sat, 30 May 2026 18:06:29 +0200
Message-ID: <20260530160324.563488377@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


