Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774107;
	b=qvocCnJidoPvjpgn91Crdq3ukbjkzpHCY5E7AAxHJOi4npCt2lCRm6tcIdBfBtIjEUrU
	 JlQlXRO/lP/YVwY7NHwHqFgFe2j8JjE5JmQ78OapKhQV/9E2/dxbgV7XoRJGACzMdVLYd
	 wPVdwI6l7TklrBQa3ulCXUVGC0d6KS5riKmmdxal3MYZAnMy8M6WyU0v+joSOO2Qr1LmI
	 8oGmiIYeqES9b52LdqSgzQwbP+m+7vwRFdGKFm7w4aS5hCaJzWjpxWKbIG46wCvQSYfVV
	 Us0qsDZF7j/p9FKTPTc8mZAbd6HzZ6w4npxIY5GZyzRSVCpFclpxbT8AuFUlC9Zh62Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ukGM3HkpD97POuSQmX1SNsJG8+3FhvpN1S45/yEcHRg=;
	b=k8cm2pOAHHMrAjodGOPRokdRPJcxT/8+ZG05Gw1YJyoi4l80kncLqif2uNMXEwz6ITgR
	 qloSr7OyIMrzYUo7pbAHY8C3lUwh9+wiJjJDrJxqTHDEMnmQGQAeHwn0/Als61j8sZuMQ
	 J3RSr93DL9+2I0ixQXanww0TFke4VbkPejzWIqOiTZ7BLXN7eS2zVQZ5f2VoswJq5or7Y
	 aCWp3thVymmCCVnAgFJ2s7RWD7aG02nVjRJ0qO6MCgFnybmMsYgS7MNCNVGo6pwSkNYff
	 vXdUEa6OGnl8Nl1JMoCXCh2wLrTFe5k6RGR5mqmFgbvYIWVAdN1TkgK69C6MlflACNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rLx/JW4n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BA7606A31A;
	Fri, 23 Oct 2026 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rLx/JW4n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCC91F01825;
	Fri, 23 Oct 2026 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774106;
	bh=ukGM3HkpD97POuSQmX1SNsJG8+3FhvpN1S45/yEcHRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLx/JW4nnPZ9qKJQ/cKWZScycc8s+rXkMAqtT4lyU1mbHsSjp6ye0SEeUox+LKOwM
	 6BFSUe4hwf10fHUkFQ2/WjKlvWcNVDrw788p7l1mtOYs8mqBLaWEpgAvw7Z6LDHg34
	 ZdXjJ03YYnXdKxa7c6XT2ka4TaSULfn7h1W9Bp/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 096/193] ring-buffer: Fix the sub-buffer array base in rb_meta_subbuf_idx()
Date: Fri, 23 Oct 2026 18:36:13 +0200
Message-ID: <20261023163716.474833795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 25132363c723afc39aace8b098f547ab4a0ea759 upstream.

On a persistent ring buffer, rb_meta_subbuf_idx() can return an index one
sub-buffer too high.  rb_setup_ids_meta_page() then fills subbuf_ids[]
shifted by one and leaves subbuf_ids[0] NULL, which __rb_map_vma()
dereferences when userspace maps trace_pipe_raw.  rb_update_meta_reader()
writes two such indices into meta->buffers[], which rb_cpu_meta_valid()
would reject on the next boot, discarding the previous boot's trace.

A CPU's sub-buffer array starts after its meta header and the nr_subbufs
integers that follow, aligned up to a sub-buffer.  rb_meta_subbuf_idx()
inverts that calculation but skips only the integers, not the header, so
its base is one sub-buffer low whenever the omitted header size crosses
the alignment boundary.

Invert the calculation with rb_subbufs_from_meta() rather than repeating
it.  rb_range_buffer() maps an index back to an address through the same
helper, so the two directions can no longer disagree.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260918071507.1019251-1-donggeunyoo.kernel@gmail.com
Fixes: b14d032973d4 ("ring-buffer: Add ring_buffer_meta data")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3376,10 +3376,8 @@ static void rb_inc_iter(struct ring_buff
 /* Return the index into the sub-buffers for a given sub-buffer */
 static int rb_meta_subbuf_idx(struct ring_buffer_cpu_meta *meta, void *subbuf)
 {
-	void *subbuf_array;
+	void *subbuf_array = rb_subbufs_from_meta(meta);
 
-	subbuf_array = (void *)meta + sizeof(int) * meta->nr_subbufs;
-	subbuf_array = (void *)ALIGN((unsigned long)subbuf_array, meta->subbuf_size);
 	return (subbuf - subbuf_array) / meta->subbuf_size;
 }
 


