Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E0C12CDA5;
	Sun,  7 Jun 2026 10:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829819; cv=none; b=ZguwhpWkdvmUlFZj1stkZTeVnEesP90P8qsAwsCBf/MCEWaTrOwTYeJYZhnwAM9hnvmaMB565c9shTpaBhd5bLXs8pg9+wpdE0infLnX1506fQbf1S4LCslBfkO3zNUbIqZMxrguxa18aZIbjY1QdXrrniXKZNjVi2vsmYRIIh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829819; c=relaxed/simple;
	bh=2QClxc/yndcg+9eQrGm84UC3eryGi/chh3MGEfK7RKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORW/8Aa8Fy+uing0jA6ubpliJ3oc/serX3ZuVP2LcAI847N2A983d5BaT5/Qw3w+jZ/cDW7bQnhzOA3N8UkUHR9Q73LIynPMRISbVZ9n91Zxyk6qlB8wKEiUxip/+zuwUfK6mJDRCLoOPeEjvCdWEcUX4tskiTWKOvvMbFV5TRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgdYRqqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgdYRqqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3AA1F00893;
	Sun,  7 Jun 2026 10:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829818;
	bh=8TliwwyjX/P7+9QtvYdXmgcH3I54CvQ4ltvcwDsSLv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgdYRqqdPwK9xdrcbQ8w3fj9wC9DUh8UheJyUKoX/8IQZHHq381swvJPCGeM50cun
	 PAo4j5Qu/Ef37bu82UuC4IPdSvp93ZKOd8ABZW6313yK+VJcA6kAvZgSbMdUTdvvlq
	 p2asGKdvO6k9YBxI0UVMVr01q4k64uwVkw9CobQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.12 256/307] serial: dz: Fix bootconsole message clobbering at chip reset
Date: Sun,  7 Jun 2026 12:00:53 +0200
Message-ID: <20260607095737.093155872@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit ca904f4b42355287bc5ce8b7550ebe909cda4c2c upstream.

In the DZ interface as implemented by the DC7085 gate array the serial
transmitters are double buffered, meaning that at the time a transmitter
is ready to accept the next character there is one in the transmit shift
register still being sent to the line.  Issuing a master clear at this
time causes this character to be lost, so wait an extra amount of time
sufficient for the transmit shift register to drain at 9600bps, which is
the baud rate setting used by the firmware console.

Mind the specified 1.4us TRDY recovery time in the course and continue
using iob() as the completion barrier, since the platforms involved use
a write buffer that can delay and combine writes, and reorder them with
respect to reads regardless of the MMIO locations accessed and we still
lack a platform-independent handler for that.

When called from dz_serial_console_init() this is too early for fsleep()
to work and even before lpj has been calculated and therefore the delay
is actually not sufficient for the transmitter to drain and is merely a
placeholder now.  This will be addressed in a follow-up change.

Fixes: e6ee512f5a77 ("dz.c: Resource management")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v2.6.25+
Link: https://patch.msgid.link/alpine.DEB.2.21.2605062259080.46195@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/dz.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -542,10 +542,31 @@ static int dz_encode_baud_rate(unsigned
 static void dz_reset(struct dz_port *dport)
 {
 	struct dz_mux *mux = dport->mux;
+	unsigned short tcr;
+	int loops = 10000;
 
 	if (mux->initialised)
 		return;
 
+	tcr = dz_in(dport, DZ_TCR);
+
+	/* Do not disturb any ongoing transmissions.  */
+	if (dz_in(dport, DZ_CSR) & DZ_MSE) {
+		unsigned short csr, mask;
+
+		mask = tcr;
+		while ((mask & DZ_LNENB) && loops--) {
+			csr = dz_in(dport, DZ_CSR);
+			if (!(csr & DZ_TRDY))
+				continue;
+			mask &= ~(1 << ((csr & DZ_TLINE) >> 8));
+			dz_out(dport, DZ_TCR, mask);
+			iob();
+			udelay(2);		/* 1.4us TRDY recovery.  */
+		}
+		udelay(1200);			/* Transmitter drain.  */
+	}
+
 	dz_out(dport, DZ_CSR, DZ_CLR);
 	while (dz_in(dport, DZ_CSR) & DZ_CLR);
 	iob();


