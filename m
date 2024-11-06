Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1614A1DED49;
	Wed,  6 Nov 2024 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895683; cv=none; b=WJo39aZtg02eLCefr/K+jfdv+XdYTVxqUiMTiPT/jTJdT5P2K/9qYV54KXxcr2xxDQZeLf3s8W+91hFZO0VM/Cm8xJoyvf6bk4FLgWvQYCkXRsclivAt/ksrZ1XwAUV+UdKUU5dSCggYn4al0JisYoQQLPQxySO9okSwkeVtL1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895683; c=relaxed/simple;
	bh=gUn5gs9yBIBW2szbV87iOY8+l9TCjYMgYtJLDVzNl8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb7THaDBz+RzuPYkNQGSzvsfzIDP4LlFr/TeEuZSMDiAxUBhX7kMQamwF3/ZB8YcNIFq7EMvly+0Q0n2iv6i1AZB4ygGmfAAAaY4Yn7xtuTqEhsrMfj0rzQkXL4oKFfaIPji3H5dIB4r/DwdAs2A/XD9o0guwpYvO4oyPSirdk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2e8lFPbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2e8lFPbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61358C4CECD;
	Wed,  6 Nov 2024 12:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895683;
	bh=gUn5gs9yBIBW2szbV87iOY8+l9TCjYMgYtJLDVzNl8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2e8lFPbtyPKEyTCq4FZX36m3/7KLaEI8yXphxbjJSJovHWRm72R8/EL6pCC/7mTvA
	 82CmWl/Qfe/RHOjV4VzcvP9uJxYFseY/ajmtxTL8IAKlQBy7vzP6sHVtTGwyqHP2XN
	 bMhuSdaX2YY/LwUzj3Xkm7jywh3a5NoxAjTIGtmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 301/350] Bluetooth: bnep: fix wild-memory-access in proto_unregister
Date: Wed,  6 Nov 2024 13:03:49 +0100
Message-ID: <20241106120328.234911481@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a16d584a6c0d0..e1cfd110d281e 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -744,8 +744,7 @@ static int __init bnep_init(void)
 	if (flt[0])
 		BT_INFO("BNEP filters: %s", flt);
 
-	bnep_sock_init();
-	return 0;
+	return bnep_sock_init();
 }
 
 static void __exit bnep_exit(void)
-- 
2.43.0



