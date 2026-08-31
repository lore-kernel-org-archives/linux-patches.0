Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773DC474258;
	Mon, 31 Aug 2026 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183333; cv=none; b=tdtpHm8Y/F/K7WbLZn+FHWA0mn42k6Eo2Sx75o+HU7r4mibGfOFbBCmElkolcMizTt+xYXmp4/byI6V+LVK5AuMne3smwEV87IeNs1r/CndDEb0+TupQhF8I1Cu7lQFMuZ9n1QgW5O0w4HSwRXoBmj0Ovk7Mv8LtL7sIQ+2nzXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183333; c=relaxed/simple;
	bh=iT40572/qdpEhje0zAkqZD+F85USE+76aUbxnKzlqBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPejS1DM+4erXxKE7QEY2LuDUYWKSSOGPhPLYpy1nf09FcLtM7VNF/RApBmxs4jNsSVe853dtMkTYA0Dsuey+TMi3Jip3jweczd7EYpY50r3xAPW/tPmaSFRAOphpf23gSmgVtiA3B3d6HcWUL+rW1gppDPPdGvwc4As5Q05Yo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fmWToojn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fmWToojn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6241F00A3F;
	Mon, 31 Aug 2026 13:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183332;
	bh=KNrFfeYDmwUesWMPsLDUAa4EhpDeyOxaMh0XZ0qkKDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmWToojnb0vFwNFbXjvXaEAvAz98C+9Xb459IMMN3DToOk3+wIP6x5E2X4sL/TFKI
	 EqVdeMm4vsGxls/vTMlIy9XVPDMVCswLLq4RGxE/ZxQIIkwaYvIs4zeBDPR3zTamDo
	 W9QRnjWwaVA/CYBWReZXjkpuGooCVfSMguRWqR31zmzHD+Bi4D2AD5KOWVCs3fZQ6i
	 lyM/lh3kX6GQ3i1lm6MATzJ14Isdu87I0BQ1ziJsGFPWcw1WUUmcwmYUyQS6kzyg+R
	 EiK3tmUVUXfLiab9FVVFTBJqKZtaV6TO+ESQ9bpR/OzEEFAQfazukJ76DriKdWo0JR
	 QmHVWN7Ih3pgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Manuel Lauss <manuel.lauss@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] serial: 8250_port: recognize UPIO_AU
Date: Mon, 31 Aug 2026 09:21:53 -0400
Message-ID: <20260831133314.4125787-85-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background `git log -S "set_io_from_upio"` search finished. It
points to `2bf95a9bcb500` ("serial: 8250: Fix 8250_rsa symbol loop") as
the first non-merge change touching that symbol in this tree's history —
consistent with the 6.18-era 8250 refactor that left `UPIO_AU` unhandled
in `set_io_from_upio()`.

That doesn't change the earlier conclusion for **v6.18.43**: backport
**YES** — small, correct fix for a real boot-time WARN on MIPS Alchemy /
RT288x UARTs where platform code already sets up the accessors.

 drivers/tty/serial/8250/8250_port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 0c633639f7657..7c10087458bb6 100644
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

