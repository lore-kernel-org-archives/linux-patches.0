Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623256;
	b=46RUZad5SMVsBxyzjo1/oSxg9Zo21zg5vB0KfIpwELiQK7cPKPsX/28X1BnPdVutnje6
	 0RP1e2hG4rAj4i/G0VPO21+xH7zBF37YBbkgZkzqupjfhcinn65G1XfszcbVQVgkBjpsd
	 ipL1fVgf5Ok/D2e4tbQh8b2qK3uflR242uyN157Kc/dLg2nhkP1P+x/Thun6o7h8bAz89
	 t8dnX0xZiltPLzu2wVve0x0Yf1heTkgN6Uemw4qm5LCNXfFvnDjd/xufHEvVqtHgKyZCH
	 pN0VJakEvTf40hZ7LwCsnGDBiCE5RyD7qkT/jPDksVv6ngr3BBB95y5ohG4HO2BF4pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YIQ38Tph8XVUc55rvxSsvCQgxPiax+l4UINXIJYP+pg=;
	b=kqeI+JpUXiZQJB3sNkI1gGSVCJSi7wciiGkIH8vbloTP6tpqkqavXj+SXz/T8NqRHDwc
	 7ZdmTZL6AjqW2/GRGyQlM3yK0lvFxQhCqzGh+mY980mHH4Blx59PhVktGu3peIBpitG6Y
	 Z1ZQN4zAQ1KpMlsf8hfrOEgxGcyT8JArQ3GwmmypYVNc9qHxqrFUDKjo3ej4i2mSY+14N
	 +9SOHgrrBZuoe3Pr4q2np9dr4iX3v1KGc4Hi/ZmxhQHR/YL3H4WY5ZE6C5SHK/uQ3N16v
	 S9kF/pU8Y6kOE1gN/uc9EJUz9X4LrHZlsJxuFqNTcYEoEOLR4obV/LVn+Ai+gTX/aAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aW6jMS9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79325606A31E;
	Wed, 25 Nov 2026 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aW6jMS9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B941F000C4;
	Wed, 25 Nov 2026 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623255;
	bh=YIQ38Tph8XVUc55rvxSsvCQgxPiax+l4UINXIJYP+pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aW6jMS9j141hNyX4vWUE8ZKq+NiaL7aloc9Gg4y/YdNLNCrb9PyG/fAmx/afhs2jh
	 qYb07rPhQPoCdteUmSn5n8Wz72xzM3en5X9VfTQEogYPIvSCvCp/LrZ8EiB3QfnIJT
	 ouAQeWO0xfgUNrjobHdhexO0J3ixyeffAjPJO0Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 801/990] tracing/uprobes: Fix memory leak of tail in __trace_uprobe_create()
Date: Wed, 25 Nov 2026 15:36:08 +0100
Message-ID: <20261125143840.808013500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit c15120853eebbda98f3fe1f1e59370439c6c4447 upstream.

When generating a default event name in __trace_uprobe_create(), tail is
allocated with kstrdup() without __free(kfree). If the subsequent
kmalloc() for buf fails, the function returns -ENOMEM immediately and
leaks tail.

Declare tail with __free(kfree) so it is automatically freed on all
exit paths.

Link: https://lore.kernel.org/all/179455856197.403392.16569431894958507645.stgit@devnote2/

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-204240@kernel.org/
Fixes: 97e8230f89a3 ("tracing: uprobe-event: Allocate string buffers from heap")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_uprobe.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -666,7 +666,7 @@ static int __trace_uprobe_create(int arg
 	}
 
 	if (!event) {
-		char *tail;
+		char *tail __free(kfree) = NULL;
 		char *ptr;
 
 		tail = kstrdup(kbasename(filename), GFP_KERNEL);
@@ -682,7 +682,6 @@ static int __trace_uprobe_create(int arg
 			goto fail_mem;
 		snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_0x%lx", 'p', tail, offset);
 		event = buf;
-		kfree(tail);
 	}
 
 	argc -= 2;


