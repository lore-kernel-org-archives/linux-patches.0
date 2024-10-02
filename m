Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C4F3D994;
	Wed,  2 Oct 2024 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880651; cv=none; b=r0l6Tl9mp+9QJwOYGdGkPW5Z+kNzDvDhgOpyWI3nFLKZga/x1h9qgcexN2l4iE2X762uNpTjYwGtHwBW015HyXKkRBqCHq+eeINziCaWgWVP/tmi7BGn+VzDWaKby2sMX3qdgqttpCcO8pdxJx9GZ6NIAntNP6yCuTBCPWRwCrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880651; c=relaxed/simple;
	bh=ycHPFH+khEjFR/oUnzAXtMJ0EB8+jL8dFQuY53AdILY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIcHbJtdhlS4aV70FNJibVTdtmF1/QADg8zxjs+v1QvL7uXgH5R76QzhYMxde/x84hPvEaF5tpZnFBxdkF9NwHnRQHHtcOIcyLeo0nsPPK7P0PrWWaCqsidLm/RZbD+RKxaOFs0wzjN+XSl1Rn9zakDwUfe/5oF9vhm0iPKfgDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaDCXs+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaDCXs+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A937C4CEC2;
	Wed,  2 Oct 2024 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880650;
	bh=ycHPFH+khEjFR/oUnzAXtMJ0EB8+jL8dFQuY53AdILY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaDCXs+kLUbwjmVzOEN2TC+PBzbgrZT67FyCzM4nDCYNkHfPbt9ouiE5GxIMxy6WM
	 FQXiUDljWMcPdAU2SmRGIcIoj90HvfnP45d2ZbJNK+SaSwobwAI2XseZa4BNi2vyTq
	 ZdmnKdASe93Ku5Pz3Wo/mwbNmOzSMnnFyiBDV9aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.6 530/538] usb: yurex: Fix inconsistent locking bug in yurex_read()
Date: Wed,  2 Oct 2024 15:02:49 +0200
Message-ID: <20241002125813.367049154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


