Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210984;
	b=JZQLBJh7VoIlwuoKbIqG2BOFiizD5yL/bO7j6DtJGF8CKYQP63J8kDhF+Ke9qgGctZN3
	 /Le8LElrS0Y+LDEQeBS67tc1YFtD9Vc2hgZaa7eJK2UCdi2J75xQokTvAmY6HD8E+wHgM
	 Md8qWufulT2KSDd0oDumZqRspPM23gMYAqEkIey2AHJ16DSHDXtx7VaPeRiAFBKZ9oviG
	 s61NQzJd1BblfizNGYBcdpQToXFErt+PvlZUzXIiK7KmQ+o+Gzud5KZvz8EOq2gwDqbCU
	 h9EygIK6Y1GC/BGMIyihODN9FEaCZhl+CjBbcc3bMYlDFvpbh8xihIBTCjSNQ4bmjmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d6f3aiG9bG80rueTJkbIrC0drBwkFtqyxsLWLVaYzVg=;
	b=1GhyxdpVbG6lPqlfdaMt6kj6NXbPU2idbF53sMxqHoEnj4R9L+OVzkHQVooWKXYyEXYg
	 FupGHAJNnzRemjkOVMfkqRa5pgxzhLwz9JiDHdNjNBVkoSAo3eHTQ2sTwN2VBx90t4YC+
	 HehDXA6eTP0o/Unjwop45R3PoJ1pB5XJbXDaI8EAtx8cmNSI31sYOBPWXcXPBr7gtZCjJ
	 pq1BgV9Ffn/aifGGJAnwVHUKcbX4LiwC225ZaYeGHNYwQ6zoH7c0MstM0MaoB7H8EpNtm
	 PjNazGeeFB9TZ0tDdaYVOc5tfIG0QZBoTvwy7WgbVCb7vMi2+/F105kvLy8xmausTVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GqjEBbag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FD6606A31E;
	Wed, 28 Oct 2026 18:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GqjEBbag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E3D1F031E6;
	Wed, 28 Oct 2026 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210984;
	bh=d6f3aiG9bG80rueTJkbIrC0drBwkFtqyxsLWLVaYzVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqjEBbagLDzXANf+8ebvqw4OazBOqVAcDT7enoycTFu27DSxmb85HjkWsziQz+jmX
	 rxGirhqBxn/RJaBOTopDbDItshyvKAf8iQ8tHbElbHtXcpUqZYXTspdAE9JDyimmUX
	 aa4ixqAcnsLSpSRah39gMgyeoiyiOxVzeaFDEFb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Johan Hovold <johan@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 216/571] tty: amiserial: fix broken TIOCMIWAIT
Date: Wed, 28 Oct 2026 17:56:03 +0100
Message-ID: <20261028170013.127336554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 615f35fd5aee169cc4881a8594f2fa234a4d0bb8 upstream.

A change replacing interruptible_sleep_on() inadvertently broke the
TIOCMIWAIT implementation which now immediately returns -EIO (unless
there is a racing modem status update).

Replace the old hangup (and signal) detection with a check for the
TTY_IO_ERROR flag which is set on hangup.

Fixes: 591cee0a3563 ("tty/amiserial: avoid interruptible_sleep_on")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/20260910132029.D80801F00898@smtp.kernel.org
Cc: stable@kernel.org	# 3.14
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260911090132.723531-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/amiserial.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1144,11 +1144,6 @@ static int rs_ioctl(struct tty_struct *t
 				local_irq_save(flags);
 				cnow = info->icount; /* atomic copy */
 				local_irq_restore(flags);
-				if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr && 
-				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
-					ret = -EIO; /* no change => error */
-					break;
-				}
 				if ( ((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 				     ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 				     ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
@@ -1156,6 +1151,10 @@ static int rs_ioctl(struct tty_struct *t
 					ret = 0;
 					break;
 				}
+				if (tty_io_error(tty)) {
+					ret = -EIO;
+					break;
+				}
 				schedule();
 				/* see if a signal did it */
 				if (signal_pending(current)) {


