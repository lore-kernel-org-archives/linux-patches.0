Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620025;
	b=ZSTLfedT7Il/8W7PHelw5uddKhu0itQ10zQbrKhk/yQiv+jnRKFiNyvHQEqXdwFpCdlq
	 emV/rFtILxZzJL76iUBMGbaM1sAhG/9H1wBCGWehODM9QiMq8PFARbIgz8p15KZId0bFs
	 h2gCB7Ykc6FfPg3wbsWWkyHRHQH4AClw1T2MIWOEd76PLPmAKHVRj85XiIweeK2BDZDdW
	 QO/0xog9lEsWSYVgkElaVJgGi94vmDMCoW11ICXe6NO7ipJg+v/QEEVDEiS8TYljtOlvk
	 5pM2j6BnRLjeIGaFmY6qc2hi74+UBHWezt5Juke9LDMOVeaz576st3PGw4QyeTLDAQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F1+wQnMhvzNqkkPnfag/F4+VOSfDXYSXO7n9ynf6UNc=;
	b=weJsb1N1oiSk8SYigSh0Q8AAsxL8XZC6xloynhY2Jt5+yAUSLXrDNmMPQo6CTs0jo9II
	 G5MUTbHMgK8aze7e4FZpebizCZlDjNCMi2Y6BS55qD19JfS6szt4KNslcd4lBZqPEHRSh
	 O8gE79djndbkAc2x0nwppB0c/uMomDdIrHufA1mgUowJWNp1adT+Itbv5ZZSolKFNmuGS
	 yJaXPDRugEs4AGst7KCKxPYgwhheXLQnsSafoY2ZwoxiT2HoM1Vm0HOd+t/KQbQyJfF9B
	 wTlwrvFuLDBIQtyo7JH5puWnp8q4OB4jRTkC6yBKLSCL4A303ixBX4n9jNJaGiaEXXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJAV0id4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3603606A321;
	Wed, 25 Nov 2026 15:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJAV0id4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F591F000C4;
	Wed, 25 Nov 2026 15:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620024;
	bh=F1+wQnMhvzNqkkPnfag/F4+VOSfDXYSXO7n9ynf6UNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJAV0id4waS19fcu3Xwy+mNvYh0N2cFSUchfXeLKjinWqdZxVGZBdxMnZpRxcclIm
	 zq7TJI2wlFGDHSLLEbzqrIzVeHi8zor6UGkDb2wIECPa42KDAObSbvGG2cJrtqnLQF
	 2vOfx8qXMYxtMOFtLzYpCFMhSx8/nNVLeSmNOTG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0782/1005] tracing/uprobes: Fix memory leak of tail in __trace_uprobe_create()
Date: Wed, 25 Nov 2026 15:35:20 +0100
Message-ID: <20261125143840.060253059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -663,7 +663,7 @@ static int __trace_uprobe_create(int arg
 	}
 
 	if (!event) {
-		char *tail;
+		char *tail __free(kfree) = NULL;
 		char *ptr;
 
 		tail = kstrdup(kbasename(filename), GFP_KERNEL);
@@ -679,7 +679,6 @@ static int __trace_uprobe_create(int arg
 			return -ENOMEM;
 		snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_0x%lx", 'p', tail, offset);
 		event = buf;
-		kfree(tail);
 	}
 
 	argc -= 2;


