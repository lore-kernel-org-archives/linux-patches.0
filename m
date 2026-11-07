Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060727;
	b=vIebgARmXBpaaCu5ATFXxAXXEYwaMGmXcseYGLBxr3DoweUtnM4rJCRbNemui+SOQLpb
	 bkMk3tEOxyh7LXyFZ5LSsSTF5GRus1eKdM/s2gfQVKGickz8yNyz71twuCIpR31rDXBu8
	 /+oJ09OgpXD7UoVifdydBJM6kdVG/AuBo4fodO6c+G6/9NQDMeSJJu9gXgw752xttw/qF
	 yJgEwOlqwS95Xm3so2K/T01Vqgc32GjxLOA5vwj4/uZZwlZhbSZccs6wP6DLRKD1wrMBt
	 038g8GXmG4PvmGnPBbqOZca6CtnrL4s23hxU1RijQnjAuXu1UW70NTENKlDbWgmbDSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LkxkwhK6ml15SiGYODO4v9hWHjKaRl25GiVx+f7noss=;
	b=UYkl+tsqES5v9BR+kr196Acg75Fu0gSZ9jYNArhNZWRwI2ZzYiRoe1LbIQoJv648WTxA
	 7gad33W5R3Md7th3O5NxKhNRp4R0pcjblazsO+HUPo7zmIwn6pfIyLLFOAGaPH7PzKcdb
	 W/adv1NF2JbcitHFCjoeeZVbpWkIH6WvCW+LvrZ5llBGeitSDOJoiVuMxzMPIPXfLYRBF
	 vrUEcFU0nJK8fGZiyJGmc4su7q3P099xWWPM+6IEK2ES0yKwF7Rv4vWIdIeEesB6NuWRA
	 H86zh+o6AHQZGBUmQhdzlHzyIvZsaRN+P8hMWqwaW5bQCRjtM9Adm/uILgUYm9nBULQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zB+BGmpu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F51606A32C;
	Sat,  7 Nov 2026 14:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zB+BGmpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4282B1F008A1;
	Sat,  7 Nov 2026 14:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060727;
	bh=LkxkwhK6ml15SiGYODO4v9hWHjKaRl25GiVx+f7noss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zB+BGmpuaQtGkdoc6hB+ljntKiby4Kd55THBQviWVEohShk77UygiYTtTDDvXKCD/
	 Y8Q81SWQIU3UjVLQre9WckA2Kp9I5fy6meaCDxZV80hzPvjMUmyfocVS/vEPRbNPld
	 ITAgV4af00RkLC3k16ApRajE4ZG24d6pvzr9pwfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0147/1536] comedi: quatech_daqp_cs: Fix sanity check in interrupt handler
Date: Sat,  7 Nov 2026 08:36:03 -0500
Message-ID: <20261107135001.818159936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 1bc9538df6be8dac8727179d8bcc0d880648361b ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-12-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/quatech_daqp_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/quatech_daqp_cs.c b/drivers/comedi/drivers/quatech_daqp_cs.c
index 2a76c75c513b8..d5e3e213e233b 100644
--- a/drivers/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/comedi/drivers/quatech_daqp_cs.c
@@ -211,13 +211,15 @@ static irqreturn_t daqp_interrupt(int irq, void *dev_id)
 {
 	struct comedi_device *dev = dev_id;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	int loop_limit = 10000;
 	int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	cmd = &s->async->cmd;
+
 	status = inb(dev->iobase + DAQP_STATUS_REG);
 	if (!(status & DAQP_STATUS_EVENTS))
 		return IRQ_NONE;
-- 
2.53.0



