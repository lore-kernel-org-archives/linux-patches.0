Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C09A242910;
	Fri,  4 Sep 2026 06:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501668; cv=none; b=HjK002w0I9ZkUvUE7lGNrnS3mLcAyU4MW2MYNTNPvadZNV1qpPsHwuXiPdAkfhU/0c938O/DkDxhMIQdw+PlbalBWyRi2OOyTW3kCvp/mWZh6WxIguwCu7N5bI/fa3vrWK4yVHu6muOCE/j11ds+0SmCyNSylKjYW7peFICIl9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501668; c=relaxed/simple;
	bh=GKstZ/1I1rJ7PWqPyJMjEhEndO11oGulklmavFbbJjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU8ZutFeNMnmVd0qkmBl3Kia+l/S8QDSpcGLjqSY9j7eChGbUI9jR20c6GC9Qr6vjjoYz+9+a1u0stsdi5K2Q/oS0N0Zu/UX5ugYdDtXxmHupeUBN+UTU/Iy2/Iu2Ir0IZ+kN1x/yzKSfPPE8cAvLx2ptlfIfHs7aCdQ8/2OW1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UgZ2LzR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UgZ2LzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7403F1F00A3D;
	Fri,  4 Sep 2026 06:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501667;
	bh=3DgPOomsdXxBfX0wITK8tYQiUABMW1U92MT/j/XINik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UgZ2LzRPL4vpdnKvkPmy3SDLVHpJXzmcIVcbtsjP10NRz3EI9P0nJKO3Zk2dUGB/
	 YzYvZdIf8mQCYyjzki8fdk+m7oIXcbMbYZiJ4m+YnWtQex5zMepIc14LTMa7/U8HHc
	 z4aPEX2Iw7eO2jkc/5Yff2VYOAYXV+TMQAzkbxPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 447/552] ipmi: Remove all sysfs files on registration failure
Date: Fri,  4 Sep 2026 07:00:04 +0200
Message-ID: <20260904045800.819153608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


