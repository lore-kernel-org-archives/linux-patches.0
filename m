Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6214E4E73A1;
	Fri,  9 Oct 2026 14:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556219; cv=none; b=KT+bq9CUrVS4v3tYnPtfoXjZMZPQMDG6tYw6CipfUztrNi0ZlpDdPcEk0Ivt2BoBEDUep60eAxIwXQUCc/Abhkg7au0F7aP9HID1EBzLtvwqUw7c1nSxednZNSzbmABhHgQUR4cKAe3Yv52on9sZAfeklHJykg5HcKz6qTYuSHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556219; c=relaxed/simple;
	bh=arl7S9E5+NL5Ef+vgyIPYL/lPUD2N8uhkAubv7uQxAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyUVHy66j7wL6nEtmW7vwYkCxMeqI2Ck8y91zB9eQDPfLx8RmXn8oPZ6iQxv3lNoRDhw53x/z+Ai672QtKr6TSE5fHgk+2Sm3wLLI3TPP6k+RzfO2f5n0kP7rDxl6zBxrC1bD+ExAB1Yizq5qiIuKmjSXFDIdJqO/f6CvjGb7Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zM6x68qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zM6x68qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD49D1F000FF;
	Fri,  9 Oct 2026 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556218;
	bh=XYj32oGQW7niK6tCBTOmug+YuTLWxuSa7FN/Li7Vbi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zM6x68qoH47hx8bQqw4sWkdFdGju1eH0sM5oYu15FOM2ZfIsP+T8SYw7R+SSPXQN0
	 y5mPjuClTSOFoLPBpHiHKgnYqjO8FwIKzXmw3rIimxBH5UXKXPvIOjODsMcNKYBw/t
	 FInGGKH3QZXqelZQFHhEHyoAMUvrSR/g5LyVBPTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.18 193/403] tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup
Date: Fri,  9 Oct 2026 16:09:14 +0200
Message-ID: <20261009140956.640938596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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


