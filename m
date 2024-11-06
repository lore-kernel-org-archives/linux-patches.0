Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114551E906B;
	Wed,  6 Nov 2024 13:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898909; cv=none; b=aGeP7/dt4ENgAbCfiE4fnSn23OZhDHm+l+j8RokruoD5tbVuCl/0PClsLcRdv2pu1yKQ3nBdFCoghHlPlsK/Qj23tQ3TADtPsjDOn9kziZn05OgXR9oEl7keW7OaLjrgFYkKLMOH8yzyFZgnUyOzu40kHxENJrMoUsB66v31/YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898909; c=relaxed/simple;
	bh=ScAn4b4QbPCs26JUGuzCWnPEDE4u4/rnVotZ33B0RtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJFAhX+Osf17JpxdLxVE3y7CqdJbzspFJYHdm7WsF2A420pgxXbxQKLwzGs3Yu3uQ7EhSVxB7zThsTHU5aN/EDfpxA15ps0z88j6+xUijnKOrawOA7LVxN4ZhmQwEYh0dsHnmSxOBVgXYndAqIWBz9XVFoFrYOY2RzktRkitp7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXhG+PHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXhG+PHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50281C4CECD;
	Wed,  6 Nov 2024 13:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898908;
	bh=ScAn4b4QbPCs26JUGuzCWnPEDE4u4/rnVotZ33B0RtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXhG+PHZEPKXKfJIfCnsRSWkpw1P3GAy9JQWXWBqH85nEIeePEb1aPu6TQw9qiH8t
	 G1w0meMJO5YlvptIOI1ayc0belc1mnS74/Sk9fQXkwWIZqVqnf1iGXYwkZuB8ep0iN
	 wdGlLf48sk2xI+yi6MdkGJ6imkbnZ2iK2of6p3nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 397/462] Bluetooth: bnep: fix wild-memory-access in proto_unregister
Date: Wed,  6 Nov 2024 13:04:50 +0100
Message-ID: <20241106120341.330254934@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 64a90991ba8d4e32e3173ddd83d0b24167a5668c ]

There's issue as follows:
  KASAN: maybe wild-memory-access in range [0xdead...108-0xdead...10f]
  CPU: 3 UID: 0 PID: 2805 Comm: rmmod Tainted: G        W
  RIP: 0010:proto_unregister+0xee/0x400
  Call Trace:
   <TASK>
   __do_sys_delete_module+0x318/0x580
   do_syscall_64+0xc1/0x1d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

As bnep_init() ignore bnep_sock_init()'s return value, and bnep_sock_init()
will cleanup all resource. Then when remove bnep module will call
bnep_sock_cleanup() to cleanup sock's resource.
To solve above issue just return bnep_sock_init()'s return value in
bnep_exit().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/bnep/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 089160361dded..d05beafd29527 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -745,8 +745,7 @@ static int __init bnep_init(void)
 	if (flt[0])
 		BT_INFO("BNEP filters: %s", flt);
 
-	bnep_sock_init();
-	return 0;
+	return bnep_sock_init();
 }
 
 static void __exit bnep_exit(void)
-- 
2.43.0



