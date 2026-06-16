Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2654B33AD9B;
	Tue, 16 Jun 2026 16:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629095; cv=none; b=fSvvbUVMfmZono500yhRF2Ww0uCpoycIPVJ/P/raRQzhZmI7Am6xPQqY1DLc6lBG/KgkAaLgBHq8nisJBEEbDDlQgepejL9qxzJofvMCNd2HBncFC8xmC9K4k+jjiD3d9Ys2H0l7uNr51dveEH9DTisqhb7gJ3Hg2LgDt/ennEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629095; c=relaxed/simple;
	bh=1S0OLtHpC+SYaRNAg14f7VZAI+xNnlbISGQLg/uPwjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8SlvuGPCvU5V4Odmd00AH9nWyrdFc8t0tH2sOkwTV4SNzgRDgZ6zfi4728gTClkWKBN8F2uclEXxH5QBsj0fEYwjIyxJjnm8s/TfZ+NLDbhIUSYP1PkVBhketnpKNwVMe/67zm6HM4xIScl7yPW4uI7KaFNcNYHCaKRKCE0AEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFWk/J49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFWk/J49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A771F000E9;
	Tue, 16 Jun 2026 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629094;
	bh=FhT513Lze4LSsvccWYVZEXi+3ZTiwIQ3G0YnbDgAGbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFWk/J49RCDAIRUFSepjR/Ko9+EjieR+SLel6pvMdKWey72tA8hR+OaaUE/RVzBzI
	 6v7Dv4ASpyZnzBj7KlUNNSpjhj/O+hDAFR/iVgMxFbRt7hdcKiEmyRb48r1DVN5n2+
	 UkbJORd9dh0rkcU4L1QdxKvmfZRzQ6JdC+rOYV4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.6 188/452] serial: dz: Fix bootconsole message clobbering at chip reset
Date: Tue, 16 Jun 2026 20:26:55 +0530
Message-ID: <20260616145127.712805382@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -543,10 +543,31 @@ static int dz_encode_baud_rate(unsigned
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


