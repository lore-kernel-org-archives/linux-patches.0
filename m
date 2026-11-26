Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705626;
	b=xFjr+7KI3qLj25QgtPVJJYCrOlgduZF3jWjy7TvUB9Q+65OIXtWvq1B/wsf88g4JaZHJ
	 sgcXRGRe7XGxkyDurNfPa9Hp+uEHndzDloFRfgnA+YlnVQ3mD+hjkXIZ3IH9w9vltH9Bj
	 Qo74Tx3tHt39WSAlhWXdes/7cMsA9q4MNJ+XAl0Y2E7UBUPZajqMig6F3N6qlMhpZYLl9
	 sSbYwccyK6YHU75Z7QzS2Jk7/7HEkY1DpuoFQU9/hGLbWbumDm5gG82f8R57jwknN2vjr
	 J8nS0YNx+E9ElYmjL/lBZkOnU3RIfarcbwMFqeR4pSzkf71SZExBKCpD38d59sDs7Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Edbm/fzpTOjepehE3LaUNiKtXwccvtmat4kPZVEoG98=;
	b=S6QttKlEdLG6Liu4QW5woFsxW7gF26PS79+Xlf3qFclUiNvBdWvM2+yLfTAO5zSLUz+Z
	 amrin0TEsyKELDnja6kiAEzmXke3ptjqwBfJW5Lk+xAKLhdgFqBWeJKVChLSdVw0x07q7
	 J0jX8jVEwVfgU6MBiDvlbDFKQ+g5T8qDYbhTk+jKN7WA0j/IHe/VVTyAaQqzqjUYWVGy+
	 9bW0bTcxR6rl/TE3Uli59r6NzXebryztHBwg8Cca0+5cXgOlGkD7rPgd878w5bcl+iCr+
	 d0YVXn/5f40LDKtw62NLal1VgnjPijAQyD/UNqw5P1uosotGnpfOMObt/zN77Hzpmug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=siWQJ31N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDFE606A31C;
	Thu, 26 Nov 2026 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=siWQJ31N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8981F000C0;
	Thu, 26 Nov 2026 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705626;
	bh=Edbm/fzpTOjepehE3LaUNiKtXwccvtmat4kPZVEoG98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=siWQJ31NMLLEg9M4+qEW4GLnjV7W5XkS+XpUUzt6vaL+pUZk0S/l0OLn1SQzYvwEw
	 2qd2+51NBI1lfSgjRwaS0ALgACs9DNjliU8aDyWeYpIpXfDjR+zsAM50CtjbaiJm7+
	 OMp2plng5mmtzjQ18R6yNpiM2xYZ3NdSfoogRTnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 5.15 259/319] comedi: addi_apci_1500: fix clearing of the gate enable
Date: Thu, 26 Nov 2026 15:40:27 +0100
Message-ID: <20261126144012.594399037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


