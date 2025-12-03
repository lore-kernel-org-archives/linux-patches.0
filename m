Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE583346BF;
	Wed,  3 Dec 2025 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777182; cv=none; b=IQN5i3bU5a93me192g+cbdMSvQcggPQ7CZBXeylY1U0ABLt51vlVt+JQP9Ybep1BlonpesO0UknbDQhs4WqZg+SpK67z1EpIyQkqQq2r7u6Qd9DvkS4UrGBcHqc+V5Plu/6woWDGsumSCINKI7GqwAssZF/PdnR+zAS+idnN+Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777182; c=relaxed/simple;
	bh=xYC+6AspqE/xLAWuA57+Xcobb2/yVr9N985gGQg8EQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTGJVaw3Y5q1oSxJjcRn/hEmAtwdCo4maTvQeow9XJ8VrPsIAZvIPWJeX5942qAOAGYU/4VEAHGTe2ztEDQN+IX0G4UGom67j18xweOcLpU4v40yxsiTqTi1WJy8NodPSrHFpw4U4h0DNNCT2Bl+QYfaIVA74teJob+hSTDv7hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzbexxdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzbexxdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23743C4CEF5;
	Wed,  3 Dec 2025 15:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777181;
	bh=xYC+6AspqE/xLAWuA57+Xcobb2/yVr9N985gGQg8EQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzbexxdpn8K3DH07bH1xsIWUmXRldn14g/NEvJrQmS6qmdgXBTULR2QLXoGrvlJtf
	 TUHJfw0VuFdAapb3oQ5+IpY6wzty7i/dmsEvGlTllRly5gpzuV+PQc+MtmPlrkRfVU
	 TVKu373illlvjwOrg4szF/hohJhJsx8msgooYyAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a72c325b042aae6403c7@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.17 074/146] tracing: Fix WARN_ON in tracing_buffers_mmap_close for split VMAs
Date: Wed,  3 Dec 2025 16:27:32 +0100
Message-ID: <20251203152349.174529159@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit b042fdf18e89a347177a49e795d8e5184778b5b6 upstream.

When a VMA is split (e.g., by partial munmap or MAP_FIXED), the kernel
calls vm_ops->close on each portion. For trace buffer mappings, this
results in ring_buffer_unmap() being called multiple times while
ring_buffer_map() was only called once.

This causes ring_buffer_unmap() to return -ENODEV on subsequent calls
because user_mapped is already 0, triggering a WARN_ON.

Trace buffer mappings cannot support partial mappings because the ring
buffer structure requires the complete buffer including the meta page.

Fix this by adding a may_split callback that returns -EINVAL to prevent
VMA splits entirely.

Cc: stable@vger.kernel.org
Fixes: cf9f0f7c4c5bb ("tracing: Allow user-space mapping of the ring-buffer")
Link: https://patch.msgid.link/20251119064019.25904-1-kartikey406@gmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a72c325b042aae6403c7
Tested-by: syzbot+a72c325b042aae6403c7@syzkaller.appspotmail.com
Reported-by: syzbot+a72c325b042aae6403c7@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8781,8 +8781,18 @@ static void tracing_buffers_mmap_close(s
 	put_snapshot_map(iter->tr);
 }
 
+static int tracing_buffers_may_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	/*
+	 * Trace buffer mappings require the complete buffer including
+	 * the meta page. Partial mappings are not supported.
+	 */
+	return -EINVAL;
+}
+
 static const struct vm_operations_struct tracing_buffers_vmops = {
 	.close		= tracing_buffers_mmap_close,
+	.may_split      = tracing_buffers_may_split,
 };
 
 static int tracing_buffers_mmap(struct file *filp, struct vm_area_struct *vma)


