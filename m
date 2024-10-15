Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C21C07FF;
	Tue, 15 Oct 2024 13:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997718; cv=none; b=goHkCbnd8IXSsYh8kd7sJWXa56qCsMr/Fn7SY530hk6eiXxpG7WAdewLp4Z4de5UmBFurRNlMn0c54rRzne8ZryP7P94kDJEkMIs+kZ1QjAEWj+/EgikFPJRZFwJZ7SjhFkRxpW5unkwC43SCSsjdr54DG/hOXbR3DSVfKCYojA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997718; c=relaxed/simple;
	bh=vViZ9S8wjZFK/RginCn48OtU/0gF73fpmcNL+bAzCO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfiKyCAp1eJuBnpSa8riZucWXTgnboQJ+ZKH4MjIjhfLA7KXIJDnhc2GlGg8BSaqtx6VfyCGStb2dzQBU0U2tICEAjtBIBU1y8z6XiAbnuqQrEP+kFNN0BYrQXVZoa6PEQ8ZZmZ9m1raKCTkwT9dLJ46d3kcHcuCPbsSQRNlVAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdvNd6E/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdvNd6E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2147BC4CEC6;
	Tue, 15 Oct 2024 13:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997718;
	bh=vViZ9S8wjZFK/RginCn48OtU/0gF73fpmcNL+bAzCO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdvNd6E//ZJRXbniUQzJgfNXgXAvOZuUqlKfcWVt6kiGBEXOfJxRosHroWpkgZaFY
	 ibgllgP7XtErsyX9NuaN774i9kN6yKTZq7XcItrKTZk7jm9WX5CSvrb4L4AuhyFnPz
	 K0Jwxl7xEklyucfdAC3fAp3xs58L2E28Dvc8Uiqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10 264/518] usb: yurex: Fix inconsistent locking bug in yurex_read()
Date: Tue, 15 Oct 2024 14:42:48 +0200
Message-ID: <20241015123927.184326580@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -412,8 +412,10 @@ static ssize_t yurex_read(struct file *f
 		return -ENODEV;
 	}
 
-	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN))
+	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN)) {
+		mutex_unlock(&dev->io_mutex);
 		return -EIO;
+	}
 
 	spin_lock_irq(&dev->lock);
 	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);


