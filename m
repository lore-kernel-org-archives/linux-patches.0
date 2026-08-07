Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF36E3F4101;
	Fri,  7 Aug 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113771; cv=none; b=AYJFFDca7lklBD5YvQe+Ig13ri732xUYKEtZSOrJgdhLsR4NXfBrS8CkbVXjcpBogIWF/QgVPxYHNh/35zSZEtjm9fDk337cDjtfRX8rc83Jp7puxoOeFS3odXPy4PjTDPtqDCgMLkD2WOLYZ/aU2HZcFNWYOr/sTTGzdVCbBgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113771; c=relaxed/simple;
	bh=iV6Tew5Y1ksb+zrmKw3wBMPmhnQSYQ7Jr5gOHq8Blqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=latoHCBQg7n7Wcn1dE0kxzxEjJwvRh23MpPCXeprsg1shmO5PUt7dZtZsSmY30xuLwiuiWJm2+WgToCzI7lIoNHnavQZO1MUqnkUl1XYFXWH2UjEkvxCqva0Uf4d6qdj5ql+PUckpeGqMePzS/q3a3NX0mwogXr5RjjcAzYSqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/P54ZQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/P54ZQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694DC1F000E9;
	Fri,  7 Aug 2026 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113737;
	bh=qTZNBoSOA/ekdMMBFz1bj3UqNaPEWGMWz4oopJG/HYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/P54ZQoD0ukLhpRNmOflmgcwA0CzAKTYKGH2PuifhwAESptDEnQ/S+mrtHuttYo3
	 E0tAVSNKpz7sejt7Jg5A6RhL32MfIEN/Ck2C930mXYQOPV6T9IpOJ/+trfIL8y91nQ
	 CeYcj1e3B3kslmpHzpCKHNat0qug7CO6zAh6kdlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Markus Boehme <markus.boehme@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/337] netconsole: avoid OOB reads, msg is not nul-terminated
Date: Fri,  7 Aug 2026 16:33:41 +0200
Message-ID: <20260807143418.914936660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 82aec772fca2223bc5774bd9af486fd95766e578 ]

msg passed to netconsole from the console subsystem is not guaranteed
to be nul-terminated. Before recent
commit 7eab73b18630 ("netconsole: convert to NBCON console infrastructure")
the message would be placed in printk_shared_pbufs, a static global
buffer, so KASAN had harder time catching OOB accesses. Now we see:

    printk: console [netcon_ext0] enabled
    BUG: KASAN: slab-out-of-bounds in string+0x1f7/0x240
    Read of size 1 at addr ffff88813b6d4c00 by task pr/netcon_ext0/594

    CPU: 65 UID: 0 PID: 594 Comm: pr/netcon_ext0 Not tainted 6.19.0-11754-g4246fd6547c9
    Call Trace:
     kasan_report+0xe4/0x120
     string+0x1f7/0x240
     vsnprintf+0x655/0xba0
     scnprintf+0xba/0x120
     netconsole_write+0x3fe/0xa10
     nbcon_emit_next_record+0x46e/0x860
     nbcon_kthread_func+0x623/0x750

    Allocated by task 1:
     nbcon_alloc+0x1ea/0x450
     register_console+0x26b/0xe10
     init_netconsole+0xbb0/0xda0

    The buggy address belongs to the object at ffff88813b6d4000
                which belongs to the cache kmalloc-4k of size 4096
    The buggy address is located 0 bytes to the right of
                allocated 3072-byte region [ffff88813b6d4000, ffff88813b6d4c00)

Fixes: c62c0a17f9b7 ("netconsole: Append kernel version to message")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260219195021.2099699-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ mb: adjusted context; in 6.12 the affected code lives in
  send_ext_msg_udp() and writes to a static buffer instead of nt->buf ]
Signed-off-by: Markus Boehme <markus.boehme@mailbox.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 60375bb814a1e..3b76ec3cd49b8 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -1103,7 +1103,8 @@ static void send_ext_msg_udp(struct netconsole_target *nt, const char *msg,
 	if (msg_len + release_len + userdata_len <= MAX_PRINT_CHUNK) {
 		/* No fragmentation needed */
 		if (nt->release) {
-			scnprintf(buf, MAX_PRINT_CHUNK, "%s,%s", release, msg);
+			scnprintf(buf, MAX_PRINT_CHUNK, "%s,%.*s", release,
+				  msg_len, msg);
 			msg_len += release_len;
 		} else {
 			memcpy(buf, msg, msg_len);
-- 
2.53.0



