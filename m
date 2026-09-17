Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1D5547071;
	Thu, 17 Sep 2026 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671068; cv=none; b=TRaFPUQhtUuD7bhzDpXpdxL/EzD3VMbMG79ZdufUiq2AwYnvtDzYDxzB8UllQAkEm9pnkGDlxFqCZ8x8ZWsu+2vWtENtGbS04x92HDNRYkC5MyvRCwTQfHs5klFFXLId7y8su0/ttJnx7aPgpqLXFlNHxQcXiFfBIh474i9dG4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671068; c=relaxed/simple;
	bh=BGnVSr610TNjUGb1LS6TZAApcCSxX4N5lbb+zY/YoGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ql7/789QN5Kiug7lKeObIytBSCgp2g9VQQzSd4rRwwmnotRbWbUY+fesri01CCCfMlB+lhvZi6imog9CiFXrJSH7q5nIe2rdUQqb2hZOUoKrHOO0TUa60UD8WOt0ioqL0Wmc4Eo3tMb+DVHPd/Vr0Mn5e7phzk9/jQICKtk8gqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNxveBmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNxveBmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE731F000FF;
	Thu, 17 Sep 2026 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671067;
	bh=9O7UkMvXpV+AZMU3RMQ0aF+Rsq9zLjMUkjsnzI2Df2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNxveBmcmlUg7OnUcntpkk3tcCYbPodZCQrex/kZmH3DXne7jm5YGbMBvgZTs9cZn
	 xCMdkeLIU8NUhisHiTWkfVNTzZ4+cC2wzPzIuCx5Opl13gml+zw1J7Ahyfipaiebnr
	 r1KDgRM2whEmt7AUzu5/uSqN+gcmQNXFxE2AILjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 0840/1102] ring-buffer: Check resize_disabled before publishing the new subbuf order
Date: Thu, 17 Sep 2026 16:13:03 +0100
Message-ID: <20260917151601.609492559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6778,6 +6778,14 @@ int ring_buffer_subbuf_order_set(struct
 
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


