Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031408;
	b=sDtcve416aLLyyMVC55d162BuuOohM1eg10soiOjShLRQ7lhrFb+JF9pXfFNjglWCqY1
	 ECyncNoX75laQ9OijnoVgHCuXBNiC3DEz0g21xNEQvgc5i7ZwZSwq911ViQoyCBFV20/9
	 G1q0NoYfx0yyy8z4/31ufuEgW4xNSLEdAa82+/9OcKZtGk76PvbzQiICvXSZNLOl0Lfoe
	 EwqXmJqY6VvRYf7zsjdPG6XgNfeOGU52tw3BQEBin5fdkAQkXmivStf7W4pGpno1w1/Px
	 sfe/+XT4KKHSbJbM4UEJreyBX1PBXSEN4k8i0bDtyUzjrEyNm0+K/KUQjSkB6vJMh9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AbyESzHVfI286MSAHw0sYJ9JzJzGfOiqNAaeSvhtYh4=;
	b=c3kbhrFpNLr+dnBFTPFnpdWxSTj0a5qibl2VlJnjnjRbZUST58opVeftIHxjjvLXE48b
	 KkuU010ipTSw0gApPWKucQkQPLemL+kiLq+lD4btzSjPRY59rjSJtPtR+XZJYSFVn1CjT
	 MSsgPSzw7DIupH2+qHI6bXmSK7ccBKjut9S8gg9ii/ijHeoS+tVCOn3GHUbwfTkQCf9I9
	 O78w8MvxO+I61mJo5ToVKdxeTe8339uzXpsFi9/erUezuTnb3a6e8GfBZKQgZqjdNyC7R
	 2G6EFNzRVbkCaZAFKto+gA4unq5HUokBv+LsQ7VlRYgGyKnQY0Ms/Nmi4UbEe8i2t/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=paOfqLo5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5F2606A32C;
	Wed, 18 Nov 2026 19:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=paOfqLo5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DE61F000C4;
	Wed, 18 Nov 2026 19:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031408;
	bh=AbyESzHVfI286MSAHw0sYJ9JzJzGfOiqNAaeSvhtYh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=paOfqLo5PRcVuMcWGbfd4q0Fwps2+vedPLceEsYXND4mqu2eyM9WgYDZjzGeAOzDa
	 GrCSP/WHZODya8wac7HCn4uHdyDNnnKnX6aY1ii5HlseTKiIzKE8/yp/Bj3QClx6h8
	 3wq05gSoL6dUXPj18KkWcclKuYDzzBgKtDB7Q4gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1047/1756] mailbox: pcc: Free the channel before unmapping the shared memory
Date: Wed, 18 Nov 2026 15:52:54 +0100
Message-ID: <20261118150051.745326882@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4ac21f3fac3e8584fd395c59044a8e99ac618572 ]

I am seeing a crash on PCC that is related to a an shared memory being
unmapped before the IRQ is disabled, and the IRQ kicks in and hits the
unmapped (NULL) address. This is a summary of what I see on my box:

	scmi_protocol scmi_dev.1: Message for 1 type 0 is not expected!
	Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
	 __handle_irq_event_percpu+0x1c4/0x9e0
	 handle_irq_event+0x98/0x218
	 handle_fasteoi_irq+0x230/0x750
	 generic_handle_domain_irq+0xac/0x138
	 gic_handle_irq+0x344/0x740
	 call_on_irq_stack+0x30/0x48

The trapping store is iowrite32(SCMI_SHMEM_FLAG_INTR_ENABLED,
&shmem->header.flags), a write of 1 at offset 4 of a NULL base.

But, back to the problem, pcc_mbox_free_channel() unmaps the shared
memory and clears pchan->chan.shmem *before* freeing the IRQ (aka
calling mbox_free_channel()).

The interrupt is still live when the mapping goes away.

Free the channel first, before the memory unmap. mbox_free_channel()
calls pcc_shutdown(), which frees the platform interrupt, and then unmap
shared memory.

Fixes: 7f9e19f207be ("mailbox: pcc: Check before sending MCTP PCC response ACK")
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 6efeadf89db2b..69e545468674c 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -422,12 +422,13 @@ void pcc_mbox_free_channel(struct pcc_mbox_chan *pchan)
 		return;
 	pchan_info = chan->con_priv;
 	pcc_mbox_chan = &pchan_info->chan;
+
+	mbox_free_channel(chan);
+
 	if (pcc_mbox_chan->shmem) {
 		iounmap(pcc_mbox_chan->shmem);
 		pcc_mbox_chan->shmem = NULL;
 	}
-
-	mbox_free_channel(chan);
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_free_channel);
 
-- 
2.53.0



