Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5643B6CF;
	Mon, 17 Aug 2026 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975190; cv=none; b=lyBefMXJamgIUO+MpH16RmcjY6nf9cnkWu5CQPyqUa4UI09MsSwUQ7m1NznhlKLwSz8nAFe/CQN/XftSMseOFUM9a8QAnP9WeydRsPEl9t5WAYojxGl/DpbS+jc4j/BlEkRtckOMm6YAYn/5Oar6zE20P2DYwAaJBrvroH4TdBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975190; c=relaxed/simple;
	bh=xORpE3gRKFcH03RQfQBVQOj3Q0DAmhzKO6o9WnFkzNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPmHG0KaCT/3ZLHUz0nNM+kOcrPxNDYA4gpqdUdLiHJgzvSIxVBu+x7/6LJ2054FDzbMeSxZpAmf/NgGPJLdWW7Hw7TDkOb0fYLDcKzA9RFvpBwUC8E9uxpViLd+xCUtGjM1fe739Fy7LL0Z3/356kPLjBrflv7KPOIW48GpHSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCI9twAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCI9twAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038331F000E9;
	Mon, 17 Aug 2026 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975188;
	bh=2HX+v7fPMJ22eRRWX269nNeXx3y965mflF8v4oiyOew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCI9twAPz5fN3bybAkjL0ASjNL3T+a/fhZn7Btf6pIt1UsJ7oPZ180AuVW1k3r4da
	 PJtoTc+7MU5gZL5LYEJrkwi53kraWo9sPuM47TBDXWTtMBhIBtiJLL9lPYY7Ia3xa8
	 CVUbK3CAiIZEVuYZqXnbKkamzL/7w5PwFUzElWbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e0cc44465d6bae735679@syzkaller.appspotmail.com,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 192/250] ring-buffer: Prevent subbuf order change when resizing is disabled
Date: Mon, 17 Aug 2026 15:32:33 +0200
Message-ID: <20260817132544.408274615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

commit bf98d7b0d5a99991e47e66cee4eb1d3fa514be97 upstream.

Because ring_buffer_subbuf_order_set() frees buffer pages, we can't
allow it when resizing is disabled. A non-consuming reader is at risk of
use-after-free (rb_advance_iter()).

Return -EBUSY on resize_disabled, matching ring_buffer_resize()
behaviour.

Cc: stable@vger.kernel.org
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Link: https://patch.msgid.link/20260806211306.3704194-3-vdonnefort@google.com
Reported-by: syzbot+e0cc44465d6bae735679@syzkaller.appspotmail.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6891,7 +6891,7 @@ int ring_buffer_subbuf_order_set(struct
 
 		cpu_buffer = buffer->buffers[cpu];
 
-		if (cpu_buffer->mapped) {
+		if (atomic_read(&cpu_buffer->resize_disabled)) {
 			err = -EBUSY;
 			goto error;
 		}


