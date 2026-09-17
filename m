Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690604ED1B7;
	Thu, 17 Sep 2026 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661139; cv=none; b=npxLJ+A1lwU9X9T5PJymg89d+UXfq4FWhvX0XRrRpKCWAztFrEEaMcQkbmb+7mndQcOitCgI3TapUm+H6Y2R4PECJ+2olwByCJfCgPmZ12fNZJzylDKwO/1H80kSnNoEsBIZKRE14cZdr8uYv5vja1Gpdz4XtQAWORzBS9URLtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661139; c=relaxed/simple;
	bh=CxfSAckMZR6fumrHOHYwb5DnYAwX3MhBZcAPFB927V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baawp1bIbGX2T1ervWXWPn/Ee35MdvcLoMl85+E2JL2FdU8/197B1qi1T+RWmLCezNarO75bFHlfrdKkM1loflwuBiEf8XO5zaBq3MJl8vFJK59gLDm0tacG1AJ8vmNOTaFADbtuoQ4pNJiJOUV0YuguXSDQ6kkx/liiwljxoyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcY+xcPm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcY+xcPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848F51F000FF;
	Thu, 17 Sep 2026 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661138;
	bh=SBaowkYSSkCAs5+XQggwvU3vQBo197dLhuCmX8PYWOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcY+xcPmmD8QAYtDdyF8GBzR1y5Skyn+XirHXbmvbNbHSietmuCFbgtaiA8W/6afM
	 B0bao6nHpB0WkDpeAFKW0ToBBeorOVOQu5UX9iSHVpKKXTSGiiu3rDWcuBfyB68Qg/
	 Kavg5WDbf8fM7eH3m58XhMrzRyFpx+5BCljKYHXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Lauss <manuel.lauss@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0095/1250] serial: 8250_port: recognize UPIO_AU
Date: Thu, 17 Sep 2026 15:58:10 +0100
Message-ID: <20260917151554.561405157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Lauss <manuel.lauss@gmail.com>

[ Upstream commit 49fa670efdfdd27e29145cbd2beef065c08717ef ]

My MIPS Alchemy systems generate the following warning during
probe of the 8250 driver:

WARNING: drivers/tty/serial/8250/8250_port.c:462 at set_io_from_upio+0xfc/0x124, CPU#0: swapper/0/1
Unsupported UART type 4
[...]
[<80521d40>] set_io_from_upio+0xfc/0x124
[<80521dfc>] serial8250_set_defaults+0x94/0xe0
[<80520fb4>] serial8250_register_8250_port+0x288/0x51c
[<805214ec>] serial8250_probe+0x160/0x1e8
[<8053b5f0>] platform_probe+0x64/0x90

The least invasive fix is to recognize UPIO_AU (type 4) in set_io_from_upio()
and do nothing, since all parameters have already been set up in
8250_rt288x.c::au_platform_setup().

Run-tested on Alchemy Au1300 platform.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
Link: https://patch.msgid.link/20260430135822.905035-1-manuel.lauss@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index d3ffba16c0f96..9564a5d9b4d02 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -458,6 +458,8 @@ static void set_io_from_upio(struct uart_port *p)
 		p->serial_out = io_serial_out;
 		break;
 #endif
+	case UPIO_AU:
+		break;
 	default:
 		WARN(p->iotype != UPIO_PORT || p->iobase,
 		     "Unsupported UART type %x\n", p->iotype);
-- 
2.53.0



