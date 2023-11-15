Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C533A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyMeTQkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF10C433CA;
	Wed, 15 Nov 2023 19:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077386;
	bh=mBvWTI8kTWgh7Ud4TNUxr/FUakqnBi0c720MgZ6yD0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyMeTQkA7hODFwk9Ntj+rzHf1z7ONDyckK3ky88FUEgU98e+jJLxdlM1dodhv9YVT
	 j1Vq5qUx688kfIKK7q6mx4Q7AKZuwinlnO1QPaKOTzq8fe6++Ej416DX0TKauDLPM5
	 VExqXZjg3TzETiCn21YvJqywmCOuJdafwxCoUnwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/603] xen: Make struct privcmd_irqfds layout architecture independent
Date: Wed, 15 Nov 2023 14:13:28 -0500
Message-ID: <20231115191631.513382911@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 8dd765a5d769c521d73931850d1c8708fbc490cb ]

Using indirect pointers in an ioctl command argument means that the
layout is architecture specific, in particular we can't use the same one
from 32-bit compat tasks. The general recommendation is to have __u64
members and use u64_to_user_ptr() to access it from the kernel if we are
unable to avoid the pointers altogether.

Fixes: f8941e6c4c71 ("xen: privcmd: Add support for irqfd")
Reported-by: Arnd Bergmann <arnd@kernel.org>
Closes: https://lore.kernel.org/all/268a2031-63b8-4c7d-b1e5-8ab83ca80b4a@app.fastmail.com/
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/a4ef0d4a68fc858b34a81fd3f9877d9b6898eb77.1697439990.git.viresh.kumar@linaro.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/privcmd.c      | 2 +-
 include/uapi/xen/privcmd.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index f00ad5f5f1d4a..da88173bac432 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -935,7 +935,7 @@ static int privcmd_irqfd_assign(struct privcmd_irqfd *irqfd)
 		return -ENOMEM;
 	dm_op = kirqfd + 1;
 
-	if (copy_from_user(dm_op, irqfd->dm_op, irqfd->size)) {
+	if (copy_from_user(dm_op, u64_to_user_ptr(irqfd->dm_op), irqfd->size)) {
 		ret = -EFAULT;
 		goto error_kfree;
 	}
diff --git a/include/uapi/xen/privcmd.h b/include/uapi/xen/privcmd.h
index 375718ba4ab62..b143fafce84db 100644
--- a/include/uapi/xen/privcmd.h
+++ b/include/uapi/xen/privcmd.h
@@ -102,7 +102,7 @@ struct privcmd_mmap_resource {
 #define PRIVCMD_IRQFD_FLAG_DEASSIGN (1 << 0)
 
 struct privcmd_irqfd {
-	void __user *dm_op;
+	__u64 dm_op;
 	__u32 size; /* Size of structure pointed by dm_op */
 	__u32 fd;
 	__u32 flags;
-- 
2.42.0



