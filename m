Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212837;
	b=ZRSUjjThxoJpujcbQEGWyFYxHkCnuLksFL8RgicpvzL9CHbs2tC65QvJ82MxHZ+IHyqI
	 Nb59Ffckp96qhdPgjtu/v/Zjx6j3frtz4rR3Pp4eyx2n2kCwYC41Am1PBznGAPqLJwXEQ
	 yAL0n+GB1AS74OKzy+gPKB7JyoaxAtIuqaB9fQ6SVWunRCLN4066nQ3qplijw99/JvM62
	 KxYBTQ4Aqtw5eCFuCKJavCS5JlTf9RLTzL1AJ0Oy4uQd1OBqaLNeQZt8TFi17pcpmRJHv
	 umR+baHDVObVdMkSpn0SEqTEuHLm9Ztk7amLjlh/wvUdJOKsZWKQZfeVut8JAMNt9Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e1EQDh9NOiItDB8MjJH6YZnPmEREAEOvVX/Prb9kX8g=;
	b=igQrmLGwvJogChj/oJOUOWuvxp9ojjbJxMrC24297nPiV3QynTSsLnLRhRCcNiXCH/aA
	 IVtb1vb5rcwuqBGMGEUx/c6INBOpUTlVNt3iVHG1/2Tpc9W/cuD0BhVE1Zn096y1EcEW+
	 cJs4Hi+F2OBVDEyk65T6wD5hmqqPMyx71+XJHa1VCorXiZUfc7Uo0r4uPd7wuJ3r5g3xf
	 97vURkj8Wc2LQl+/W2mpWbRcOiZIWXmlVFfsx++1AR08RV3CKsm3BVmyOa6SSdXaYjhj+
	 g/lCSEDBFkJPQ9JL+6jnYT7lF8lTViSOb90E899AvDlH4O+0XTkbiWezMdmZscj6piQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h9BlyG5H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505DD606A31A;
	Wed, 28 Oct 2026 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h9BlyG5H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC151F01825;
	Wed, 28 Oct 2026 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212837;
	bh=e1EQDh9NOiItDB8MjJH6YZnPmEREAEOvVX/Prb9kX8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9BlyG5HLI+pNfPuGy0EEzj6It54YIKl1yUBEKPyn6xBmrm8r/ZJ1NgcwKrfrE7nU
	 7ASEkzRRN+Kz6Y2abtaCURZxaQe7vwf0j84zzZPXObzA3Q+uj8Z3TcUY6hx2TnhY7+
	 o05ZIWD8oRvvO6ygoH6IlDTgQ7IxzWL/CmLUvkk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.1 0292/1887] tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup
Date: Wed, 28 Oct 2026 17:39:48 +0100
Message-ID: <20261028170505.875198887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 03b49c991abb8d021ca6fe51cd173447236b0552 upstream.

vcc_cleanup() sets port->tty to NULL without holding port->lock, racing
with vcc_event() LDC callbacks that read port->tty under port->lock and
then use tty->port. This can cause a use-after-free when the callback
dereferences tty->port after cleanup has already destroyed and freed it.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-2-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -985,7 +985,8 @@ static void vcc_cleanup(struct tty_struc
 
 	port = vcc_get(tty->index, true);
 	if (port) {
-		port->tty = NULL;
+		scoped_guard(spinlock_irqsave, &port->lock)
+			port->tty = NULL;
 
 		if (port->removed) {
 			vcc_table_remove(tty->index);


