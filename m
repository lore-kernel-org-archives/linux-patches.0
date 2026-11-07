Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060726;
	b=v1Et+7dfRZi1datdwmfRMWMaRnanoyuv2/BHXey5KRfxga1Q2fyqvIhgkc5x6KYZ55vF
	 H47rk9puQtltstYaiPeMIrnV89hofKV+08YEt6OCAt2yRn0ljTjscX333yGkbVGcI1MGh
	 KmCxe9eTHYlJ77cu7p/PbsxhON7SDbSCsQLQ42Rzuo5xMhKGLZcTESctMNTGlA21o9O7q
	 RstSNWkDlmV3i//hASWzalPivP1fg3E+NopzqpI53r3hyc4xpb9N262W8lU9S0c75525s
	 rrf4IG8WBXwm9AsNZKUO3PadIYTouo5M1gJkKGwsCNGZDzfhhG9h4iGzhhvefAjNl8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RfySTsVgLbAOzix3KA09LBLuNQHmzHt8tOeGn0PMdvY=;
	b=ru5btwX2qotuVRzvLRzX5CUVPA1SMaW+WVuu3Jr3ecwPGy4jFw/6MpLXVhFGhI0Dc7Zq
	 h7FGX6tZysG6T4fZeXVu7d138VsbvZp/qD5HhRl3Q11zlmIA0Y9V5Ax+j36+CFWcEhJjR
	 gKHK1VB/dXltVeXiHwkG5iKo8CGwGGByjTY1ibUVFZCW39wdYRMscWlUqkZr73tROeajh
	 3TyO0/RLilJZICfKtojfGEQLXUl0dBuQjyncw6H+ioZYkt2QIdQixUjGstZLk5CmDQw7j
	 RjHsoklEnF+I2pMy/MkoTMAVf+hRtW353A6IOyhQcbGz574Q9flHM/MNxf8vQ44M0Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5WAeQkL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53365606A32C;
	Sat,  7 Nov 2026 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5WAeQkL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AB41F008A1;
	Sat,  7 Nov 2026 14:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060726;
	bh=RfySTsVgLbAOzix3KA09LBLuNQHmzHt8tOeGn0PMdvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5WAeQkLtptgGyyxQDq+RhH2FESFAJI8uTeGLmDcjxk5fMC/zKsdx8TF8nUzNsA/T
	 tHs2ho+y5JEYTu7JqPl7XAdRBxfNPufXMIoB9CpGzgJ6JXCu+a1QcpjXBey0VgoN5q
	 CMtNAF5aWKh8zYxQNbbCpJfhVebA+Z2k7JPJDGbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0146/1536] comedi: pcm818: Fix sanity check in interrupt handler
Date: Sat,  7 Nov 2026 08:36:02 -0500
Message-ID: <20261107135001.790354339@linuxfoundation.org>
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

[ Upstream commit 956e8478261a575d1e87490f2e5db1788b8c209d ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-9-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcl818.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl818.c b/drivers/comedi/drivers/pcl818.c
index 06fe06396f23a..e8ce34840050a 100644
--- a/drivers/comedi/drivers/pcl818.c
+++ b/drivers/comedi/drivers/pcl818.c
@@ -534,13 +534,14 @@ static irqreturn_t pcl818_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 
 	if (!dev->attached || !devpriv->ai_cmd_running) {
 		pcl818_ai_clear_eoc(dev);
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	if (devpriv->ai_cmd_canceled) {
 		/*
 		 * The cleanup from ai_cancel() has been delayed
-- 
2.53.0



