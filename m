Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620427;
	b=pYFB7YpVYcBO/zVgblc0dA7baykyqoUw8x/VtO/9dAr9GESdOUuGhJJm1RmlA1ctIL/n
	 FBQK89i/9Erh5mzDyFgO4xmzsCNSFP+rajxMML5nHKGEi04h74z+DyY/ZhrMkItvMrWrS
	 WJ9x8iKz9NplsgGUALssPbxJPvID9dRqgI2sQbxZfxwxsVEFI29E58OBNJhhWsVZft4PN
	 OO1YvNLNr4iIqgaLRuGOLNgNszbuNYshw35c51TczcJxUqo94xsE5/78fBFvtIdzbypP/
	 YOPhgoAihaAKxDBnN9NXjAl4BGra5lixVBZU+0qnhthkyXLLeeY8IdkuLYvUM0TVtsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rgy2MChxJskzNE0jTKy65U6ceRiZXOnsD//zx3sHGxU=;
	b=H3flib6SwFmdtnZEduV+A+fa5KTsCxwIu3btfkKwh02Qfy7bOBmqaK6IEbwAUTpb6ei+
	 HC8H8fLJbHzz5YEgTCLwErK568CTlF4hKr50rsnp86NedaFnYVLAMRwy4WElsjunRqukr
	 KNSzBREEVEneY1HzpTE69vwBUQr9Gns3Ih5rHKAW9yxH/zuqs93GFGv5AgAFkDUisvgep
	 apWOST4N6DUCmMpOz+IvCYmzWRc0Aby8w0h0jvhM7RUMZRMpMgj9J704fYhJgEiizq8+8
	 i1XXhU5oIUVTuWiAOQcpCC8l39UGZNINYRvRtpmsZl/7aGugVQosswFVLl2U7xpohmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xt9EjGfT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051F2606A321;
	Wed, 25 Nov 2026 15:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xt9EjGfT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AA11F000C6;
	Wed, 25 Nov 2026 15:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620426;
	bh=rgy2MChxJskzNE0jTKy65U6ceRiZXOnsD//zx3sHGxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xt9EjGfTkw0Zkp03nWIejf7zHtINWtqB9zMH2gba5dKPaED/yA0PK3Xeikbk9natG
	 2k/g9ZoNPkRVkeljCfPjTFbpEXZOQgS9RBzkpaku9jpTctFTVKQqT0js2uxIxPqzqy
	 X2uAtyXLYfX3RQlyNYpZZik/4xD/BCnop2MZM1Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0887/1005] comedi: addi_apci_1500: fix clearing of the gate enable
Date: Wed, 25 Nov 2026 15:37:05 +0100
Message-ID: <20261125143842.477579226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


