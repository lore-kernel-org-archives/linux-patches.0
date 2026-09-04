Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7293242BD;
	Fri,  4 Sep 2026 05:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501216; cv=none; b=NUbfe/FB2J196JkN3NX8F++6az4KIkz3c3E0av0mP55MCnZliNDBCoguB2PxuiKxFjK97YddZVHMQDJjCPIkZPUd5a0XljobBIo649ABDUUEpTytp4QAGIR/DTM+w/AP1gxEknsvDwPFA3ApuPtBTdm4pRtEX1HOfwQH2IqSeZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501216; c=relaxed/simple;
	bh=nyXn8D0Qtj6Sk6HAVppNVatPj6CAIJel7ijqnGofeNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czONpIgaf9jtHSG5MGRpwsz58Bm+uphNK9m42N9Z/GViBIXDS4Bb6ZeaN3NP70V00QBmQUuLpeDX2bXDHUYide2Bx///lC5g8VGu6ySN/6d1EPsZ5HrhSyC0KmRD6ZFiKbIDkikH5gL46oZEZwT3R5hOtR2LPtYBCqL/oZdbhfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwHKsRii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwHKsRii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2371F00A3D;
	Fri,  4 Sep 2026 05:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501215;
	bh=+UsfeNLTZT1x4mgZgvqj3H4cRcMK5accyJsgC720vYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwHKsRiinVZLj7XpLeU54x2BI0Lw+TOf9VZhy/ofVXgeqs4YA2NmGe+KeUHiyznqw
	 x+4jlJo4ggtBxn6l/EznnIY5r9+oV0uzT7n4mtTOGwNVOqVZWFmjlB392qKscbmLqd
	 w3BSLtZs42804UBQioD1OcwNb9WyWfK4go3vDRhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 330/552] ring-buffer: Free cpu_buffer::free_page with subbuf_order
Date: Fri,  4 Sep 2026 06:58:07 +0200
Message-ID: <20260904045757.748194156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

commit 234b1a72e9706fe20c08c96f4374ec8e83b934cb upstream.

When sub-buffers use an order greater than 0, cpu_buffer->free_page is
allocated with subbuf_order. Use the correct order for
cpu_buffer->free_page.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260813131152.3589632-2-vdonnefort@google.com
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260806211306.3704194-1-vdonnefort%40google.com # patch 3
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2473,7 +2473,7 @@ static void rb_free_cpu_buffer(struct ri
 		free_buffer_page(bpage);
 	}
 
-	free_page((unsigned long)cpu_buffer->free_page);
+	free_pages((unsigned long)cpu_buffer->free_page, cpu_buffer->buffer->subbuf_order);
 
 	kfree(cpu_buffer);
 }


