Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFCA8632B;
	Wed, 17 Sep 2025 13:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114100; cv=none; b=r9AMj9HO8Ka/xNjSIo7Ia4ZkwvUXVlY35NGGsNbjcbpxePmP2iAFi2wOYHaw98KdQCKl8i68czenU3TFsBcAuBpMOsUVWVTJy3PZg9oo+837Vt5efwm8UKodLFsSLCBaVyiYYwXPE3uxCPU+8FNcRUaJ75/yPp05sYySSZgrcYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114100; c=relaxed/simple;
	bh=+cB7aqmJkpxm69PMbLBKXOVNDvWuHxRkYBm6xKdV3/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbxfNE2QNx0P/MDIaIgq4CxDCzh0Ri5DzKaRttn2aO9dfJeO1N8TWpNhvOGYxSDAke9FZX0Itpk0GW6Ya1P1oVpB5joQ0Wq+p4HlANDmcPPJs8wnhFzbI4kyaIXSy9SzAX5RxgpWCX8LV4zzPTgrKc/RLA9ceiMP0Bf5VHmHeMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zT/jCsrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zT/jCsrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD5BC4CEF0;
	Wed, 17 Sep 2025 13:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114100;
	bh=+cB7aqmJkpxm69PMbLBKXOVNDvWuHxRkYBm6xKdV3/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zT/jCsrmRXyiKZgnyEz84v70rVZ+V76qFE6K/7Ees/KYg+r5S6K0jpTFld7If2JPi
	 OSGwzqHMh0xkLbwUi+p3fxkOuqmNQ4N5UYGNMiZRIRlBF36iznRdOOU2UEAr+aBGij
	 wc5ndFHkOhfvoZu+SELHBtzkWe6srlY4FT+dUhGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabian Vogt <fvogt@suse.de>
Subject: [PATCH 6.1 46/78] tty: hvc_console: Call hvc_kick in hvc_write unconditionally
Date: Wed, 17 Sep 2025 14:35:07 +0200
Message-ID: <20250917123330.690227150@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Vogt <fvogt@suse.de>

commit cfd956dcb101aa3d25bac321fae923323a47c607 upstream.

After hvc_write completes, call hvc_kick also in the case the output
buffer has been drained, to ensure tty_wakeup gets called.

This fixes that functions which wait for a drained buffer got stuck
occasionally.

Cc: stable <stable@kernel.org>
Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230062
Signed-off-by: Fabian Vogt <fvogt@suse.de>
Link: https://lore.kernel.org/r/2011735.PYKUYFuaPT@fvogt-thinkpad
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_console.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -543,10 +543,10 @@ static int hvc_write(struct tty_struct *
 	}
 
 	/*
-	 * Racy, but harmless, kick thread if there is still pending data.
+	 * Kick thread to flush if there's still pending data
+	 * or to wakeup the write queue.
 	 */
-	if (hp->n_outbuf)
-		hvc_kick();
+	hvc_kick();
 
 	return written;
 }


