Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A520F332A5D;
	Wed, 17 Sep 2025 12:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113824; cv=none; b=IvpZkxOAJCwcSbgikx+fhbYpvGxgYznADDi9F7PYm5oXQx1bvxkh+n6s6j8y7NJ/NyodFYCLfv7SWR3PmC3QvB4U1rPc2gyrGTVV3s2T74fybSF57kZJMfwz0Y1d2eJTANZV/MSTK4aerU3EsH/uaikY2fpC3eQfLQDj3JHe5cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113824; c=relaxed/simple;
	bh=xoJzmeOqib0g3Cu+8MPaWTpgDO68YMhZut2T6+vE6fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgdM3zLf7cuBceqvN2u2MG4vEw/rtOjg425VrzuS1fIo3Zsu0aqJ6cUQzexC/awEixA90XvGsJpqNEuCOvtElWvq+15Hfs/EKyBCmJoNFYXREsZ0UnIg+UvI38lo3nmZwoxiiBZKzLdGdvvhsO4iTotpaKgVrWtHmwCb9KxfYE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBpa5yGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBpa5yGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D87C4CEF0;
	Wed, 17 Sep 2025 12:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113824;
	bh=xoJzmeOqib0g3Cu+8MPaWTpgDO68YMhZut2T6+vE6fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBpa5yGFk9WG9K4qb6Q8U1MKGtqWjkgnODBug+1RPZh6sj2L2FbsqBhjlw8S9MNfb
	 EJIrmQeStHNbT6Nbi70sGmFdPtirJncUC/VNPFNYjhV8fP0xMuzz8EzIvlRwNMScLl
	 Gx41red/RGpxgVJajOdn/WbukBS4kT2CBCgmp4Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabian Vogt <fvogt@suse.de>
Subject: [PATCH 6.6 062/101] tty: hvc_console: Call hvc_kick in hvc_write unconditionally
Date: Wed, 17 Sep 2025 14:34:45 +0200
Message-ID: <20250917123338.342148589@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -543,10 +543,10 @@ static ssize_t hvc_write(struct tty_stru
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


