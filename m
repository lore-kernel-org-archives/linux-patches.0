Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967823A5445;
	Fri,  4 Sep 2026 05:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501210; cv=none; b=tGtOcKV9Ed2hdPr2NykyPdPeHOcWzaA4NGMx09NDz9S/tAjTqNYHoeq4tj5m7AEAi3xLXFnEJjB4HqbjnkJVU49iRcRBpdTNm2BGCIrzLDdZ1hhT0IaYQgCMgrIho6YjiMyGfJtUUwq6zeaawgYeqZqAWFQbQHAyT56FlCQuS44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501210; c=relaxed/simple;
	bh=Dcna9bXfOQ1ZKvYDeeTl2gyDuCYfGf7nTNuiYImAaqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjLPIQ0deyOgr3Qo7TuAVos5Baf3+KTrtzRDHqmRNkSN6Y6rJf6TnnfmMQRbZlN1I039Ko4oE5vT6w+SNYQKVl0+i0xs89f0XMAulBeQ3mefEx4W/XYbKk4hvdUOYpHAYcmXOXhLBDbFLjnLpIEuwNGpu6YIg4P1F4g4Habypdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxDmHU0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxDmHU0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1391F00A3D;
	Fri,  4 Sep 2026 05:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501209;
	bh=xpVmt8CaMKpGJEasCM9KBnhJXssrUjF4XSXpXFVYgjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxDmHU0luDP2daoLW2HMuggxowl4pjYcpURZRjxyccEuPr3q45hhCVuPWJyKJlOZ7
	 UR5YZLiqVLys03QJprmJTZHkwVy1OcdIkNjKpuT/Xo6bwpbr+6UUffsEtgKsu2jsvs
	 mw4oauZf7iRCYO9ixfEb5VDxhBGryNjLMJFcD2ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 329/552] ring-buffer: Fix subbuf resize race with ring_buffer_alloc_read_page()
Date: Fri,  4 Sep 2026 06:58:06 +0200
Message-ID: <20260904045757.726681435@linuxfoundation.org>
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

commit e743527c5bfdceda1095bc0a9e596e2aebb6a9c3 upstream.

ring_buffer_alloc_read_page() is racy with ring_buffer_subbuf_order_set,
it can allocate a reader page with an outdated order. This isn't a big
issue, the user can still re-allocate a new reader page and try again.

However, what is more problematic is if the value of subbuf_order
changes in the middle of ring_buffer_alloc_read_page(). In that case,
bpage->order might not match the actual allocated memory.

Use bpage->order for the allocation to prevent this race.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260813131152.3589632-6-vdonnefort@google.com
Fixes: bce761d75745 ("ring-buffer: Read and write to ring buffers with custom sub buffer size")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6536,7 +6536,7 @@ ring_buffer_alloc_read_page(struct trace
 	if (bpage->data) {
 		rb_init_page(bpage->data);
 	} else {
-		bpage->data = alloc_cpu_data(cpu, cpu_buffer->buffer->subbuf_order);
+		bpage->data = alloc_cpu_data(cpu, bpage->order);
 		if (!bpage->data) {
 			kfree(bpage);
 			return ERR_PTR(-ENOMEM);


