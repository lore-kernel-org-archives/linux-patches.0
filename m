Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7FE4204E;
	Sun,  7 Jun 2026 10:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829623; cv=none; b=BIoyQ8ixvbOXhCEncb8kLMGY0iT7vonux7L45AtKTwTGZfkf8eGSz87WG8h4aw8n5gYHhVtfnNNOANV4VqeH0R0jeMGx4xztVQtyPWWm7fHSdxt3VAfIG+L/G41VDG3KCvkfBb+r0fchjjz+daEyalzo2j2UTMBPBxWNG3NkCdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829623; c=relaxed/simple;
	bh=WDRu+g+EKrGVIUjCtMbuJBTDPq09+qkHYJTsAPEIpFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDaAA5ArqfaCsIG+1bWPONy04ITkg4cGjluQ/VRLFuUtELaWAtbLovaAfnA/Xh88s/xsansJzinjex/okehfnzIqfJcE5nj3XjRgv+021dS1B/lM8OsqAGg9MgKxHHjqzxmWL2yBDcKaqbDzBbnLxXKIhcMnaT9GMwokMKUViQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOpIAZ+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOpIAZ+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8220B1F00893;
	Sun,  7 Jun 2026 10:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829622;
	bh=yWFJSj47opkl9hregE8aQNfxq1Mo6Yx+LLo4SaacyDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOpIAZ+209Npky9tMwohN8S/SRGVLNlDoq5vOxLs5NkuWd7KsQACUmoKb51aTK4A4
	 E0pkD8S9d6YjH1tpxekRJ2tFegW+7B8k6o8PmyBhRpZ7O4r/N79sQeEh1Yp/ZPvptY
	 3FVMcvLKaVbIZ2dnBP5CIiRKauOYfK5x5/RrVMSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 7.0 300/332] serial: zs: Fix swapped RI/DSR modem line transition counting
Date: Sun,  7 Jun 2026 12:01:09 +0200
Message-ID: <20260607095739.079603102@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit d15cd40cb1858f75846eaafa9a6bca841b790a92 upstream.

Fix a thinko in the status interrupt handler that has caused counters
for the RI and DSR modem line transitions to be used for the other line
each.

Fixes: 8b4a40809e53 ("zs: move to the serial subsystem")
Cc: stable <stable@kernel.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://patch.msgid.link/alpine.DEB.2.21.2604101747110.29980@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/zs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -680,9 +680,9 @@ static void zs_status_handle(struct zs_p
 			uart_handle_dcd_change(uport,
 					       zport->mctrl & TIOCM_CAR);
 		if (delta & TIOCM_RNG)
-			uport->icount.dsr++;
-		if (delta & TIOCM_DSR)
 			uport->icount.rng++;
+		if (delta & TIOCM_DSR)
+			uport->icount.dsr++;
 
 		if (delta)
 			wake_up_interruptible(&uport->state->port.delta_msr_wait);


