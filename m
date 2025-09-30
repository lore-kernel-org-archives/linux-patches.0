Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4FF1EE02F;
	Tue, 30 Sep 2025 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244996; cv=none; b=VwuDNGy7CzEaUkeqO86fEsktpWORhYomkaeg9Hp1eIY5/QpByf9n1/XBm0+8v5ti04qqrKhwUvYjNiheFxnfNUz7Ucn7wJh4z8mUlCCvRbSKLA7MwjkVwD+W/MsnITZ64dMf2oAcw8V+lyyCL2zP+Am1hyELM+tjNB0xk6ty6QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244996; c=relaxed/simple;
	bh=RWdZOC1K+PE4f4ccrUbHW9pb/7/2Dfhy6uQV1uBzCs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDNfjWBuTCmi0K0oqV6ewnY8yLsX9mZGfjZciSbywIWbWUX0sB/ZozZ528Dva0V3SLjfmSvcUFBbiFHTppWHB/awKDZGLKJhh2fFLyPK/46yMJ/C8ic+u340YH7VrLH0DZ3kULqY9X5+fAiaZZ7nLD3GZRt24BanyfceE3JzGsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pO7zmX5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pO7zmX5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323E8C113D0;
	Tue, 30 Sep 2025 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244995;
	bh=RWdZOC1K+PE4f4ccrUbHW9pb/7/2Dfhy6uQV1uBzCs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pO7zmX5miisczczDNFpU4qRUePpe5jjNcXWjOmfNB4oEljZBk0RXpJqZ8TTUXLKn0
	 g9+yyqSfi9QyjN6wQoilSz+ZUBNULSOKVcW77Opoy24IJx2HchaTkD3yzf8o2QsJYv
	 tn0TURp0LtgK4roqN8BJi67TqisLWIEcDkHr1OCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabian Vogt <fvogt@suse.de>
Subject: [PATCH 5.15 034/151] tty: hvc_console: Call hvc_kick in hvc_write unconditionally
Date: Tue, 30 Sep 2025 16:46:04 +0200
Message-ID: <20250930143828.973862341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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


