Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211356;
	b=arBhhidBaQ4tcsOtMD7UMpwD9qIenbJSjK+WoalzzzhJuiRDqBViEUlnx+uVDSq5b65G
	 21zs9zf4ZeuKhzXSCrjJCe295hvwiT+dbmiM65UlnSfHXbAHZNf5u3mr81CM9sgAI/pLx
	 SJ/AvFgFt6B68e6tJbiMPn0EH2MYxNZ7Yd2l7NszLTCs+tpfHn9tKkcGengc3iOhI27xp
	 7Vqvu9OoH+J5JhmXYBmItBkSt07JUFCfZYMG004vuMhXg/GcMWl6cC39IRqpUChVjpVds
	 y/OmobC47RYh8esnKGBxcNJcmRcVKGPNX8aZLPELb456R1kZJ2QX80t1G2os4dN+z3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g65EvdersRhwYzAwknB8wVaEtMzT1nct0tUbNj/WGac=;
	b=3+oIpBNyq+9zg5pZOgS7hpCUrB4aapFvgEeIxH5zbYdYJ9oOd/Q0Nf6+vY39sx5hH2su
	 4gTO50XebsyKNxQMklkDNZoiYIBRDIUxwcJFStkNSls3EByVLhgrPe1UwgB3NkuXNtEjR
	 ZkTYe2xmUEu8U45dzKi3wuG3HXZqbo4J0ujQWbbzCLIb4bjMIJy7gGQYi1pYNVqjVkdfH
	 pOJZzeFX3busJmVnolbbV8PSWGUTiaVccHPY4pbnjx6WYycPhf4tPafdYqYj/9VG9vW7J
	 /OJ2ytClsGk2cVE8UujF7G1i1+4EclBRK3edaWLi3eNHQTj8wsGcTdeqUen189tB7oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x/AsP+Ko";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831A7606A96B;
	Wed, 28 Oct 2026 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x/AsP+Ko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24481F01825;
	Wed, 28 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211356;
	bh=g65EvdersRhwYzAwknB8wVaEtMzT1nct0tUbNj/WGac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/AsP+Koki4aqG87/QVHiE+LyFpPaNrtXfdkHdyoTWdal+MQax+T15TLQDNYVRsH5
	 +fsZfzF0pSeuJ9kMOd1wq0YAegV7pAMYaGGnI1Ft60EbO6fZFaIQ1BSCIRJoKd+VCF
	 Fy3TqK5J7vXb9D75L6/RqfKYy/1E6iEiA4Wym4nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 348/571] dm ioctl: dont let data_start run past the buffer
Date: Wed, 28 Oct 2026 17:58:15 +0100
Message-ID: <20261028170016.274594855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Palla Raghunath <raghunathpalla.0209@gmail.com>

commit 9b3fcf519d370df94a56f3b272d9eddffffa5be8 upstream.

struct dm_ioctl has seven bytes of trailing padding, so the smallest
buffer userspace is allowed to ask for, offsetof(struct dm_ioctl, data),
is seven bytes shorter than sizeof(struct dm_ioctl).

get_result_buffer() sets data_start to sizeof(struct dm_ioctl) without
looking at how big the buffer actually is. Ask for the minimum and
data_start ends up seven bytes past the end. Callers add it to
data_size, and ctl_ioctl() copies that much back to userspace:

  BUG: KASAN: slab-out-of-bounds in _copy_to_user+0xad/0xd0
  Read of size 312 at addr ffff8880169e4c00 by task repro-dm/140
   ctl_ioctl+0x5e3/0xcb0
   dm_ctl_ioctl+0x25/0x40
  allocated 305-byte region [ffff8880169e4c00, ffff8880169e4d31)

A DM_LIST_DEVICES with data_size set to 305 is enough to hit it, and the
seven bytes that leak are whatever sat next to the allocation.

Clamp data_start to the buffer size.

Note that this is not a security bug because the out-of-bounds read can
only be triggered by root.

Reported-by: syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=48d935cf48a4a76be346
Fixes: 76c072b48e39 ("dm ioctl: move compat code")
Cc: stable@vger.kernel.org
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -538,10 +538,16 @@ static void *get_result_buffer(struct dm
 {
 	param->data_start = align_ptr(param + 1) - (void *) param;
 
-	if (param->data_start < param_size)
+	if (param->data_start < param_size) {
 		*len = param_size - param->data_start;
-	else
+	} else {
+		/*
+		 * The buffer can be as small as offsetof(*param, data), which
+		 * is less than sizeof(*param), so don't run off the end of it.
+		 */
 		*len = 0;
+		param->data_start = param_size;
+	}
 
 	return ((void *) param) + param->data_start;
 }


