Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623591;
	b=gyF1tohVRVwpXkt5OBsZk7rNFm4VHQFsV+AGa13SYQVWQVT4Aztl0dTj7P4+FoTdMONe
	 4VEdgwOzex7Ngbx1iWfzHusVqWfGn87d1jRt9mMGlP+EXbSxeblsn7HeoTHpw1D6ULZq/
	 8Rxbx+pTf7KA3ewzyKZ6limZP2i6tk8/IFO03GQWl+kanMAyJ9eBpI5u8+LxtO+vmFEHk
	 Vk9DLtvZsvQ1jbjEj+g+ECFF9+JuhzPl5opg46Gl0W1zUndVBnnIXLwjiyQyZp2U1FPAV
	 Y4RjLSY1qhMuXTHN5sT6g2fh963BAFVijqk2j2wnbAZodnqLSjYZTsfpZZ7oOZFaAAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9MOn8L8OFZlm4ftfUW4l0P3jl6yRwoDeQYe5GDuJQqk=;
	b=PT5uzPLIjdgaYMU4/cfhS72/FVldQbbEjrxKOGFwk1SkfDTFiIeF+EfydDTEnuee1iC+
	 AO5jW9ldxn55XhdcomQqlRatqvJGLGG7qbdWOXZejWiiClAk5i+CIEyHsEOui0MrLdqvX
	 HmXLwuPFjRv3w2qm1vzgTGY8/i44G5uE9m+ntG7lm0SANdfCVmwlLGAzfwoX9JzMhjKGc
	 hggDuXq39z9ReH2tGVvJymPcHsdr+WuONSYfrTwCoO7jchXEhubV8xtgD08accftATr5b
	 8+jXD00eDqBbb4CyaORFQMJRiN2s8imMbVOrwGtyFekTFwTOib4UAK2IljwHvtCtFSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RWdOw3e5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514D4606A31E;
	Wed, 25 Nov 2026 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RWdOw3e5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6661F000C6;
	Wed, 25 Nov 2026 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623590;
	bh=9MOn8L8OFZlm4ftfUW4l0P3jl6yRwoDeQYe5GDuJQqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWdOw3e5YSBRMOvvTa8KbXshrTUnIg3CkYCgAO2tJDJ8v1f42cThZcSDC9F4zLomr
	 X5+1zKSHnqYQLHdiJaiGsEEZwIn4FyIAX4ZF+hVWBri0tg9sjvr7YE7ExHItsOIjtl
	 WEQKF1VRMa7ctNJrq4MWi90omqT6c0+r3SpgLUPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 882/990] comedi: addi_apci_1500: fix clearing of the gate enable
Date: Wed, 25 Nov 2026 15:37:29 +0100
Message-ID: <20261125143842.676476918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit ade85ceef46892425a08f3ee52ca06729ee4922e upstream.

INSN_CONFIG_SET_GATE_SRC reads the mode register of the counter/timer,
is meant to clear the External Gate Enable bit, sets it again if the
external gate was asked for, and writes the register back.  The mask lacks
its '~': all the bits but EGE are cleared instead.  So

 - the external gate can be enabled but never be disabled again, and
 - the instruction wipes the mode (continuous or single cycle, external
   output, count and trigger enables, retrigger, duty cycle) which
   INSN_CONFIG_SET_COUNTER_MODE has programmed: the timer silently falls
   back to a single cycle pulse.

With the right mask, the instruction only changes the gate bit.  An
application which sets the gate source after the counter mode now keeps
the mode it has asked for.

Fixes: a8c66b684efa ("staging: comedi: addi_apci_1500: rewrite the subdevice support functions")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-comedi-v1-2-1899771ee15b@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/addi_apci_1500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/comedi/drivers/addi_apci_1500.c
+++ b/drivers/comedi/drivers/addi_apci_1500.c
@@ -696,7 +696,7 @@ static int apci1500_timer_insn_config(st
 			return -EINVAL;
 
 		val = z8536_read(dev, Z8536_CT_MODE_REG(chan));
-		val &= Z8536_CT_MODE_EGE;
+		val &= ~Z8536_CT_MODE_EGE;
 		if (data[1] == 1)
 			val |= Z8536_CT_MODE_EGE;
 		else if (data[1] > 1)


