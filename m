Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8484F2FFDE6;
	Tue, 30 Sep 2025 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244098; cv=none; b=XdpX9LfJn967rtMxfSYnaNw+WeUhGtxceAYNdyhoUdSjKHOrZH37IjdOPoEXrbMvzlqaG8AhV+Rp/HI0KfeXQv7FdiOHPmhKPqzzLuxFj/u/aSInSlu41WXoWpziqrO4yuQCEAqQE8CIqE8Ohwcxjl3Xqbez+OSefBzFvPlTWZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244098; c=relaxed/simple;
	bh=EOoyNhkutrRe1hNSNbQ+IVCE8HG9GdYM/3YPRH92GHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwMc3WhB4YENDhX0FiHR8Td72m7OpwFnd+iy5YO2VXhwXPJWWyy5e3NOWgCcywKZnQs7PATIziP6LDmxXPIt5IOzaj+Ns2fIx4j5uGWWE5RyKgroh7vGDnnzO08rBMczbQggWgoPsUR0AqYm9FTAVw1XCIn9HV2jHCS78rz6ppo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCJwdGrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCJwdGrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97678C4CEF0;
	Tue, 30 Sep 2025 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244097;
	bh=EOoyNhkutrRe1hNSNbQ+IVCE8HG9GdYM/3YPRH92GHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCJwdGrtHdLm2AVq8P47DL0si+VL+fwB4pDmra0MQSBrBeUTozyPOWb+nQLVBHdci
	 Nr0jzoYmcui5o3ok6nRNkYJ6NfWYqDX88XVTtfmb/ZitM6NK5SlDGxI+roc7e6GhfE
	 Rp9crlDVYEDCr0L2KV+EXulhY8xjWYxrzsPNwiuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabian Vogt <fvogt@suse.de>
Subject: [PATCH 5.10 027/122] tty: hvc_console: Call hvc_kick in hvc_write unconditionally
Date: Tue, 30 Sep 2025 16:45:58 +0200
Message-ID: <20250930143824.117546200@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


