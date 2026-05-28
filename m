Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F34282F17;
	Thu, 28 May 2026 20:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999550; cv=none; b=AKgJzADqzn/DytfY+p29yCsX7nW2D6tPNA5MGHHpoJZDFiL510iZEqqW5XHIxD5MzIUQ0wM+nxYOEratXF5V3tzihZuIjXk8zP2uXaINmcP5I/ILdWmQqi7GqJ6Yv+fg2kjkPzJf+uwVB2Fyuav1NUeic3lLMwJ39TKQI/1ONbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999550; c=relaxed/simple;
	bh=j9zGxHpf2Lbb+vFhO7zLoowT8a5MyTkn0CVnNJeHwB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhosuHrV9YHwPMLVkWx2IMxzbTKfdh9bXlu0nr0HWuLN+ncnwqdMAyhwwIp9ELRn7k2mpVbhN0esCxR5ab6A4O5N+dZb8goi1hLNqLBkk5hn0KUT584K2Z8k0In32sAYt0weOgjYrWCxUyJDni3JJe+yY+4cZXZnGqkntu2ZphM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRoWRiwm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRoWRiwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9161F000E9;
	Thu, 28 May 2026 20:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999549;
	bh=dnIO8SMtyU3P4I5juSy3sSI85ELXWSahkxybQCFhOL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRoWRiwmmGEWrGC7Unq0FSqoVpiMkgsA6XWO2a/4q/oOimHPkhvmGe8PgT50mtQt3
	 FjtYVMdpI5gchWp8Fu9ZTz0wAkOu3yngluas/FjT64qjXzMeHejfu+bwfU+YKuMcuR
	 QXE4WmlYj8LQteU8UGFLR9XJUhBsjaQyNmxhcSiM=
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
Subject: [PATCH 6.18 105/377] tracing: Do not call map->ops->elt_free() if elt_alloc() fails
Date: Thu, 28 May 2026 21:45:43 +0200
Message-ID: <20260528194641.384083086@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


