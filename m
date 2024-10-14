Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2701A76A5;
	Mon, 14 Oct 2024 15:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918605; cv=none; b=Y80x/GLxkC/gHzWATWdD65b1CW8oz9gWQ/bPzHOj38xkn1mWv7YrxziNZE9JkWRn7x4RN/gHrZUQ374cUgzJUKMsNq8ASaBsbXKb7QLVL7QUyvegWjRMv62uyaA8jlkVtybll2Mr3HnzaUmAClh+L4a3TNg/ZrYNd6cR17SFc4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918605; c=relaxed/simple;
	bh=UiSojzeT44jpVd2fpSYtFwq9RQvy+x4MQ0Sa536jQoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7UU/Ph6eSF5sKG+aE6817iEuVbY3e2+jkQnCYEavCPdTEOAXRrCMOlBTpzXAkXmgdiXFVrTxsVerV9JALIVoAg0/chbupNRB5I/LfuaU6vB2E8phiVEDiQlNYF3EtAyitpu7l/VPz7M/fg1MoBvHVvh4OHKptBu++hTIQjquI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWz+e+8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWz+e+8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2039BC4CEC7;
	Mon, 14 Oct 2024 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918605;
	bh=UiSojzeT44jpVd2fpSYtFwq9RQvy+x4MQ0Sa536jQoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWz+e+8ZHQv05V/xJjpD/UkBAm8BnJ/SFelz530WMVH3OnHGIa3/JaWVP2TcaBEaU
	 gZgTRxZCNmzlk/6u0wi+K+EXSMExzHDEpSvaxShAKg0GbBQr/AEMCAlD3xtX98XKvp
	 yaCEqGthGSWPEfKoMFfktfftKV7PCY2AjO+0pfbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.1 370/798] usb: yurex: Fix inconsistent locking bug in yurex_read()
Date: Mon, 14 Oct 2024 16:15:24 +0200
Message-ID: <20241014141232.486977268@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit e7d3b9f28654dbfce7e09f8028210489adaf6a33 upstream.

Unlock before returning on the error path.

Fixes: 86b20af11e84 ("usb: yurex: Replace snprintf() with the safer scnprintf() variant")
Reported-by: Dan Carpenter <error27@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202312170252.3udgrIcP-lkp@intel.com/
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20231219063639.450994-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/yurex.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -413,8 +413,10 @@ static ssize_t yurex_read(struct file *f
 		return -ENODEV;
 	}
 
-	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN))
+	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN)) {
+		mutex_unlock(&dev->io_mutex);
 		return -EIO;
+	}
 
 	spin_lock_irq(&dev->lock);
 	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);


