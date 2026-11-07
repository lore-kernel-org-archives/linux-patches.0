Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060730;
	b=406KkUBTukUB4ii+ImNmDg4DoDbApoZWU/suyTMz5YWDxZP3jbb/ZkD8JZQ5NA8p3Dwz
	 pXYvDLzjYjL1uMpQYmYoNuyxMS6KzfYJiK1DUqVT1WveFst/WfHsfvfQRrJEMdBgASakt
	 Ck/bm0HpozqtKDt1xNmoKKCoeWKCIX+zCBwqksyPiJlNcB1HpCPa5p+GSsTNtsG735hVi
	 /WQEkoZsnghFt95t4W7l6FmMuroRgv8lm5UxVhS/eogo3OshwLFJB7QP8D8VNsJYGdYjP
	 8eTebz0RkLF/8Cdyw3f/lBeuGf9uYul8KTB4+fZH0kszLlYfcgUa3jbXAh/L83JYaHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9t2buXN3ky8LF+yNzfVEDFtKtmWKalH7DggeERryT9w=;
	b=KUgTmODwRYjOaoul0MlJdSb2DGaiRzLcmTOOqqk991jUNfX8CSplvp9VgloDSCFzfkFJ
	 BWqX1PPDh3oI5vueDUxOllvhpZuc9+ldEmyZrK6k1kNuJbjcT0O0V2O6368vUuzECIh0P
	 ty4+ELNoV5pmA5nm2JpLk/IoOmHYXyowridEj1M7dkd6KkVYLx5xOxgxGU1hYpZgTPMyr
	 WJFw99UgBiXvRlhQHMlURHWpQV4JU4QI2VaEJKfARXayk+HTyuFUxBJEkwFYbl3FtY1OF
	 n1g9gbQYIoxj+SzdqlvWWakORZQDeRIUOx9xcrMHwgvsp3OYzbki90B0N6i2ocuyVLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jAAMd18A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAF7606A338;
	Sat,  7 Nov 2026 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jAAMd18A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5B91F008A1;
	Sat,  7 Nov 2026 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060730;
	bh=9t2buXN3ky8LF+yNzfVEDFtKtmWKalH7DggeERryT9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAAMd18AvnJDOW+eFPGgNi75UWOYNbeUXZ51/AbrGuRqPoMUBsI5ky0+IKnxS95Z5
	 0CTfi6/P1j1krwjI08l6yep2MXbR02+dyGan8u9UFf7PAFO50NFyxwxl2fHXBKdf1j
	 Ww4MC/rTImQjszE/ZxszIHXTBzXi9cDrJdGlo7E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0149/1536] comedi: dt2811: Fix sanity check in interrupt handler
Date: Sat,  7 Nov 2026 08:36:05 -0500
Message-ID: <20261107135001.870979961@linuxfoundation.org>
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

[ Upstream commit 8dda63825752ab19fcbc2a19ecab91d128112415 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing dev->read_subdev, which may be NULL if dev->attached is
false.  Move the check to avoid the possible null pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-4-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/dt2811.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/dt2811.c b/drivers/comedi/drivers/dt2811.c
index dbb9f38da2898..c2ec5e4fb689f 100644
--- a/drivers/comedi/drivers/dt2811.c
+++ b/drivers/comedi/drivers/dt2811.c
@@ -193,13 +193,16 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
 	unsigned int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	async = s->async;
+	cmd = &async->cmd;
+
 	status = inb(dev->iobase + DT2811_ADCSR_REG);
 
 	if (status & DT2811_ADCSR_ADERROR) {
-- 
2.53.0



