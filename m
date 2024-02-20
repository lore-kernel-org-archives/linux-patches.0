Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8D614A4D2;
	Tue, 20 Feb 2024 21:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464666; cv=none; b=H5iHiEzzCOAYkB6djbPHvGK4h44evIgepmJKpFxEj5IJGV9J+ukYS+Y6lUeH3xCgRVtlQHgKDM4U7LH1OhcRpILuZ9ITLyVFK7ocictkDh7hEZugfVFg7e5F7rMNatrEStkLTzabf1ypU1GZLmH6pcxvViBnPP8SvWTl2Eb0XDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464666; c=relaxed/simple;
	bh=7lyZoq3SGNBGAfYnKCQcNo7o8bQuFXV04mv5uSTpOeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKbIv/mR4rd2B66Kp9qVULTiQ9aH3tKySqsXTkyaUwivAj3EAckUjM6/w8bK4G5tvq4uYYYC1vA+Umj270gZs5RaflM/QFfWvkvHBv8YYFWMwq9LdYb8LpenrvOr7zK2pamL5drSMQKQB82pMTN9xsQjYeazkA81bGYVeQSN4sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgZ97n4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgZ97n4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F86AC433C7;
	Tue, 20 Feb 2024 21:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464666;
	bh=7lyZoq3SGNBGAfYnKCQcNo7o8bQuFXV04mv5uSTpOeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgZ97n4tl2Bdr1WSfHsgB5Ubq20XhUVGhucJpiF06A8CRQH9wukmeDoJPaKT6A3Yx
	 vD0nWFt5RUElGlZbkahlD2Y0tMLTuhmE6z4FN4sSMAjMYii9jhJMzJr0v1wy3ba39Z
	 BJEJ61Q2M28ObMA6dx1f9WSVPT6m3INjTfJobVuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 067/309] tracing/trigger: Fix to return error if failed to alloc snapshot
Date: Tue, 20 Feb 2024 21:53:46 +0100
Message-ID: <20240220205635.308464683@linuxfoundation.org>
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

commit 0958b33ef5a04ed91f61cef4760ac412080c4e08 upstream.

Fix register_snapshot_trigger() to return error code if it failed to
allocate a snapshot instead of 0 (success). Unless that, it will register
snapshot trigger without an error.

Link: https://lore.kernel.org/linux-trace-kernel/170622977792.270660.2789298642759362200.stgit@devnote2

Fixes: 0bbe7f719985 ("tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation")
Cc: stable@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1470,8 +1470,10 @@ register_snapshot_trigger(char *glob,
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	if (tracing_alloc_snapshot_instance(file->tr) != 0)
-		return 0;
+	int ret = tracing_alloc_snapshot_instance(file->tr);
+
+	if (ret < 0)
+		return ret;
 
 	return register_trigger(glob, data, file);
 }


