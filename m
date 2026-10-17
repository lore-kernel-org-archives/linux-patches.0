Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F17138C2C3;
	Sat, 17 Oct 2026 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256582; cv=none; b=XstjWqolidJHfw7C6bPIr0RSqlbzD3t5j/3nv9WGoBr9HEYvr3okgekSH8clclTmOl5fm/LazKb4wkHEOrLpMjNnX0xEKEyo1iTnNzX7sDLB8vX2EZQs1cwzpWaX3axJ+E97ltg5RWKfRvJqPNu2VvNdxxMueoY/7KKAMwe9Cqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256582; c=relaxed/simple;
	bh=gfUNSAOB3CUz1GiqyKzrZ4NPmihq4zqJ3wWHy8i7e8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtDcTqB+5ri6SJDSPXFi1ysbeB7/siHguyVKOt014J7i2W16zROP0V2OkoFhQRcwrlHU7CzRUITjxNYpnEYAeRfaXzaYVIPp9zBq34r/LbjPE6TSn/bU8NRqUaK7GzFqoOSPWYALElT8hE07MR+JStutt0T7WJGuzmc5RjAzoN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQompQZx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQompQZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074011F000C4;
	Sat, 17 Oct 2026 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256580;
	bh=9DMt3kUyN8hLnVdviIV0TrKZeeTaCGF0sIm8SfH/x0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQompQZxsJeg41iKW12l+vhUGkrLl3gj76xOn+OiS0+TntGLDBWKfWZ+njKQ4j+jh
	 jRACD5EO5VfT4LNN99ruipJWmj3IR8EFyJlnGz8rY1i3HGowHEb6wG+cgUQ45qdTTi
	 yNTG4gRcUbPGzZLZeWMiVtA86U3T1CiKcP+JHTPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.6 0282/1674] tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup
Date: Sat, 17 Oct 2026 17:42:34 +0200
Message-ID: <20261017160438.353555058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -986,7 +986,8 @@ static void vcc_cleanup(struct tty_struc
 
 	port = vcc_get(tty->index, true);
 	if (port) {
-		port->tty = NULL;
+		scoped_guard(spinlock_irqsave, &port->lock)
+			port->tty = NULL;
 
 		if (port->removed) {
 			vcc_table_remove(tty->index);


