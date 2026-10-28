Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207642;
	b=ufnf9GiT5o4O588MG+g22eMUUgUd/D+iUnbx01grsE8HQiJwMm+5XJT6qIJhTWcSpbj8
	 +cnf/PuvPnqgkeeMefPs1dmZ9kDFLp5BNtT7Gx/CghB0DqlohNFHV+QcgwYR5VUnArUkd
	 cl4UryFhK1WHWzwolFnk81G9idlRY8e/XfT3s3HPGmUhsfib9VsflH24zyr1zgk9/9Q34
	 GwaKHkTBewhomVU7XvUB0ubBZ40AUWdvFUjxNRm26sGrvg7K/2Tw6eQhLUFYSQfQHOyx0
	 n1p4nDQ+uGJ/GzYL43lrpPyn7MCv0SJTD5NFrSQtMLVC8bTYjBJ++jjsDoQcOuTlgyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vAfKd2TpMykmsqDbd7bCSenbQzSszUVcWDbHGNmQx+E=;
	b=OU+I16emjTHYdaMp6FlLauXeDNrdOUAH04eAfp0Y48dEuICQjmURzl1QjMCwnCRrgjPa
	 XMgA7BOOXuFbg/Df2myAuov63MphlvfwKorgpwfuJ7BDesfi4fFV63Nmf08MpTmJPhW6E
	 ziPr8QDCkV0shNfZz+eV/ya092VGQxszkS1FHASr2qcL58s2SJ9RKK6t8WyRJ352ccNMJ
	 fmhsVgbEwSGo6khLiLmyRsQXjI5bSa/np459zGmASHhmvvOf3N4qrAmbIfz6QV8M85G/x
	 m2/3+uRpf95lKeNG6HqOpivhQ+MztdNAqKYaHk+VApTvNx7i81o3+8Bq+1xagAKo1dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMsJIj+U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271FF606A31A;
	Wed, 28 Oct 2026 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMsJIj+U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AF01F01825;
	Wed, 28 Oct 2026 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207642;
	bh=vAfKd2TpMykmsqDbd7bCSenbQzSszUVcWDbHGNmQx+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMsJIj+U9+w2+tlj5bS/wGmpmZ48GHZbza9paS7ki3fXF/Wwy+dk+sNS1t+T3JgHf
	 opP55A5R+3tZJ2Cg11J2KmaQx0tjZwPS8OVCZkQXrZQ9QJhgsxDIkk+uWQAk53Teh0
	 FwbaIgq5f1xHE/6XPrJSOMLtnZUH4SDlAZ52i0Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 081/247] ring-buffer: Fix false warning in ring_buffer_map_get_reader()
Date: Wed, 28 Oct 2026 17:58:04 +0100
Message-ID: <20261028165949.310769740@linuxfoundation.org>
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

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

commit 89bab1dba8a0167ef0d819e0f55b6bafa038e87f upstream.

The mmap reader can warn when it catches up with a writer that is still
committing events. rb_get_reader_page() returns NULL in this case, but
ring_buffer_map_get_reader() treats that result as an error.

The initial rb_per_cpu_empty() check filters out an empty buffer, but it
does not guarantee that the next reader page has committed data. Writers
do not take reader_lock and can advance commit_page before publishing the
committed length on the new page. rb_get_reader_page() can swap to that
page, catch up with the writer and return NULL.

Handle NULL through the existing no-data exit without warning. Remove the
caller's reader_page == commit_page check as well, since the reader-page
helper already handles that case. The existing metadata update and return
path remain in place.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260924084946.20104-1-krystianmkaniewski@gmail.com
Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
Link: https://syzkaller.appspot.com/ai_job?id=488adc18-a10e-42d2-a205-25327c38837f
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7358,12 +7358,8 @@ consume:
 		goto out;
 	}
 
-	/* Did the reader catch up with the writer? */
-	if (cpu_buffer->reader_page == cpu_buffer->commit_page)
-		goto out;
-
 	reader = rb_get_reader_page(cpu_buffer);
-	if (WARN_ON(!reader))
+	if (!reader)
 		goto out;
 
 	/* Check if any events were dropped */


