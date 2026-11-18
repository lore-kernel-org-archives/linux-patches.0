Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052644;
	b=OvxDg8x6oK78C5m/pFmo7yTSGQVdoXm7HVD4aed1/ooaKEonh6Degcdbc8UZ6Sj29rhh
	 s5u2psqZyEnkEAvROfb6UDjFwK52KDZdMVPTVysaKv2vsTiTw5xHvP2pZPDLNOdQJ1Xra
	 JiQWqBx6gi6m69Xz66VdWY2vlxBXm4pLAf7vDQARXZ0mSR7/JsDDhGG0vfTc9WHbzaIkS
	 msct0JMV6m9lEO2R6NkYd1t/E+62kaKTN8WbgW3XSDRpt8nwVNnEVpLv0sRGHXT4NcU1m
	 6c8cyaP6M3Dq9OQoPMVVnsVodsdO5M/Xc1KpV1RcM5ty0ngwnBRkHfT76CiflV1TBbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zn5fcZzLyeerA983SQ1kwaoJy/WYfxM4b0KNJOWv/L8=;
	b=WjY+hvRvDiBNDW7wF5SXdLLVrciSxJ0yrEhXeTYlv9qrxY7aw0V8eMIO6au+EhyJ05tj
	 Netta+3sX8RBbsydBGmuQ3tknkJfJYe3k/cttl37hmBD5oJvJic5lVg2G5QdlPPdk1ED6
	 MhRq7Yvg4Jthdi3QrwXy2v/0wwm++18D2DAu4U/4d6Ec/5pckCgsuQnsrMmNA18+SMioG
	 jqeJ/bazzdnjKYELJlJnXhYEDF26xjP6ZXKlIeJumSxToturKJtkv9MeY31I1sfxMjNhJ
	 vj9qy5VX5FzWYiMFbWVqKsOnEThmvtoh4nhLwkKJhJq1If+qqHYaaTczY5F/0fRR27g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRy3hP70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BCD606A320;
	Thu, 19 Nov 2026 01:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRy3hP70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DC91F000C4;
	Thu, 19 Nov 2026 01:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052643;
	bh=zn5fcZzLyeerA983SQ1kwaoJy/WYfxM4b0KNJOWv/L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRy3hP70vP/3GDDUDkcX3JN94d1XEisjnkBpt40nZp0Wrmu+Z6nHlco4QLdES3feQ
	 LxCc9P1rBQW4NpJAw8C/K92dB2F/A3Mwe7eN1Dt+ALObg1qkEPpwtJx8BcHDhkjtkt
	 fmwujznxbQCden+MdMm7bnPWUcsmy2PNNvhGGvMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0638/2214] serial: pmac_zilog: push received data to the port that received it
Date: Wed, 18 Nov 2026 15:38:34 +0100
Message-ID: <20261118150036.858015643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Tim Douglas <me@timdoug.com>

[ Upstream commit f3dc727da3af64abc12b625bbf1eb68d55d882cc ]

pmz_interrupt() drains both channels but, since commit 2e124b4a390c
("TTY: switch tty_flip_buffer_push"), pushes the flip buffer of the
port whose handler is running rather than the port that was drained.
With both ports open, data received on the other port can be left in
its flip buffer until something else pushes it, so its reader may not
see it.

Fixes: 2e124b4a390c ("TTY: switch tty_flip_buffer_push")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013013541.4535-2-me@timdoug.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pmac_zilog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index b2eadbac013e9..ad67608b23901 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -455,7 +455,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_a:
 	spin_unlock(&uap_a->port.lock);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_a->port.state->port);
 
 	if (!uap_b)
 		goto out;
@@ -480,7 +480,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_b:
 	spin_unlock(&uap_b->port.lock);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_b->port.state->port);
 
  out:
 	return rc;
-- 
2.53.0



