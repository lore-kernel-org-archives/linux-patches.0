Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588631DA53;
	Mon, 14 Oct 2024 14:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916930; cv=none; b=iIStFYnkpTxOtcqxlV6oIHykjMVD9Q4orIWAiezm5FdLEkOjB2wt1zKjMannpEVIKK+DxAd5KzE3qM9xRu/olj//RsngehZxYrFcJAhMRhjFMgqupTGdMPFe1/nx0eJx6Jmaym9JorqexV8tmQckYFIPsH5weuElTuaEGo94j9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916930; c=relaxed/simple;
	bh=0tpa3aB0P/Sm3XNn6RNYwuL0g/grcqiInXGHIFRhS1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuIQJv4Mvz8FEPXponG/Z94W6ArRHRH9y9px+DGo1MFCanhwKsIT2qzrx871X9bViBX4xn7XO9NKD8ck8bmpLuAFvJOpI6eBYrxYMRfdPv4nrIe5fWOhVjULm79LdQiTpNYH3DefSvurXQTpjuhRPF5XDLZaE0G5Vnqdjg+UHkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfU6jx6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfU6jx6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2571C4CEC3;
	Mon, 14 Oct 2024 14:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916930;
	bh=0tpa3aB0P/Sm3XNn6RNYwuL0g/grcqiInXGHIFRhS1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfU6jx6E1e2Uid0iOH0wtXNaXFcmpScKraky9Byt0XaL1G8vg6zdC7Nm4nBKKa+l6
	 aPndYHVYU+wzX5bgd9dnz/xBI3hnWvfmzd1QuhCX5gMFiw+XsLvBAII5WOgTwu8tR+
	 j3lP9a/JyIY5ue3asduddEj9KLAMvy+szIaFAXF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d613ae53c031502687a@syzkaller.appspotmail.com,
	Qianqiang Liu <qianqiang.liu@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/213] fbcon: Fix a NULL pointer dereference issue in fbcon_putcs
Date: Mon, 14 Oct 2024 16:20:10 +0200
Message-ID: <20241014141047.029511470@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Qianqiang Liu <qianqiang.liu@163.com>

[ Upstream commit 5b97eebcce1b4f3f07a71f635d6aa3af96c236e7 ]

syzbot has found a NULL pointer dereference bug in fbcon.
Here is the simplified C reproducer:

struct param {
	uint8_t type;
	struct tiocl_selection ts;
};

int main()
{
	struct fb_con2fbmap con2fb;
	struct param param;

	int fd = open("/dev/fb1", 0, 0);

	con2fb.console = 0x19;
	con2fb.framebuffer = 0;
	ioctl(fd, FBIOPUT_CON2FBMAP, &con2fb);

	param.type = 2;
	param.ts.xs = 0; param.ts.ys = 0;
	param.ts.xe = 0; param.ts.ye = 0;
	param.ts.sel_mode = 0;

	int fd1 = open("/dev/tty1", O_RDWR, 0);
	ioctl(fd1, TIOCLINUX, &param);

	con2fb.console = 1;
	con2fb.framebuffer = 0;
	ioctl(fd, FBIOPUT_CON2FBMAP, &con2fb);

	return 0;
}

After calling ioctl(fd1, TIOCLINUX, &param), the subsequent ioctl(fd, FBIOPUT_CON2FBMAP, &con2fb)
causes the kernel to follow a different execution path:

 set_con2fb_map
  -> con2fb_init_display
   -> fbcon_set_disp
    -> redraw_screen
     -> hide_cursor
      -> clear_selection
       -> highlight
        -> invert_screen
         -> do_update_region
          -> fbcon_putcs
           -> ops->putcs

Since ops->putcs is a NULL pointer, this leads to a kernel panic.
To prevent this, we need to call set_blitting_type() within set_con2fb_map()
to properly initialize ops->putcs.

Reported-by: syzbot+3d613ae53c031502687a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3d613ae53c031502687a
Tested-by: syzbot+3d613ae53c031502687a@syzkaller.appspotmail.com
Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 24035b4f2cd70..405d587450ef8 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -847,6 +847,8 @@ static int set_con2fb_map(int unit, int newidx, int user)
 			return err;
 
 		fbcon_add_cursor_work(info);
+	} else if (vc) {
+		set_blitting_type(vc, info);
 	}
 
 	con2fb_map[unit] = newidx;
-- 
2.43.0



