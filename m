Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F21A4F68CD;
	Wed, 30 Sep 2026 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789668; cv=none; b=fJlOn0BqV1J9/+o++YkRWyEp6Hw29iGWaqXNOJiFkvOwTp5gYZFJJiWYG27oyKbhNVanw8ccwRRCG9iPwBIWbnyY0JBzAVXjaiNKvoGFbIWsiff/8yR4k99ZGHnP+AoBFreWlgyQLpXW1s8/e0xhlgbiJB7RaYWPuAMvIZn5/BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789668; c=relaxed/simple;
	bh=tsDilJGF3j4twC5Cn9tKcbUj+CN7q9biSMjWU6J5tyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+S1gK4EEAVcCVTpERtYDizBZSHO8VEbrSW7qRo4xJ/ts9o58m/ZPKSzZtoYkPfHBFAtbBBhIHuRZEj0NfHb7RGnb61L0wWOdLiVFcMid+hWnkBaDt5kNRrbh0jly//l8M5H0VffxxAEl9fqcnit8pj8WIbvjilBe3sHg+TCwCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SG5ok32I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SG5ok32I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A201F000FF;
	Wed, 30 Sep 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789667;
	bh=BRklK5cZ7fbeh78gr4udONs2x2k5hVPCNKXZCc67hUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SG5ok32I+mGErW+sCqVY/FfjKdA1HwMaRC3j/8hmwU7LVmkXSZujGAM20C4B40smT
	 NG64r4ut4u3bonv5YVgR9OF3hwMPL4ENlwcT+S/RanvqZrVDFKeGlIvEPGFT3aXvMj
	 IlxkLgru3OcfrT21fqgCostff7lQnZoYYpXBMXpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 559/877] ring-buffer: Fix subbuf resize race with ring_buffer_alloc_read_page()
Date: Wed, 30 Sep 2026 17:24:30 +0200
Message-ID: <20260930152426.704295496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit e743527c5bfdceda1095bc0a9e596e2aebb6a9c3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6433,7 +6433,7 @@ ring_buffer_alloc_read_page(struct trace
 	if (bpage->data) {
 		rb_init_data_page(bpage->data);
 	} else {
-		bpage->data = alloc_cpu_data(cpu, cpu_buffer->buffer->subbuf_order);
+		bpage->data = alloc_cpu_data(cpu, bpage->order);
 		if (!bpage->data) {
 			kfree(bpage);
 			return ERR_PTR(-ENOMEM);


