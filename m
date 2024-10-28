Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930E518CC1F;
	Mon, 28 Oct 2024 06:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096886; cv=none; b=i86vZGoHwmwhTcVkzT2xNGyI439MZvzQAptKRPXHN/05iyToFli4/TyZPyE6LjFUqbcKu2/EHuZjk2/ahpBj4NPliuEtL9Bt7tM2BD5PcPcEk6N5bNdNwtf9yu+mIu4xACSKOFYEowONmtCJWo0lTrgEseh4o5Z5mmFzkfq7Q/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096886; c=relaxed/simple;
	bh=LcfPqFrlavnnF77Y8ch5qh0CFFXYil1xjE6hr8jw+MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8TqtNW2M0NVr+sbSaQyHqx38YGTzNxfigvuppFI8SDyxDWmEyCusI2YxG3KN13fS99XB6hAgpf/uvqscI01vcooOzEWRZNe7pKHpyb2Dc6z8uS1q7Q05lawDmilq9nJajKBB8j7OpFrAB7kVOnMdKrw6P0s7/YJ+A+7hUiZBCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lL3sZ5kq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lL3sZ5kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3071EC4CEC7;
	Mon, 28 Oct 2024 06:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096886;
	bh=LcfPqFrlavnnF77Y8ch5qh0CFFXYil1xjE6hr8jw+MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL3sZ5kqhhwpA7BVkDccq/NRLYICLQQh8vgbHIGrSUAk4/4owfeTJMVOFAF0s+Cak
	 mi2rmCaVWH6XOcz20PISIuV+8pvdjmJ39YZUC+fGP9PngMPPznJW/ALRZvALus7fFA
	 GMOd8kHmqG++YqX4AmucPhAbVZNR7j02bA5LHZT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/80] Bluetooth: bnep: fix wild-memory-access in proto_unregister
Date: Mon, 28 Oct 2024 07:25:09 +0100
Message-ID: <20241028062253.438425141@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8bb6c8ad11313..ca46441d0657b 100644
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



