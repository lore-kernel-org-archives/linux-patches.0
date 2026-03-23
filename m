Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA593C07A;
	Mon, 23 Mar 2026 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275474; cv=none; b=hRhmGOJT5zrobibwVc86/xDkloyvWpDlJvIIVZBXpB6IXqaxIrp3Il8goXjOwbVnDg8H7IQLUDBs0DPRYj9dA5iEPV4GitTCL22kn+SKg8SpBRM0vhbn8knZlQUTNoHdpNopS4fRouXHS6eyX42JBtpg3NHzobGcmZAWg0tEFo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275474; c=relaxed/simple;
	bh=Z/v9XxW97nTPfp1jBoETvSi7jpJxwuEeqnQWGe33eqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWAFay1K4SDKCiJVhaBGfuHEMfQkT2+F+cDSBKH4LtZ6UoJ4kUcdvcmXgcLN6fPFGQ55QNQeiRQFTLDRuqQZR/LYhq5ukqXo0hAs8hsD6nXVYGh+b1XWMmPZYH/rP43mga/zunpvTam78vK2s/rHq69CpCDPjnrNW4CQtYzl2ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9mui24Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9mui24Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D283C4CEF7;
	Mon, 23 Mar 2026 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275474;
	bh=Z/v9XxW97nTPfp1jBoETvSi7jpJxwuEeqnQWGe33eqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9mui24QmowbZ/VO3/9aEbn2Xioe4Gjcw8g2bZBFHOndvDAYoqiGslytodJEiD3m0
	 tgkBmbtAMw63n78rrmqFv8mzElSwJRc3jRp/N1x30KpaEKVNDkisMqCpyLAS8qB6yf
	 AqaksHEbzHYLFdNjQGQan1Um6oQpFGrsJc7YOwO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 115/460] usb: mdc800: handle signal and read racing
Date: Mon, 23 Mar 2026 14:41:51 +0100
Message-ID: <20260323134529.460464982@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -707,7 +707,7 @@ static ssize_t mdc800_device_read (struc
 		if (signal_pending (current)) 
 		{
 			mutex_unlock(&mdc800->io_lock);
-			return -EINTR;
+			return len == left ? -EINTR : len-left;
 		}
 
 		sts=left > (mdc800->out_count-mdc800->out_ptr)?mdc800->out_count-mdc800->out_ptr:left;


