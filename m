Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EEC1D0492;
	Tue, 15 Oct 2024 11:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993301; cv=none; b=HyN9dTsv8t/+26t5l+WJwejaLoJI6I+ww5Fj00ifFdwZJ+EEI5PAhKhHuM53gqBOWi3Y5hmdWEGrd2cACsJ5+XngTLmA3eUQzkG9q0vEk+dycLuDZ3Jr18T2C8D5tDvsUyGZ/AwmhnTZFFZAABJg52XYe+3sGeRwXAIKPF8qxT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993301; c=relaxed/simple;
	bh=qSUMzSStlf60QRBEQTsB87Nti/ihkAV0DV3gM4Ez/l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSENcFrHpALFzxBGWufEVkPIAKTua0iLpf3m0PP1B4oA42n8A4woxfBbnc5SPP3OnR3ZhSAlEjg1CK+4fj63fiLW1JqZk+SGxPnRv69jyncioli8MMy4uYiaiwXkaaV9hfNgQ3cotVQ5x3D5AWkSYHoOxKGEzJ2kB85EO6VC6Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg9jEwij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg9jEwij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845F9C4CEC6;
	Tue, 15 Oct 2024 11:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993301;
	bh=qSUMzSStlf60QRBEQTsB87Nti/ihkAV0DV3gM4Ez/l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg9jEwijNCJHAwouZS+7acbOvb8Ze1g+KLaNpmjD7/oXYiiUDcskg4ROgc2C9/zDh
	 sUB/GD/o3QVAmWfqx0kQr4w/rEE6ddWXAgdlWIfnNFUCyGRzYc5Emi5wCP+UipvVaw
	 A8h7vDsF7+Kr0FcE+0FQNKPIRTF6Zp5RTtBXsb8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 370/691] usb: yurex: Fix inconsistent locking bug in yurex_read()
Date: Tue, 15 Oct 2024 13:25:18 +0200
Message-ID: <20241015112455.033381893@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


