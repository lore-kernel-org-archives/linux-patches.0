Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0382DCF57;
	Fri,  4 Sep 2026 05:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499659; cv=none; b=myebuZBHQf67XgAbHf1j9fKdQwJH2/TI7vnfy0MfMdG4ZHcQfJLg4Xa1IXkaDGR/CIDeu35fQbidXjI2FkNQptyZ/p3oSdSL0SPdRKcFdtlBC2Zc7F2nbaM88Y96KS0FALYuH0p+vnrn9T5eMZBQ/sFH2aYqINCRiQrtFHr4WLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499659; c=relaxed/simple;
	bh=ZTuUrGh81MtlhaUyY/LeupMagdvavlhb5/uHOxnMI/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+FOWiDDlvvzkTSoVGKU9zXi/zye62PGs8kKEDL/8GaOVhYOBPW6uNftM4eM8VPdO9UjxyL2JyabODYGRpyl0bhrb1+2EAyhbYlgHyzZWmG+fjSx810wPH4UiD0dckEGbZ4gBCRyhcKtSAfbyZFBaKB5XxwlaA1ntIWFaEM/Bd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Myy5JBPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Myy5JBPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA0F1F00A3D;
	Fri,  4 Sep 2026 05:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499658;
	bh=ws3SA9+SgxoSpphJNnGEGPK0RAezTD8r4bR8C6usM6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Myy5JBPrpHs0OF8O7vOuHx5aN3akDtLoXC7jiJMam6axb2ssnuNgCqvnGBtFGKl+p
	 kFmZYBOfjrjOdrSPAPsEy7J0oG8JxG0sxllc8CrJQFwJT0fGhnBQJLS6HCyaeXCNua
	 VPGpQ1p/8mmyDvjO2Uzi5T6ubBsz8GW/puAB3i2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 452/713] ring-buffer: Fix subbuf resize race with ring_buffer_alloc_read_page()
Date: Fri,  4 Sep 2026 06:57:00 +0200
Message-ID: <20260904045813.958403674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -7018,7 +7018,7 @@ ring_buffer_alloc_read_page(struct trace
 	if (bpage->data) {
 		rb_init_data_page(bpage->data);
 	} else {
-		bpage->data = alloc_cpu_data(cpu, cpu_buffer->buffer->subbuf_order);
+		bpage->data = alloc_cpu_data(cpu, bpage->order);
 		if (!bpage->data) {
 			kfree(bpage);
 			return ERR_PTR(-ENOMEM);


