Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207773;
	b=yB4sojVx/Fz0Wiksyw7lNOxC7klimHEzp2IytbykZGEx6kLxTLt9aGKD/pbckLWYRs9J
	 3ZVgNKK994Eq1F616Y0TVzit0TvxSQNi8v+BBa7lB4bXKYVrt0xsB22uNPKskUBszLfBq
	 SaBFPVYiQUL9MOrDGOv4ZbWKYcz9mEC29ZdX7Ni82tYnDKX8uQ77W9XMAEoNHU1Z8XYO1
	 ku+sYbHXtiV8Lv8s7IUx39ALfILS7WWFt6s9A1F9tq6P4gangJjM+sPB2TsmX8h9CLENv
	 mbN3f/42SzWSuzyFH5rkjzDQG96XZ8xAAZ1+3FS1XghCdE0OkGV4dsmoBPRc6YOii7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lu76WtBKHXPuSViSGMXMIt/bsoQ19qFEmOMJecBoWJ8=;
	b=tizH3TonovrLTNmoHUc+0sbdMib2bjkJT9i0JaHThO8B8VNxVw4yUC1q/DMdPeoa7cSv
	 wnzHLUv8TXZSDhTy6ZNSeQ20WaLJO67iESkymQt1dhExi1fqmvrdHZIILUvFOIZjNPdFz
	 NiIfkXbJmEogZGjNSCOWhifQ5wIQcg0L+ZQ4Yje/4eBK/eCJv7qeFlQX1gT0FIc9VakAV
	 zdjf6hBHMigiwCTwjMYJdWhjkb7PlIdSeeOkbFMplEoipKAhsttNUGeNRn0giIvWfC0h4
	 LBWplIUIEQhMPVKlxwLfAaO6Ihw7zn5ZuwpUA9LMqcetAqeANGOSi1jiDDk07F/bg9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hc8SrPgp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5679606A31A;
	Wed, 28 Oct 2026 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hc8SrPgp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230971F01825;
	Wed, 28 Oct 2026 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207772;
	bh=Lu76WtBKHXPuSViSGMXMIt/bsoQ19qFEmOMJecBoWJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hc8SrPgpW8V6/wg12E6hxOeh2x9SDqojUWV9VmDpnejLyraLVoHPQEMnfCOgfgOk4
	 S/OgV7Gf+Yrqc+IAPdeTgTBKGlQyURM7E4EJN7f5X9RMRONabwa04iMvdtWxjN1MyR
	 2J1ORST1hslhh4bmRjgbN/yOG/MoiA04RunltPo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 080/247] ring-buffer: Fix the sub-buffer array base in rb_meta_subbuf_idx()
Date: Wed, 28 Oct 2026 17:58:03 +0100
Message-ID: <20261028165949.287551422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3203,10 +3203,8 @@ static void rb_inc_iter(struct ring_buff
 /* Return the index into the sub-buffers for a given sub-buffer */
 static int rb_meta_subbuf_idx(struct ring_buffer_meta *meta, void *subbuf)
 {
-	void *subbuf_array;
+	void *subbuf_array = rb_subbufs_from_meta(meta);
 
-	subbuf_array = (void *)meta + sizeof(int) * meta->nr_subbufs;
-	subbuf_array = (void *)ALIGN((unsigned long)subbuf_array, meta->subbuf_size);
 	return (subbuf - subbuf_array) / meta->subbuf_size;
 }
 


