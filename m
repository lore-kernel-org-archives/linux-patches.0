Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704652;
	b=Rq4J1AfRjs1o5KOA+tQaSij+hHOHzE1KYfUyhbRZKH2Ffvx0MKnqn2bBhH+WHKGJcwZ1
	 EqLsNGTrV6XNFK9ErAxjS7uMGz1AU19XNGo9+rJXi5rFUt7Xk5cIwKhk9XTR+k6MvewDi
	 1e6Bd/xWZUBJq3yzy+jcu/vs4nDr1pwDex9KW9zqBmT5oL91NCC1ZLovziqOPaDN4Gieu
	 rncaSwdrHto4Lp81pNZsnY+s2HopCdZG7YknUYkEtzb20Alu5OASKqxvBDxyE6gs+dzSm
	 sQztwwcy+hH8+NMwhfgLT4F84LERBTkJUFMj1PpIVYZGYjZNUd3jZNfiDz9en3DcezA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hjXLoz7Scw9PDSLm9CSpt9kcp7ZHohnnX2YZrKkz+Ow=;
	b=ew5JCCY7pdVjc6D3CuKUQyTth1KBjFhY7m55MD+9NlymeFwuTNuxCTAI7qf0be7e3836
	 vlEc5SlcSy2sulxJt9hUAkF27Y2TeT/xpgkma9PdDJcx5JxvchclLApi5Cb95ejsmU3F0
	 QSM0Lvg5uwxe4Zmy86A5TyHg0MAtJZDnmJx0uVDd8MzVOM7b2RXxqVNpK6OG6S1ikRiK8
	 YWzquw8jZ1SKwT4B9aIwL0YKRJZeOU7hOL+/2OobjlZl6oj1SAFBoVWSIV/KckIEBO3Zw
	 yEQYp26lgjM5Ujt6435hZMqT+tDDV25sZI8N4R9/OmZYZqEcD9DCE/OpOLgwduTW5bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGXo2htO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0963606A321;
	Thu, 26 Nov 2026 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGXo2htO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6E21F000C4;
	Thu, 26 Nov 2026 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704652;
	bh=hjXLoz7Scw9PDSLm9CSpt9kcp7ZHohnnX2YZrKkz+Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGXo2htO5/fFadwyLHdxf7VTMJXaNbMZsp0VmEDyf9tETVNikS9kpXA8DDhhthCuL
	 UccDXa1BipgbN6C1dt49UsoUN7CjCv0xi8Qh52uP2S4OZxW0J3dXQqVGDJ6KnqWGqK
	 /I9ipGt8IaAqneKwN60W96V0OfJ6tiarQp1caTYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@sina.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 199/265] dm cache: reject kcopyd client destory if it setup failed
Date: Thu, 26 Nov 2026 15:38:49 +0100
Message-ID: <20261126143619.120033497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@sina.com>

commit 8b97b168eb4d3affcf23d2980a0c3f35ed9262e2 upstream.

The value of cache->copier is -EINTR when failed to create a rescuer
kthread for wq kcopyd, in cache_create(), the code jumps directly to
__destroy(cache), it merely performs a simple check to see whether copier
is NULL, potentially hitting:

BUG: KASAN: null-ptr-deref in dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
Read of size 4 at addr 0000000000000174 by task syz.2.19/6560
Call Trace:
 dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
 __destroy+0x172/0x2f0 drivers/md/dm-cache-target.c:1973
 cache_create drivers/md/dm-cache-target.c:2604 [inline]
 cache_ctr+0x1674/0x2bf0 drivers/md/dm-cache-target.c:2649
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]

Set copier to NULL to avoid destroying a invalid kcopy client.

Cc: stable@vger.kernel.org
Fixes: c6b4fcbad044 ("dm: add cache target")
Reported-by: syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a2626a25eb2595e3ec3c
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2582,6 +2582,7 @@ static int cache_create(struct cache_arg
 	if (IS_ERR(cache->copier)) {
 		*error = "could not create kcopyd client";
 		r = PTR_ERR(cache->copier);
+		cache->copier = NULL;
 		goto bad;
 	}
 


