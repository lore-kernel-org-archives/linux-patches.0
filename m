Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5984C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D122C433D6;
	Mon, 14 Nov 2022 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430562;
	bh=kA2q5YNvbrCo9Tt+vzxaCI0Zr1L+aqaVS7iOlD4xI8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRP6rMxt8j8DaFKocylZx8BKAQecVjFG4si97cFjc8d0T+Sm0xZERYbH9T8eu/XuM
	 OGOmasJFgi/ZOKT89NS6WRmZaA4X5SETnxPjbVYHA/l4bMBOAmEb5xKCr7XlaiIvF9
	 crAtceqEJC4AtaCzCcloimsOfq7AioB/QZAvzwIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	"Andrew G. Morgan" <morgan@kernel.org>,
	Serge Hallyn <serge@hallyn.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/131] capabilities: fix undefined behavior in bit shift for CAP_TO_MASK
Date: Mon, 14 Nov 2022 13:45:03 +0100
Message-Id: <20221114124450.135184837@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 46653972e3ea64f79e7f8ae3aa41a4d3fdb70a13 ]

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in security/commoncap.c:1252:2
left shift of 1 by 31 places cannot be represented in type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 cap_task_prctl+0x561/0x6f0
 security_task_prctl+0x5a/0xb0
 __x64_sys_prctl+0x61/0x8f0
 do_syscall_64+0x58/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>

Fixes: e338d263a76a ("Add 64-bit capability support to the kernel")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/capability.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 463d1ba2232a..3d61a0ae055d 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -426,7 +426,7 @@ struct vfs_ns_cap_data {
  */
 
 #define CAP_TO_INDEX(x)     ((x) >> 5)        /* 1 << 5 == bits in __u32 */
-#define CAP_TO_MASK(x)      (1 << ((x) & 31)) /* mask for indexed __u32 */
+#define CAP_TO_MASK(x)      (1U << ((x) & 31)) /* mask for indexed __u32 */
 
 
 #endif /* _UAPI_LINUX_CAPABILITY_H */
-- 
2.35.1



