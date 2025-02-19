Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DEC1FDE20;
	Wed, 19 Feb 2025 08:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954371; cv=none; b=T2UmrgDW8vdoWFXYK87w2Afjpc/s43x6AgUTdUGbFqbRHcRsuoi3BvulnYpqL7XUOWqPc+ZJDkOoj+jnoVhWI3JMSfY/8txhZDj5uBVSRDJnkBsjsYZ/mFlZFd25eNDfZuDuCTnQJXK/ejGHohDntI/XX404Oh1kWC9Q4mZbyPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954371; c=relaxed/simple;
	bh=lpUd3fTtcOBp33b5q5TZ4CwLSkA3ZJgJdowM41vGxPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ijDP3oG3nwgFHwlS6QY3RQuVwdmGpli+osC+w1+V4jxkGs/T8PULvB2AIj3ZXBkCaGQKLx5xTIUJLyUAm2bzywNnHifftW87ED9HOF6WRvwGI5TyevXyTBPXy9v5La5U0EjQgMgeMHY0qtgx8NxHmQA99HAa0GmQS7GtPjX/hLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zddmmm49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zddmmm49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07600C4CEE6;
	Wed, 19 Feb 2025 08:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954371;
	bh=lpUd3fTtcOBp33b5q5TZ4CwLSkA3ZJgJdowM41vGxPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zddmmm49Ysh5s5tuMo1xUtiJxSF9m9G0bcIs1jATD5H6N2wRmYkLuFem+LuHFnonV
	 x5lgOSsFgWaw1te7hBhEjtsQ4nh+4rTfEyH6q1ZIAXQKVcXjl28ETgUGoq+CcV6vZg
	 KU4bqfLQj9+qJ+kGMU3x+z9lTFExSoo8ClHVnSVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 184/274] ptp: vmclock: Add .owner to vmclock_miscdev_fops
Date: Wed, 19 Feb 2025 09:27:18 +0100
Message-ID: <20250219082616.786494790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit 7b07b040257c1b658ef3eca86e4b6ae02d65069c upstream.

Without the .owner field, the module can be unloaded while /dev/vmclock0
is open, leading to an oops.

Fixes: 205032724226 ("ptp: Add support for the AMZNC10C 'vmclock' device")
Cc: stable@vger.kernel.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_vmclock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_vmclock.c b/drivers/ptp/ptp_vmclock.c
index 0a2cfc8ad3c5..dbc73e538293 100644
--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -414,6 +414,7 @@ static ssize_t vmclock_miscdev_read(struct file *fp, char __user *buf,
 }
 
 static const struct file_operations vmclock_miscdev_fops = {
+	.owner = THIS_MODULE,
 	.mmap = vmclock_miscdev_mmap,
 	.read = vmclock_miscdev_read,
 };
-- 
2.48.1



