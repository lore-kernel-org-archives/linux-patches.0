Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590680;
	b=X6UnbLx18Fz28GpGqiA8u6xu/GyAGhl40oE/51n/+QWqL44aLR2juXFpl861N1NzjBuV
	 Vk1FI0kBQuqX9GlwM+H8MjoSOtYK0pkj/2oLkBnCPLvCNuZKLhm03m2rrOf0Ijuclwjen
	 tRDXnn5ooQPgJyZYzxP+7HVQYsw/c2as1q9J8mjqj/FV+z+HfGlOzrjpAv9PrSnYL0eoM
	 gkdIdkZA+gLa3Qj7gpZjgjgCfiQk2AWCg8hs54YtQbVflVU05UnnCG+j+aX534WzcWP4z
	 8MNrrAWXQUWssK0QCIhRCI+XX56o+FHVInLnnFWFbEWWXV2XYyh9raEG1c9T63B1CVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ra12T56MxGrDqO3TNgP1PboiMixRN73gqHkdCColh80=;
	b=1Yzv/AMVKPqK6N6J1uF0YkPtdXq+jTTr6S6/+HVuVR9svASA8ngPICJD5xuLjBZKDJ95
	 4ra32q1U148Nhiq/8PovvtarRpG7o+JYIhRHvw2zFTnfaP9yb80z6yqSQErk49PndAA/N
	 aDI63TvmB1EwlmGWYE/LRmMIx/zmIg55JMHUGGklHM9XzzK2bnGTuB8GJ1mcNPBtCVqtk
	 U8s0AcGTUFzDLABqOPGbhfyitYFGWFRylBk53H1P87jsIfDDuqBHI0bbL4fXBjTlv4oEa
	 Gg1EXaTYF6zBDup+/BRPJh7wIa6LmaOoHVQLdqcv/RbO9tBXtIRiIz7K8CRI0S7Kqfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoHMVjbT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F38D606B223;
	Fri, 13 Nov 2026 17:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoHMVjbT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05E91F000C5;
	Fri, 13 Nov 2026 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590680;
	bh=ra12T56MxGrDqO3TNgP1PboiMixRN73gqHkdCColh80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoHMVjbT2zx1iPgA/xEkukXzzuEAPkIb1nnPr1b2HpWtYf1rxgdelzfos1XLsIJPF
	 HkwqgmSjx2cDVd4ZCTMlVoMt47hwb++0Y2+vmtW340JllS7DUZMlzyS4Cfn4ZyNli/
	 YV+aPpytz2nmzJb3q0Rcp1Ee8J/YEN1L5nxdFyfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Fuzzey <martin.fuzzey@flowbird.group>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 593/686] serial: sc16is7xx: fix data corruption due to unexpected xon/xoff
Date: Fri, 13 Nov 2026 10:52:06 -0500
Message-ID: <20261113153842.049432661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

[ Upstream commit 8bb50e95c0abd44607bc60a43032c1dbf7470d5a ]

The hardware supports automatically sending XON/OFF based on the
FIFO status and that is already implemented by the driver.
However that capability was not announced with the UPF_SOFT_FLOW bit.

When the port is opened with the default of XON enabled the driver
configures that in the hardware.
If userspace does not want XON/OFF (which is normally the case) it will
use TCSETS to disactivate it. However the serial core optimises this
to only notify the driver if someting imporant has changed, and for
XON/XOFF thit is only if the  driver declares UPF_SOFT_FLOW.

So we end up with unwanted XON/XOFF in the data stream.

The problem only occurs if nothing else needed to be set by termios,
ie if the user space requested values are the same as the default values,
except for XON/XOFF.
Since the default speed is 9600 this means that the problem only occurs
when requesting 9600, otherwise the call to the driver will be made to
change the speed, and that will also clear the XON/XOFF.
As 9600 is quite rare these days that probably explains why this hasn't
already been seen.

It also only occurs on the first port open after boot since the subsequent
opens will use the "logical state" set by TCSETS but not communicated to
the driver the first time.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@kernel.org
Link: https://patch.msgid.link/20261001100534.1225894-1-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: applied the flag change in sc16is7xx_probe() instead of sc16is7xx_setup_channel() to match the existing initialization layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index b5e301741b844..870b27973a7b1 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1650,7 +1650,7 @@ int sc16is7xx_probe(struct device *dev, const struct sc16is7xx_devtype *devtype,
 		s->p[i].port.irq	= irq;
 		s->p[i].port.type	= PORT_SC16IS7XX;
 		s->p[i].port.fifosize	= SC16IS7XX_FIFO_SIZE;
-		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY;
+		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY | UPF_SOFT_FLOW;
 		s->p[i].port.iobase	= i;
 		/*
 		 * Use all ones as membase to make sure uart_configure_port() in
-- 
2.53.0



