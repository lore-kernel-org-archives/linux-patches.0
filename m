Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF97A4F393E;
	Thu, 17 Sep 2026 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660400; cv=none; b=Pe8oJpL0VM2PfQNdtgagFq4u1aQXssrtRQ+Teu5FOvbJMt+Ilm26YDbyo4FnG4X8IPKix4MxMH87dW1+iHdY6gJ5XBSj0Ci85PaKYnxq1T5Q9tsobP4FsgLNU7mf4yPeXBS00pWYR/i6nSNncVMhHWMSZuoFsCU82wklyO5Y0CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660400; c=relaxed/simple;
	bh=gBN6moVPkr9u4R1QyThW0cDEbxw29x4WVQ73Fi+bRf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g44TTd4QPt/AH1m93GXHQWlpuKlsB1VrXARf2vlQhyJ/ycT5NdtIRljgKT2JU/v63dDSYdUpDNHqXlx7YCQIjcVcpTKgNKQKY7owm+g1MQ929tMkS7iO8qDj7nKaHZauRn5/os0nWWj41UCbpu5pRaqFqr5ZRB/nTyHif/lhu6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TF0cdeF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TF0cdeF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7711F000FF;
	Thu, 17 Sep 2026 15:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660398;
	bh=2Q/ZShoec6aN/D2o/7POkVxklaotevaSkc9toTOy+Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TF0cdeF0PFELLr2jYT3RCZAJ+dGLwPiqueaaulgJLr5j0hPTruYsauM2mFnYeKaxw
	 mYt0RP3zgWpXLtM9Shr74sGNb+vuo70fFyh5P1FUt93zyXC18AQhzYB2p0ktpLzfJ2
	 SlC3h4Arcqs6FzNYCky+rKrqtgqj9TBwGokZSfRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 541/733] ring-buffer: Check resize_disabled before publishing the new subbuf order
Date: Thu, 17 Sep 2026 16:14:09 +0100
Message-ID: <20260917151405.709575687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7457,6 +7457,14 @@ int ring_buffer_subbuf_order_set(struct
 
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


