Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80691DE8B9;
	Wed, 19 Feb 2025 08:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955010; cv=none; b=dpxzSHd2lgNM7npCxBB9DYGy5IC+ADooq+MeTvf30p4rU9S5lYJElo1wWUUcBAU1C3NCoBf1So6vExm4jRS7K6amwzGgGJwgQ6b1Tyc03K937S2woKfsaDHBso29PMS9bqLeqFjpCySDL3Um0ASPpFsCbRiW9rzdveCXRGyhDAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955010; c=relaxed/simple;
	bh=1qvL6jb6p5gl87sSwPJBatf3HOvby6psGRxjWsKy6Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbpYvtyqoL7eORXqozMgjqdZzqetpHfJ6ddRZYdNHYmFIOnSqpHk4ofc9r4fq8j6FrWKIPROvYW1X4qjMps3pN9rks7ChzNT2h2Qnd2q8uiZLQFvR4en4NDLhZuQxBt89pj/SwMJjYh/ADIBX9bg6UmREOYTxfwWwWvFVrtd0EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbWEuY1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbWEuY1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41726C4CED1;
	Wed, 19 Feb 2025 08:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955010;
	bh=1qvL6jb6p5gl87sSwPJBatf3HOvby6psGRxjWsKy6Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbWEuY1R8ktroWXsM6NoNXXIpLcTYyoYkwReLIDjh+OBPNuAYsOWMaMCtXQNPiEws
	 kcFALbFk+zS0KB4rujCklCkcDjxYw4eBOagv/U6y9i6pskIH2gD/Y44qEAwyRcMMIb
	 +qX9Nv7MQ22xl7l81LDJ4rX282WfOSsEfCMkKYIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 105/230] ring-buffer: Unlock resize on mmap error
Date: Wed, 19 Feb 2025 09:27:02 +0100
Message-ID: <20250219082605.800691181@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 9ba0e1755a40f9920ad0f4168031291b3eb58d7b upstream.

Memory mapping the tracing ring buffer will disable resizing the buffer.
But if there's an error in the memory mapping like an invalid parameter,
the function exits out without re-enabling the resizing of the ring
buffer, preventing the ring buffer from being resized after that.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Link: https://lore.kernel.org/20250213131957.530ec3c5@gandalf.local.home
Fixes: 117c39200d9d7 ("ring-buffer: Introducing ring-buffer mapping functions")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7157,6 +7157,7 @@ int ring_buffer_map(struct trace_buffer
 		kfree(cpu_buffer->subbuf_ids);
 		cpu_buffer->subbuf_ids = NULL;
 		rb_free_meta_page(cpu_buffer);
+		atomic_dec(&cpu_buffer->resize_disabled);
 	}
 
 unlock:


