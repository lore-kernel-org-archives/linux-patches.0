Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B702FA64D;
	Tue, 17 Jun 2025 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178236; cv=none; b=NXRI9fXpc00aAdlDTEQFr8P7QA3UftWCCslLWjuPzJcfx/+8X9Q0eHggBTWMdmUi5M9O1nSwufGm5M4yStbHiN2qH/wHCXe6Z5zLZ4P1JC8pJnGyTjENUNQibaYvI1zT6nG8RcDI4tIDsj0LaSyOPXLPE84+PUKugPgellcd9pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178236; c=relaxed/simple;
	bh=Y8pNo12M6Jwa7XJqm4lLp12+YihR62puu6zQx5xJ6Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3HfwSPpHPWxp4n+TxTkS30vkuO8rWXnw25o7Hmmwe6cbvDLMfNo9TL0pOpRkbEmDYgiCfk2VPqhoFHo3TDNZLplQB4cHnYGCZxt8g400kYYfgwrseW84aUFS13IJXNXz/aVyTJ1xYO7uIZtynJKZSHEgnDa4ALhLr3sHZrghJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdqDl6tt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdqDl6tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B6EC4CEE3;
	Tue, 17 Jun 2025 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178235;
	bh=Y8pNo12M6Jwa7XJqm4lLp12+YihR62puu6zQx5xJ6Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdqDl6ttAMapPqTqV6O+osqEEfsuAU3stTlKWgDkKpK6aYQJZJy8fz8HMYsrB3xqv
	 LGP7tOVaGm67W8qZL3hSDn5V4I11rEZmaYuKhPFFh9GUuougND7rryIzxWIBLLxX0t
	 J6n1KQPII8izTsMft0C7PErhRTlbncfAfLhLQ3Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 444/512] powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()
Date: Tue, 17 Jun 2025 17:26:50 +0200
Message-ID: <20250617152437.552843652@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haren Myneni <haren@linux.ibm.com>

[ Upstream commit 0d67f0dee6c9176bc09a5482dd7346e3a0f14d0b ]

The user space calls mmap() to map VAS window paste address
and the kernel returns the complete mapped page for each
window. So return -EINVAL if non-zero is passed for offset
parameter to mmap().

See Documentation/arch/powerpc/vas-api.rst for mmap()
restrictions.

Co-developed-by: Jonathan Greental <yonatan02greental@gmail.com>
Signed-off-by: Jonathan Greental <yonatan02greental@gmail.com>
Reported-by: Jonathan Greental <yonatan02greental@gmail.com>
Fixes: dda44eb29c23 ("powerpc/vas: Add VAS user space API")
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250610021227.361980-2-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/book3s/vas-api.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index 0b6365d85d117..dc6f75d3ac6ef 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -521,6 +521,15 @@ static int coproc_mmap(struct file *fp, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	/*
+	 * Map complete page to the paste address. So the user
+	 * space should pass 0ULL to the offset parameter.
+	 */
+	if (vma->vm_pgoff) {
+		pr_debug("Page offset unsupported to map paste address\n");
+		return -EINVAL;
+	}
+
 	/* Ensure instance has an open send window */
 	if (!txwin) {
 		pr_err("No send window open?\n");
-- 
2.39.5



