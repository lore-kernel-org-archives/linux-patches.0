Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4958837;
	Mon, 28 Oct 2024 06:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098144; cv=none; b=juZ9x9vt2imEL3O8L/iMlML3219Ltx1QpFbQnx1NqcF2XeeCRh1tWs+CxZ5tl4BbhlqjDsBUw0K4yH1d4+rh13haHopiG5gjMwEyWea+jtwrBEzio8iD/sv7eXjDDoit/Fapvfo5KWTwRt+TTDMH1GqLprfiWRa0EwZsawgCLwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098144; c=relaxed/simple;
	bh=6PYaXre/ZoHv9b7CKjwZH9BHYNVsjRMRayWktefTU6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE659V5JoHnHUw+DKf+JZMQO4kmuKKQ2n1Jn8glsxjygn2x5NiIg/GpSO6p7yJc90JtUVA6HlAidPaBu6xF8LWOUtGHDPU5akMLl+rYFw25ZGqKIhvSk/Ze52GpG25UblXOqgvnAkpqUtzBS8JwjisXXPr7rX8MsJ8MM9Fm51lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZpuaE+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZpuaE+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002EDC4CEC3;
	Mon, 28 Oct 2024 06:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098144;
	bh=6PYaXre/ZoHv9b7CKjwZH9BHYNVsjRMRayWktefTU6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZpuaE+z/R27RIAoq4D6UrU+YnSpDrnvUi63u6bGaOTRfyc0OWDF0pbSq9KNW9WkE
	 Cl0jLtShEJ35OX5Ipg3GdfibfSQT9w99/KYUVLw7DYSqzp6yKRDo433TTw7FNtz4Ls
	 EaQQsnyKIJ3zj8CFunq+z0x2cJAJy8Radsxdubxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 095/261] Bluetooth: bnep: fix wild-memory-access in proto_unregister
Date: Mon, 28 Oct 2024 07:23:57 +0100
Message-ID: <20241028062314.412517309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index ec45f77fce218..344e2e063be68 100644
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



