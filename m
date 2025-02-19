Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C321DFE2C;
	Wed, 19 Feb 2025 08:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954198; cv=none; b=C3rh2fRhGI/lsU3JGHtYWHZm9QDxkdhSAiIu2aRFYTyMbYSarLELHFY5A1+DHPDfe90Hu0qc+Pt27MSEXcUqJmZ20y8P01rwndOUraBPAkuXUGILIpFAkoonWse2V54cHqt6QYbOSlUn60soHWOjcVXR4aaOlZhDALOKHwacnzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954198; c=relaxed/simple;
	bh=t2PEyzhvbN3gmpfRdj2HgxxIJ60gcVA7gkOIzabl03s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXKv/Yo7tm7KVw9HGikKlcvaLpat0A8EHfWjlE7ZMMx3Xkb55ONVsyQ0swP5N+mxS9zZMOhpCga+8K5Wls0T5rOIX+T+K6keFyQ7Hh2WJRJvBo5I4wFS8j/4Z2DvEM46mRiYXnfiN58KoXd6xLxHn+XsObVmmJ1h5TQ8WdOKl3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izaadHUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izaadHUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B526C4CED1;
	Wed, 19 Feb 2025 08:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954198;
	bh=t2PEyzhvbN3gmpfRdj2HgxxIJ60gcVA7gkOIzabl03s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izaadHUb1jvTEzkDgjTCP8RZ8RnUFpTOT+4JwiMsvFBZ/iVjQTN/IaIgYLYhh2uN9
	 2YKcYEmln6Dbt6Zl9rdKvGTz3e3a+CsLh2P04Fv/wCMV37rMKC3OCA3FgmxEQo6BOM
	 LV6YXRwF+lVgcfu8I4tVwryZ9WwYyPKhUeHLldG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 127/274] ring-buffer: Update pages_touched to reflect persistent buffer content
Date: Wed, 19 Feb 2025 09:26:21 +0100
Message-ID: <20250219082614.583289486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 97937834ae876f29565415ab15f1284666dc6be3 upstream.

The pages_touched field represents the number of subbuffers in the ring
buffer that have content that can be read. This is used in accounting of
"dirty_pages" and "buffer_percent" to allow the user to wait for the
buffer to be filled to a certain amount before it reads the buffer in
blocking mode.

The persistent buffer never updated this value so it was set to zero, and
this accounting would take it as it had no content. This would cause user
space to wait for content even though there's enough content in the ring
buffer that satisfies the buffer_percent.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Link: https://lore.kernel.org/20250214123512.0631436e@gandalf.local.home
Fixes: 5f3b6e839f3ce ("ring-buffer: Validate boot range memory events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1850,6 +1850,11 @@ static void rb_meta_validate_events(stru
 				cpu_buffer->cpu);
 			goto invalid;
 		}
+
+		/* If the buffer has content, update pages_touched */
+		if (ret)
+			local_inc(&cpu_buffer->pages_touched);
+
 		entries += ret;
 		entry_bytes += local_read(&head_page->page->commit);
 		local_set(&cpu_buffer->head_page->entries, ret);


