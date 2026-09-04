Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D923B19BC;
	Fri,  4 Sep 2026 05:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500053; cv=none; b=Dm0Z8ZNDoKfoUwgOrzbcAd7rRfcnY/UMNJkt8QAA1FbKLvwuzv0wJohuF1eCWQFo0qOYTVIrZJF/jO6O9zwJcmGPEksRVMF3IvT2M5JLDVefOhNcJRShs+iks9m1tX0FWQJyo0VKYcQnaow+xSo2NUh+c75DHM2D21gHEYFI92k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500053; c=relaxed/simple;
	bh=5Q5wiQwksj00+tzRn4hK/xcdYzj3k58ftm3LacwhDYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFxqgKk15oo+JaUXqNSgy5JYnkHzAXqeYgYUTzNTPu9wglCn/MQn1LnmB4nqyh0JwiXpxFNyNUVNeo9I+iN5LEYa7eJyd6/Y85cVHLaEf8BAU5gj1a61iBob9OFry7V3vM5hKhtr/A05U5rTlyPRvRKx2CIQt12CeyzdxVOiBi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFbEseyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFbEseyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5601F00A3D;
	Fri,  4 Sep 2026 05:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500052;
	bh=8h7dWS8W5PYRbAvWyVW4KfcpPt1JLlW0UD+ShVm2DF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFbEseyvV9444yy+Y0D/po//ZXiBFRLZGE40xxDuTs5OlT3D/uEIxWJrmMFeBdek0
	 Y2sxihZjZHUmgPvnSPPURKHYWPQAeUGvQtWXkSvU9yzSarSrw+CxaZL24YKt5fbbLP
	 OZmjdrNwc5jwIP8jjKRkm9MB/eTWWq3LJXeLvKB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 7.2 591/713] ipmi: Remove all sysfs files on registration failure
Date: Fri,  4 Sep 2026 06:59:19 +0200
Message-ID: <20260904045817.069383619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

commit b6c46ab0bdee90c238e96ea4a74972118c97900d upstream.

ipmi_add_smi() creates the nr_users and nr_msgs files before trying to
create the maintenance_mode file. If that last creation fails, the error
path removes only nr_users before dropping the final reference to the
interface.

Remove nr_msgs as well so no sysfs attribute embedded in the freed
interface remains registered.

Fixes: 627118470fcc ("ipmi: Add a maintenance mode sysfs file")
Cc: stable@vger.kernel.org # 6.18
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Message-ID: <20260803015550.618808-1-dbgh9129@gmail.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3741,6 +3741,7 @@ int ipmi_add_smi(struct module         *
 	sysfs_attr_init(&intf->maintenance_mode_devattr.attr);
 	rv = device_create_file(intf->si_dev, &intf->maintenance_mode_devattr);
 	if (rv) {
+		device_remove_file(intf->si_dev, &intf->nr_msgs_devattr);
 		device_remove_file(intf->si_dev, &intf->nr_users_devattr);
 		goto out_err_bmc_reg;
 	}


