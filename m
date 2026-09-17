Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378DE51AFC8;
	Thu, 17 Sep 2026 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666370; cv=none; b=d7vDX1oapkyaY0n75Ip94X3YOmCAzzzXjRNeIACO+ulDsXpngksQLNBbu/82ozRfDUvGiN2iR7brXn+ZEu9vyGr5H3NuAvfEG8zqu+0PD/WKkGHxEV0pRGjZT+SprDaKay1DezwwV01H7x1Gb/5vAJc4qbDjVKBMpOJoe+6g45w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666370; c=relaxed/simple;
	bh=M7Qt9NrlZBwVSH0RV8GyRXIP8iE8m64ql+74sJF5drg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJhbNA+TZ3H0GOJUc/BOICe6vgx0MDtPGmCP6DfnO8IbLh006LZVbJPtFZOKQYrn5i1gEohYePbb3c4LTDOlfTart+r4Lyxcpq5xHsm3VaMCChkuvwvv5TYUQOhQPMfttXVqy+TDykKJu9VZvEvTCsszCnOMjMmcGW+W3iVy+M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XopqI3ma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XopqI3ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E221F000FF;
	Thu, 17 Sep 2026 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666368;
	bh=Ezn/HziEQ0CslMv90eb+lQQ0DDKTA2RhHfI+YXExpiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XopqI3mazKzs3UPLMf3CYodec2bgcGRihpmt1gYLJPjAkpl4MOsOGahsTH6Mm3+1O
	 loEIzsWW7nm93mqkfFcp417RLHkEvX6h9KVRBcFq6RXQecaAg4d3i9ulkyxfXblOuh
	 LnudGIks0YOnWS3ldX/E9C3OjBlt8NQmIM81c5as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 1013/1250] ring-buffer: Check resize_disabled before publishing the new subbuf order
Date: Thu, 17 Sep 2026 16:13:28 +0100
Message-ID: <20260917151619.504208130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit d860c67c051685abb0460b593b193f0f45f4fa92 upstream.

ring_buffer_subbuf_order_set() stores the new order and only then walks
the CPUs, returning -EBUSY if any of them has resizing disabled. A user
mapped buffer has resizing disabled, and __rb_map_vma() reads
buffer->subbuf_order without buffer->mutex, so an mmap of an already
mapped CPU racing the failing order change sizes the mapping with the
new order and inserts pages past the sub-buffer into the VMA.

Check the CPUs before storing the new order.

Cc: stable@vger.kernel.org
Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Link: https://patch.msgid.link/20260912103938.1127021-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6932,6 +6932,14 @@ int ring_buffer_subbuf_order_set(struct
 
 	old_capacity = rb_subbuf_capacity(buffer);
 
+	/* The mmap fast path reads subbuf_order without buffer->mutex. */
+	for_each_buffer_cpu(buffer, cpu) {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			continue;
+		if (atomic_read(&buffer->buffers[cpu]->resize_disabled))
+			return -EBUSY;
+	}
+
 	atomic_inc(&buffer->record_disabled);
 
 	/* Make sure all commits have finished */


