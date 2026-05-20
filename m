Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855B73EA953;
	Wed, 20 May 2026 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299827; cv=none; b=TMkbc0UPBWJNJqROcP/MgZLeNmHX+3Cyhk9cppFg3KZdML0tJtekUydtYQ0f5bVx/nmbyi/EIM4rGAzQYYXt1PXBWsus5r+e53V451H46ztgWXYJ+J8jBecQrD5e25pd2EHKuLIMdy/to23ZLY9p8QpfD7B+t/2nZrKUZ/M/JxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299827; c=relaxed/simple;
	bh=2FD0up+NOTfFU933Knh+IMt/9B9GeB3FJINEBtzR180=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkq4KKGUHNrPa53igj+ZRYKb9xYG35LwfKd5o95IMeSPDUICxkqZLs7VUDMHA251CrP9qwO7XfjylGhajGbAWoxpHlj9ApPKdisGH7HODYbD9VzWsbJ5zdauweJgvzI7GmFN9sMxyK8OkSv62i3GsxY1OmuiH3rKCIcRTEVI9Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjwBdpga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjwBdpga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813E81F000E9;
	Wed, 20 May 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299826;
	bh=THxiQvugvMrfYQJOMMu81HmOjCqZT5/3rufF02yEhJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjwBdpgaZdShbeZct8jIHQE6kb6UcUNQSYZ95HadC+QpNwk/B9TIAJ0dunezTLbpJ
	 DWEzU6L1t51/w+SWo+NVsDP9y+q0C6iHCArcdhkyz9L/0S1Szc1H28ZgZNRyKq4k+V
	 /iP7h8sgEX9sNeOkytb0AX/A+pKf3vlPLVXlF34A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuriy Havrylyuk <yhavry@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 902/957] nvme-apple: Reset q->sq_tail during queue init
Date: Wed, 20 May 2026 18:23:05 +0200
Message-ID: <20260520162154.136453462@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Nick Chan <towinchenmi@gmail.com>

commit a6ab75639e23169a741b0b2e12191fd8acb32c73 upstream.

Fixes a "duplicate tag error for tag 0" firmware crash during controller
reset while setting up a  queue on Apple A11 / T8015 caused by stale
entries in the submission queue due to an invalid sq_tail offset after
reset.

Fixes: 04d8ecf37b5e ("nvme: apple: Add Apple A11 support")
Cc: stable@vger.kernel.org
Suggested-by: Yuriy Havrylyuk <yhavry@gmail.com>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/apple.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1009,6 +1009,7 @@ static void apple_nvme_init_queue(struct
 	unsigned int depth = apple_nvme_queue_depth(q);
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
+	q->sq_tail = 0;
 	q->cq_head = 0;
 	q->cq_phase = 1;
 	if (anv->hw->has_lsq_nvmmu)


