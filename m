Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D320F1E048F;
	Wed, 19 Feb 2025 08:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954187; cv=none; b=RoSstNvHp86078ADIeWj7Y7h6NlLaML4eOaVBU6LV5BWNrZP2/T6CAdJyo1Qn2t8wEzeiSII/3JbBVbl1mZVsp8rE9wr3Y9JDoxkhb3ZEH5IoxTn5p9iEkf92JV+MO0RLVlULWDL+kuNFP7Zeu8E7sD10s+Ly62qDCAC1019fZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954187; c=relaxed/simple;
	bh=egF+XrfpQ/nSvr2skaruFmGFzgUmR3m2loLwbEXfG5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttqpba1hj3cnEf0DyrrF0L+ATTfaKLir73ZIAI4MotnK0GoVNb9Nsux3A/VqvbHlF4J+bcLaXj+HW8rvB3GAckw5ME46y4p0H/88VgzlIqkLMEuCsJl8B+IT/cX4goRtge4X2Fm5Cq09XMLBtZ0uipRVOauToGg1NtOtRtBe3S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqm5LuxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqm5LuxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8A8C4CED1;
	Wed, 19 Feb 2025 08:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954187;
	bh=egF+XrfpQ/nSvr2skaruFmGFzgUmR3m2loLwbEXfG5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqm5LuxU/HHKn1KW3zTwr7Xqt9BYZYuLpwft38QzgbwYhmTSgCfvXximT2spgNf1k
	 HF6jhSNPZElP7fHyuRJtqRznT/wCM+0zWMbt8UySARscfy76EljiMNcQdGeMjJ4P14
	 EWm4f8v4dc8t/NFjHz9e9ck/rFndtrB9PDPawvH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 124/274] ring-buffer: Unlock resize on mmap error
Date: Wed, 19 Feb 2025 09:26:18 +0100
Message-ID: <20250219082614.467977216@linuxfoundation.org>
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


