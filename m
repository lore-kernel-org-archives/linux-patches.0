Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193E1332EA7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301252; cv=none; b=p6UdkmrJz4Il/JwfdaPSKTfmzDbj8a2XTs68Wwa4g2G4ab7TeG1pLtlzu0qCBuJpvvgiOViYFbiAe7FMMKgNtbPgwsRBynKcwT+BwtVg89SOTwXGc8igwHkZ8FPV7KmV1p9mgHE9BbsE3wXsUKmCGz7QEJvrkLeDVRBvuqwkDH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301252; c=relaxed/simple;
	bh=wLnGYIO1KiFbF9Rz0ZPeAWdh5P9kAdVTUKFmcRK6Mtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TubCwmyjRXaaxW7JL3Abkdbcpof+1MFclFm7PgvoyLMLRTNwQs/CLRsgx88vonoEuysDR+xDUfJ1+FdoRRjfrb8voFfZFZFubkwFx3lkVkGlUttXFphkld/QbyFTdg3cHKP91L9UNDMelYim9vjheQsbTW2x37WSoJ7SAmOVN8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N53qF4Sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N53qF4Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661AEC116D0;
	Sat, 28 Feb 2026 17:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301252;
	bh=wLnGYIO1KiFbF9Rz0ZPeAWdh5P9kAdVTUKFmcRK6Mtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N53qF4Sn4/wfSwbGKbf4m2SqOHHUFpR9eIZbaMy89B1q65ElqvMfyz98s/8ylQ8sX
	 Vn9VQhrU7KMSEWZiOXFiVhZqJnOZPd60ThKBdg/K/OHJGRktdwZsITfoqw0UpCWudx
	 xaTU5VeqvE57kzNM/zoVAPpmbIkKnkwX6+kR1s48PEo2kKeDjYyERfrDfsdhbDx3+a
	 RayttD9FymF1R67gbYVWmjcU7AnFqI8RpBEE1yEkFOrQV1vjNbnLmOty68jXA4O1pH
	 BXxqQxOH5/SHCE9p8+YHZeFf1kTnwV7thTCcGBClfGtUUqx7qqLrk3eDIv2SNmbR7n
	 wbcvlmTkjsSIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 434/752] netconsole: avoid OOB reads, msg is not nul-terminated
Date: Sat, 28 Feb 2026 12:42:25 -0500
Message-ID: <20260228174750.1542406-434-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index bb6e03a929565..020252961c906 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -1537,7 +1537,8 @@ static void send_msg_no_fragmentation(struct netconsole_target *nt,
 	if (release_len) {
 		release = init_utsname()->release;
 
-		scnprintf(nt->buf, MAX_PRINT_CHUNK, "%s,%s", release, msg);
+		scnprintf(nt->buf, MAX_PRINT_CHUNK, "%s,%.*s", release,
+			  msg_len, msg);
 		msg_len += release_len;
 	} else {
 		memcpy(nt->buf, msg, msg_len);
-- 
2.51.0

