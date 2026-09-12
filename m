Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049FB3603D5;
	Sat, 12 Sep 2026 16:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232167; cv=none; b=CBc19XjEZgKj8PIIX/MdH2Gwa+lHswbO7GZ0le46FHUwIfDV9NksIj4IiDDnarDVy/Jzctiq/kUdDOMIFrd1GuOme3sIwI/ikAvwVQ8lseK6+i36An8nqIRuTyk8IfUrdQiAGqaBDzk8zJ6JMITVntVb8o3n/ktnx2Lif/pl9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232167; c=relaxed/simple;
	bh=++z1AILtWOzEb+3xYw0HTes7q/2Y2FOIlGZHuVkVdgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNG2mY/QuPCDWsi1QMzFnsBo1mjY3ckrD/kIt4FXDrCtkCO2pnwDI59YGkQw+qNGcgmWK5I7XoepbaSijklV+ijL960oG5lkixMFYJaMwSIysZti2QdVJLXvl1+P20dnyezxSDD3EIfl9uDudm446QoR56sgOYhgKIj7b7OiSfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TD7HAPw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TD7HAPw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ED91F000FF;
	Sat, 12 Sep 2026 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232162;
	bh=e+IcEZwTLadasdJBLn6RTP8mn9/xNYWYYCpQgoIYVt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TD7HAPw51eatTJ7Zl0apbFkcCPZOS0Y5VXNExjEmwqVDlwy72MGrMpxFvdgsB1PYT
	 R2IO2IvfUL7zHDKBAxl2yiVuOSeaxdtmPopuLZzYtSYJ7TkxBtDjyc6u7nyamLNKNH
	 q4TIYHcoK/zrDt+ObTILzbK8zM5YG8v4oAib8E88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1144/1191] Bluetooth: coredump: fix building with coredump disabled
Date: Sat, 12 Sep 2026 09:04:32 +0200
Message-ID: <20260912065613.844934855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6910e2eb39254d279bce5bc0f8eb6af45b59357c ]

The btmtk driver uses an IS_ENABLED() check to conditionally compile
the coredump support, but this fails to build because the hdev->dump
member is in an #ifdef:

drivers/bluetooth/btmtk.c: In function 'btmtk_process_coredump':
drivers/bluetooth/btmtk.c:386:30: error: 'struct hci_dev' has no member named 'dump'
  386 |   schedule_delayed_work(&hdev->dump.dump_timeout,
      |                              ^~

The struct member doesn't really make a huge difference in the total size,
so just remove the #ifdef around it to avoid adding similar checks
around each user.

Fixes: 872f8c253cb9e ("Bluetooth: btusb: mediatek: add MediaTek devcoredump support")
Fixes: 9695ef876fd12 ("Bluetooth: Add support for hci devcoredump")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c5ed346d049eb..95e3fc06ee20f 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -570,9 +570,7 @@ struct hci_dev {
 	const char		*fw_info;
 	struct dentry		*debugfs;
 
-#ifdef CONFIG_DEV_COREDUMP
 	struct hci_devcoredump	dump;
-#endif
 
 	struct device		dev;
 
-- 
2.53.0



