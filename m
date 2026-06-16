Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCA147A0B0;
	Tue, 16 Jun 2026 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633715; cv=none; b=Nl8rZotK82nRMuo0+KPDMmDa4Az8wQZ0Mk/1P+B9E99heeVRsXdiKdEDWgKfXIUMS7EVpDtxd9UDkJkfjbdnx/q2OW4cinBrTLO7VPerdckZBIP3NaoMcRlzA+8VVcrmBXTkHgqtirlkXzQzrxpYoillmtXeHtnjgGMzjnB9nn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633715; c=relaxed/simple;
	bh=5ZbBR1qNawXc/0gcpekJgSauKENLPPKis99KBMYyOQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCK/v9XdUQrwCZIiehoqrLVpSXQ8ZElm+Yk7Nl6MqQZZ73YDbZdFhIKZdbpUxCZ977KxJoYrGJ0z93G6gKIS1rvQuiNSZY3zbuNbXZTSHQyRIPbX1+TPJ2bRfi0ApUPqoPGCL6hyBWGkIHwjH4O1XgEQdrzLWmyMBNM+hSjXHHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5oSKU7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5oSKU7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C77F1F000E9;
	Tue, 16 Jun 2026 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633713;
	bh=wd6ItSWdVTqCZ49pR2LPe8Pt2s7RAremkbiiyqfvoKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5oSKU7RNPhm9zyLzgVzNukx7hjYAEjZZsovZBHVWd5S15skvXu7FVZg7sy0u2iKp
	 neP1jZ9/yfpopsCRwIF6yWStdbBbhl67p8fKRu56acWerM8/InhK698QwdFkGDp29f
	 AN/GHjeqv7Z98VpMhTlEnwRoEMI3RB4cClpCUUWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 5.15 132/411] serial: dz: Fix bootconsole message clobbering at chip reset
Date: Tue, 16 Jun 2026 20:26:10 +0530
Message-ID: <20260616145107.356168019@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -544,10 +544,31 @@ static int dz_encode_baud_rate(unsigned
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


