Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060736;
	b=36JUnlFfazhWE6dIdKyeVHtWQZhftyt6ehZAv7e55UGMAeDfKMK1eQs0KvqYVSJDzNtA
	 zGA5PFDt0w67njX77Hj1alkchEPK+fGDNrAD9dj1NgkoR/GN553nmruNL1y1lO8NUj2b+
	 wkCUEkobJ30OagnuJBVnjOh5JyPi/pLvmX4neCK6PP9GWxnjAt9s3vxI2IwDw3hakewcu
	 Y8Bdkx4O/tlkDlUXqq5G54OIhioZYWxJxsR/krZIeYByPUwe05NDcDBA8+LKcCvDmt0ph
	 +dEmiAnPslYU3xQPpg0aibQzCMPoRkTzWrk4heBO88zrjFPv8n5ZypTXBP8kJ3sc2kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EIPQK9poUDV/4nsKGt7CrfGiR18m/cpCJ5t6b+Mxi3M=;
	b=jpfdIId11gM6FaHZtPX2RYFi9Aym7Mmyui4uj+5mHewnCNV5yR4IrelJfeMH8J8aoncJ
	 dcrFqF+HBC5f/WY7Imqz+6kDubOyxdCFjVTZSlqRQUAAkhh0Nx5vJMNojbheNNl7IiYUr
	 aCEua3wfuQkYDQYS+SJsriBVdbYL7Pg6juXoqpqE7FgUYLP1UIYKGWPktBe9iE41WMbHY
	 Nl7BeTr42gb3STXdT6yeB9FRsT8Ta0B2ka+/Vrp46uwd9M4b4xeie40D2lUHDfVBX5zZ+
	 C+so8wckgyH78SWp4GMqdoiLznTH51/lJ/hmgMEVTrgixCsEeWIcUTkE5afXpw0oUuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uT+EAbrW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55426606A326;
	Sat,  7 Nov 2026 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uT+EAbrW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A2D1F0089F;
	Sat,  7 Nov 2026 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060736;
	bh=EIPQK9poUDV/4nsKGt7CrfGiR18m/cpCJ5t6b+Mxi3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uT+EAbrWwyzDHmajyqFyUmJyOTJKGIDf0XLj6o1vrK2ZjishBCwtzzW0CSVZq6Te7
	 xMsC8k8lf4ofJNT6mc4DnGEPi0n6vvFn8hIqMJIvoiUp/re8sp60HldauYF1vX9EuT
	 5XX90MaytHx46SUk5bNCbxta6E4xfMyJqhHQEU88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0153/1536] comedi: pcm816: Fix sanity check in interrupt handler
Date: Sat,  7 Nov 2026 08:36:09 -0500
Message-ID: <20261107135001.977469591@linuxfoundation.org>
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

[ Upstream commit 4fdac5090ce3616283216d9a1d2b9664e8e20747 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the devpriv->dma pointer which may be NULL if
dev->attached is false.  Move the dereference of the devpriv->dma
pointer after dev->attached has been checked to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-8-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcl816.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl816.c b/drivers/comedi/drivers/pcl816.c
index 28d1a88c50f65..3c295647e2ed5 100644
--- a/drivers/comedi/drivers/pcl816.c
+++ b/drivers/comedi/drivers/pcl816.c
@@ -242,7 +242,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct pcl816_private *devpriv = dev->private;
 	struct comedi_isadma *dma = devpriv->dma;
-	struct comedi_isadma_desc *desc = &dma->desc[dma->cur_dma];
+	struct comedi_isadma_desc *desc;
 	unsigned int nsamples;
 	unsigned int bufptr;
 
@@ -257,6 +257,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	desc = &dma->desc[dma->cur_dma];
 	nsamples = comedi_bytes_to_samples(s, desc->size) -
 		   devpriv->ai_poll_ptr;
 	bufptr = devpriv->ai_poll_ptr;
-- 
2.53.0



