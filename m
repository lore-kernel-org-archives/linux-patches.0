Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842CF44AB82;
	Tue, 21 Jul 2026 21:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668624; cv=none; b=jjLqEU+DvPi3zkjDT8Oi19xRIgBKSoAUtquhQF3gpf8pLsz/AWHx9zlPm4SfzNIo+2h0fvjb/Gr/Y46ycABTmhOwJIBg2gXxxuvKtnF4Lrghz1bnYto07Kt1UX66xUNd6UnIJa5YLEnpYC6I+oz6HQdpk797BCpkB0BhmahYjhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668624; c=relaxed/simple;
	bh=NVFqnILww5sD4652EBjiCQbwJdbsjr5FdxLuXBKQiNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrgGt1I39P9PFoScvJWbZBMEaLk3MarwzD5S4C9PPQPbvJwxWo1ELvHhg9rhGZZAj3KUWbOvtaW7GZueM2wF96mvtxRlKtW2GdKxGZvCKe4IcoM9ro+gxZJtMLn6zvbNrqBrq/7sKc3XFNGzp9IS5I07g7G6bp+ad2aE6ifIWcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anEVZwM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anEVZwM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277D21F000E9;
	Tue, 21 Jul 2026 21:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668620;
	bh=HGqDvi3/DTsDqmlmqt7/5EpRQAchBKQfB3wR94++BMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anEVZwM1kJIi/YWV1L0grsUErZBu/XY/Cn4Kcmo70/76zUy1/pjJAZPBCz9A0vLi9
	 F+Fi0tHOirUPs+4lsibmLjJb6yrxED3sDKlpZdftp4K3b7mr4MBHCqdjHmC0vJX0zr
	 hovO02wIM70fdFlQRDGorlPO6z6hOkaKxosYH5kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.1 0191/1067] usb: typec: class: drop PD lookup reference
Date: Tue, 21 Jul 2026 17:13:12 +0200
Message-ID: <20260721152428.866106023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 43ae2f90b70cda374c487c1639a01d0f14e5d583 upstream.

usb_power_delivery_find() wraps class_find_device_by_name(). That helper
returns a device reference that must be released by the caller.

select_usb_power_delivery_store() only needs this reference while calling
the pd_set callback. Drop it once the callback returns. Otherwise the sysfs
write can pin the selected USB Power Delivery object and prevent it from
being released on unregister.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable <stable@kernel.org>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260702191329.2648043-1-shuangpeng.kernel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1258,6 +1258,7 @@ static ssize_t select_usb_power_delivery
 		return -EINVAL;
 
 	ret = port->ops->pd_set(port, pd);
+	put_device(&pd->dev);
 	if (ret)
 		return ret;
 


