Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049461;
	b=4NRd2aV80alGfoqhW73dibp64cagp0zXNsx7pswbsZat0DYl1OWMvD4WvIaoIzZ3OBcQ
	 W/IkOaDHTVPWxLcNz9BMHv8vW8veC9OkBGSsnGUQZqoj+9h/4pCgR3RsFcB8L2mj/+z3J
	 G3PxveAoycUBSpOu/Yw35vNtl8BKRaUHa6X+wFltYfrhOun6cKyeofkfK1sh6MUqatMs1
	 7bsfbUXKBSIp/sl8ySNEa8A31O7+HFWVFSEjHo9YiFOmZPq1ysbiOA3aVqrcDSj49dih/
	 ABFtqEoZM48dSv667U666wLbosYS/XKivMPMvbqtc+g+I/HJT5N7reUKz7mKrIacvJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=omaeM2ACzWF7nN4kr/k7Gv54M4XMvWmJwrqfavFv7aA=;
	b=faw4mnpOiWx6NEl2bsEdJZFzKg2kwPunmmUrF4xvfmR/cN0qL+ZLrkyDB9V4M5C6wfgB
	 COViW9VyWIFLbmz8OAUB5jg/2J7snFZtZ5sQJ2cqcV+IEQ4yz9gZCI34EpMSiuskI180j
	 WNfyJo/tXY4oJZ83IAAz+EM4zygoNWduJDgvJMEigtfRLjjbpNoFfoxMJGfvma9FY83sp
	 yvUUo74l9ThZVqJN6Owafc5Lzh1hbT0FspSdzf1+BGEv/KHmy8ZekY2x+gK+0Q1YkLGLO
	 od/aF10IIttGieTc0LPRBsHijVcByMPYuhI5M64zDUijWUt8m+hSSkiPB1DH70cwAHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLnmHIhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9E8606A325;
	Thu, 19 Nov 2026 00:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLnmHIhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E84F1F000C4;
	Thu, 19 Nov 2026 00:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049460;
	bh=omaeM2ACzWF7nN4kr/k7Gv54M4XMvWmJwrqfavFv7aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLnmHIhCOtgRcneNmEwWZNcdo3kOXgqntoshO5D1K6INhXCd2rRm17SvLTI3t9GAM
	 +r8UTvrsDnbbNQflUfAZmjPbhB7iZL7dRVIu1unvZqpmzKO7r36wKFgj82UbH3Ke/m
	 i68sweAhDxzHYU66FhAobMCSgmqju5hjykVIJ2Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2357/2857] mailbox: pcc: Free the channel before unmapping the shared memory
Date: Wed, 18 Nov 2026 15:56:31 +0100
Message-ID: <20261118150326.388834881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



