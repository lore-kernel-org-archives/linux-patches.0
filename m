Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B743A23E342;
	Mon, 13 Apr 2026 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098830; cv=none; b=gycUM8Izyo3Xbg+0urpFooev4YGhd/Q7AT9P4ZZqCDQoxsbqV2vGoE74k1d8GeA+0YSn1go3AS7/1wUsVc9NE4iSTuyympNKXCVA9fsuIto8QyCg95kGpm/fkN/HTqym6Y+TkciNPXI/9DUS13qjm2TfxRR2KqcFu/naz2Xa4y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098830; c=relaxed/simple;
	bh=tpcrtmCq64kgPu6QW5SyVSbUQptbHEzmTh+oUTIFtJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpgeucOYYAiSEyb0UoGjiDvxVXD+r4cT8Rjxg/cUWNfnws5v+08cHBRXRIdCPhI/KbzW1hM4Ch2hUG6Ta+HEwXjpbwMZ1J1ogyw8IzhhzlDncHco5AeFN8fZsH72JTgONnwGbeXnXqK7UIOrFPCvXcnefpCLht4itTavUwHmmdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irrBp3ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irrBp3ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E43CC2BCAF;
	Mon, 13 Apr 2026 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098830;
	bh=tpcrtmCq64kgPu6QW5SyVSbUQptbHEzmTh+oUTIFtJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irrBp3ba2zqPVY3TAeJq6K6eaqaD7l7HFzA4A8OLII0FHvcrP4X98JdLjmhoe7Vlt
	 +KJh3uWOOkoCF/RPiErxBwlD4ozbgNzdq7aP7+Mnju6E94plre+tGBdRQHL1m0XiDl
	 V+54IOLlW1mKoJ6c4N6EgzX+qaDMB4Ae2X9T9wZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/491] serial: caif: hold tty->link reference in ldisc_open and ser_release
Date: Mon, 13 Apr 2026 17:55:18 +0200
Message-ID: <20260413155821.779274012@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit 288598d80a068a0e9281de35bcb4ce495f189e2a ]

A reproducer triggers a KASAN slab-use-after-free in pty_write_room()
when caif_serial's TX path calls tty_write_room(). The faulting access
is on tty->link->port.

Hold an extra kref on tty->link for the lifetime of the caif_serial line
discipline: get it in ldisc_open() and drop it in ser_release(), and
also drop it on the ldisc_open() error path.

With this change applied, the reproducer no longer triggers the UAF in
my testing.

Link: https://gist.github.com/shuangpengbai/c898debad6bdf170a84be7e6b3d8707f
Link: https://lore.kernel.org/netdev/20260301220525.1546355-1-shuangpeng.kernel@gmail.com
Fixes: e31d5a05948e ("caif: tty's are kref objects so take a reference")
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260306034006.3395740-1-shuangpeng.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_serial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 1b6a696182f72..02aea5a4b8ca8 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -312,6 +312,7 @@ static void ser_release(struct work_struct *work)
 			dev_close(ser->dev);
 			unregister_netdevice(ser->dev);
 			debugfs_deinit(ser);
+			tty_kref_put(tty->link);
 			tty_kref_put(tty);
 		}
 		rtnl_unlock();
@@ -346,6 +347,7 @@ static int ldisc_open(struct tty_struct *tty)
 
 	ser = netdev_priv(dev);
 	ser->tty = tty_kref_get(tty);
+	tty_kref_get(tty->link);
 	ser->dev = dev;
 	debugfs_init(ser, tty);
 	tty->receive_room = N_TTY_BUF_SIZE;
@@ -354,6 +356,7 @@ static int ldisc_open(struct tty_struct *tty)
 	rtnl_lock();
 	result = register_netdevice(dev);
 	if (result) {
+		tty_kref_put(tty->link);
 		tty_kref_put(tty);
 		rtnl_unlock();
 		free_netdev(dev);
-- 
2.51.0



