Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AA33AE6F2;
	Mon, 23 Mar 2026 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278506; cv=none; b=d4LIfj1olEe5Wlx1TW6TekJj44VofydmT/7DsGm2I6Eb5PowaBK/GvWUbD3OWC38CZYaxmb9QGksgSxlaPlMiyQQgnDDczI96AxmyAxZOZinYuYAYUmPQ0WcphRKeY2BXJM62nvsWQtmcM1ETfYf09iC/Ump5K0Wd2krEKR7Epo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278506; c=relaxed/simple;
	bh=mQfHtqqdiP1PqL4w6NV0n05CerbD546Sj0bDPXA78Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3w0Y9doh9VU9DPwh7qy+R70mCQvR7bbHThzJwa0gpfZ/SRtW1ge6pQ5coe6+jfiGRTGQXlDNQhtE8ls29pEge4u8fxsY2KlRWjXqAQ3wVB22zPFAKyghRAtJLaICPTbF92ay2UGhYELR9uBaps8JcqxL/8QYWyQYhkV0X2p6GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWDyRvC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWDyRvC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4DDC2BCB4;
	Mon, 23 Mar 2026 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278506;
	bh=mQfHtqqdiP1PqL4w6NV0n05CerbD546Sj0bDPXA78Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWDyRvC7+IF4VLky0EYHVNvuto3pUsM/Qd+Yr0xVLTDBQy3POJAc15w2blg0Jj8lU
	 pR9lcyL9wd9zzxFXaySacyzRJEaEZWI6lyz67V5PV4dCcx6AfrJfDua/8HqW5xH4AN
	 RAtSJL6TBVOD2B+E8yIB3nP2fHOj242vhc2hymGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 285/567] usb: mdc800: handle signal and read racing
Date: Mon, 23 Mar 2026 14:43:25 +0100
Message-ID: <20260323134540.878783743@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit 2d6d260e9a3576256fe9ef6d1f7930c9ec348723 upstream.

If a signal arrives after a read has partially completed,
we need to return the number of bytes read. -EINTR is correct
only if that number is zero.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260209142048.1503791-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/image/mdc800.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -708,7 +708,7 @@ static ssize_t mdc800_device_read (struc
 		if (signal_pending (current)) 
 		{
 			mutex_unlock(&mdc800->io_lock);
-			return -EINTR;
+			return len == left ? -EINTR : len-left;
 		}
 
 		sts=left > (mdc800->out_count-mdc800->out_ptr)?mdc800->out_count-mdc800->out_ptr:left;


