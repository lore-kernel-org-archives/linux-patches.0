Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C9021B191;
	Sat, 30 May 2026 17:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162946; cv=none; b=Ls7MOUeHz6MJCracGdf+nQu+Ol9hxaGeG1rZfHsx/2FfRZOpBVZEkZFND/71ihhKBGfcSpRzBdi1eZv3tuQQAnNGB7cf7jyQWsA35sViKKqopVAG/+AI0dls9Wp3GXohPRpefCL3u5qMtxrck+8ZBYid9TuwffUlTrV5h3S3u3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162946; c=relaxed/simple;
	bh=GyBqdSC/iGQbEq5gMvncKxkHHGa+x0fYax8YKHvCUJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFcKym9Poz8rAN9QiMrq13W2H2Cf/zoDZMFQSuUn+zFBM2hnho5SiEYtXJtpEZrZwXnI0XKoLFcQfhTNslXAvxgTm7WJpxUaiCd+022T5P0Myj3v67g+mhOtLuD5w6f2EItWimPi7Me21S8lCvTMH5BIOAfCRjfW7BCmhAZv4BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lWtULFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lWtULFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147761F00893;
	Sat, 30 May 2026 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162944;
	bh=FdvnT/8g07GmZmC/oE8DeH4k9ERLtnAUu+acCcFPt1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lWtULFokxM66uQUr+TRTpZBleU/AVHxEKsRDjPwQgkSZPyfJ19jb8XTMJ6swSXbV
	 IsRl8JkVBaOvWaRdXXGSVti5XUkBIn3jiJ7CO1joHOqONAuj4OXnZLSfMUEsq+hUfP
	 T8cG3K/5ghqnI0hFhAYeggxoQbnvbvksDApM7LgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1f5bcc7c919ec578777a@syzkaller.appspotmail.com,
	Ruslan Valiyev <linuxoid@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 071/776] media: vidtv: fix NULL pointer dereference in vidtv_channel_pmt_match_sections
Date: Sat, 30 May 2026 17:56:25 +0200
Message-ID: <20260530160242.155428788@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruslan Valiyev <linuxoid@gmail.com>

commit f8e1fc918a9fe67103bcda01d20d745f264d00a7 upstream.

syzbot reported a general protection fault in vidtv_psi_desc_assign [1].

vidtv_psi_pmt_stream_init() can return NULL on memory allocation
failure, but vidtv_channel_pmt_match_sections() does not check for
this. When tail is NULL, the subsequent call to
vidtv_psi_desc_assign(&tail->descriptor, desc) dereferences a NULL
pointer offset, causing a general protection fault.

Add a NULL check after vidtv_psi_pmt_stream_init(). On failure, clean
up the already-allocated stream chain and return.

[1]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:vidtv_psi_desc_assign+0x24/0x90 drivers/media/test-drivers/vidtv/vidtv_psi.c:629
Call Trace:
 <TASK>
 vidtv_channel_pmt_match_sections drivers/media/test-drivers/vidtv/vidtv_channel.c:349 [inline]
 vidtv_channel_si_init+0x1445/0x1a50 drivers/media/test-drivers/vidtv/vidtv_channel.c:479
 vidtv_mux_init+0x526/0xbe0 drivers/media/test-drivers/vidtv/vidtv_mux.c:519
 vidtv_start_streaming drivers/media/test-drivers/vidtv/vidtv_bridge.c:194 [inline]
 vidtv_start_feed+0x33e/0x4d0 drivers/media/test-drivers/vidtv/vidtv_bridge.c:239

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+1f5bcc7c919ec578777a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f5bcc7c919ec578777a
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_channel.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/test-drivers/vidtv/vidtv_channel.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_channel.c
@@ -341,6 +341,10 @@ vidtv_channel_pmt_match_sections(struct
 					tail = vidtv_psi_pmt_stream_init(tail,
 									 s->type,
 									 e_pid);
+					if (!tail) {
+						vidtv_psi_pmt_stream_destroy(head);
+						return;
+					}
 
 					if (!head)
 						head = tail;


