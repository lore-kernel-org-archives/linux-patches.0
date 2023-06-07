Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F319619E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740DCC433D2;
	Wed,  7 Jun 2023 20:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170203;
	bh=7P1ovuxvTzFYSu+1MIAyr3QGwChR4p2MrkuhM2fNbD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xANv4Wop7oDnwyCEIOg8AP6XBIIIT4dAX9w01VgRywKL4NHgNMHjplIJbUCzFB093
	 8cusEvTL4kYclAs9L4MEu6TPa/aWMzDzCxvjwb2+Ih2EBzkEALQpy1eyXd9JWQc8Sm
	 cBM6s19C3sZjulvHFtD22p4omEAhIY+s1bm0vWV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	syzbot+d910bd780e6efac35869@syzkaller.appspotmail.com,
	Sam Ravnborg <sam@ravnborg.org>,
	stable@kernel.org
Subject: [PATCH 4.19 84/88] fbcon: Fix null-ptr-deref in soft_cursor
Date: Wed,  7 Jun 2023 22:16:41 +0200
Message-ID: <20230607200901.848021414@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
References: <20230607200854.030202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit d78bd6cc68276bd57f766f7cb98bfe32c23ab327 upstream.

syzbot repored this bug in the softcursor code:

BUG: KASAN: null-ptr-deref in soft_cursor+0x384/0x6b4 drivers/video/fbdev/core/softcursor.c:70
Read of size 16 at addr 0000000000000200 by task kworker/u4:1/12

CPU: 0 PID: 12 Comm: kworker/u4:1 Not tainted 6.4.0-rc3-syzkaller-geb0f1697d729 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
Workqueue: events_power_efficient fb_flashcursor
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:233
 show_stack+0x2c/0x44 arch/arm64/kernel/stacktrace.c:240
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd0/0x124 lib/dump_stack.c:106
 print_report+0xe4/0x514 mm/kasan/report.c:465
 kasan_report+0xd4/0x130 mm/kasan/report.c:572
 kasan_check_range+0x264/0x2a4 mm/kasan/generic.c:187
 __asan_memcpy+0x3c/0x84 mm/kasan/shadow.c:105
 soft_cursor+0x384/0x6b4 drivers/video/fbdev/core/softcursor.c:70
 bit_cursor+0x113c/0x1a64 drivers/video/fbdev/core/bitblit.c:377
 fb_flashcursor+0x35c/0x54c drivers/video/fbdev/core/fbcon.c:380
 process_one_work+0x788/0x12d4 kernel/workqueue.c:2405
 worker_thread+0x8e0/0xfe8 kernel/workqueue.c:2552
 kthread+0x288/0x310 kernel/kthread.c:379
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:853

This fix let bit_cursor() bail out early when a font bitmap
isn't available yet.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: syzbot+d910bd780e6efac35869@syzkaller.appspotmail.com
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/bitblit.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -247,6 +247,9 @@ static void bit_cursor(struct vc_data *v
 
 	cursor.set = 0;
 
+	if (!vc->vc_font.data)
+		return;
+
  	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
 	src = vc->vc_font.data + ((c & charmask) * (w * vc->vc_font.height));


