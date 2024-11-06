Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297E41DF24A;
	Wed,  6 Nov 2024 12:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895262; cv=none; b=UyaKcyn3RP/Uo/oGszHT5dv06FtsEkKaV1PfWiUUT7UxfL3Atz7zvtGi41dQMJ7AQRRu1OhI9x3tD6M//JolLaz5KS9zScJIlEV4Rf2egPR+lKlRAcsjvmAQjZuPK/ksYIGqQM5cJ7hqu3QbXPwLR345E3ZMU+DXgGKqrdp3j6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895262; c=relaxed/simple;
	bh=MwYlmtWBB9VNj6sfwjnlLarUfbFckMNbtD4ipo3fa20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUhueNpycaAv0UjSX9eouXIg/K+LYdqX48XQKIrfQMwdrCMiA2ZciFkE4G2xT3iO77g1YT7op8PNrlr623cQoo3J3UAKiNySRIw1G0HMJU9lMmBxR5oUAeG4z4YGzgg4Yqq5xsfIpK7JEvmSKPHXxjo1m1sU2BtqhMx/W1BH6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRi9yW3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRi9yW3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E997C4CED2;
	Wed,  6 Nov 2024 12:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895261;
	bh=MwYlmtWBB9VNj6sfwjnlLarUfbFckMNbtD4ipo3fa20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRi9yW3La2rWGxxD81BImRlf1UjUKUDyDZkH4aP6T+5NuByshoOsFnxau4+VUFFn/
	 8PJ7Grn1tFsRQjsD8U1aAFZMVPNVTf8tVQkzFbLwEkrpYjN2Nrcujpasc/8lfrPbBd
	 ZhLM3ARiQQOFC0W7JJYW/0TkLBoVGNhwCUzr8Ibo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 4.19 131/350] usb: yurex: Fix inconsistent locking bug in yurex_read()
Date: Wed,  6 Nov 2024 13:00:59 +0100
Message-ID: <20241106120324.142492133@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -414,8 +414,10 @@ static ssize_t yurex_read(struct file *f
 		return -ENODEV;
 	}
 
-	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN))
+	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN)) {
+		mutex_unlock(&dev->io_mutex);
 		return -EIO;
+	}
 
 	spin_lock_irq(&dev->lock);
 	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);


