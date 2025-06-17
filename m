Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3F2237162;
	Tue, 17 Jun 2025 16:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176732; cv=none; b=kjGPaey2CV50QQDGv9hI/XJI/NQpCAmM67HrqqUvX7w23MBXxX2ccDRk1wfY+RMcVkIuMeBuVr4HuxS00Umnk16uqVLMR0h8G1Gf334sZf4PXnQkwDKq4utQfSMF+RuJnkx9k5DvkVH+AC2xHVrBIzkd5Z/81jB1WIlXANjHncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176732; c=relaxed/simple;
	bh=YwQQ/89n34L7Tw819CFhAwd1PSZgVcAvf8v3R8EJvrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1PWPa/Afhz3wIwDpd6cxStnHWt+/xrAJ8NSlz5vRsvEgSIEKSV2aSiVE3bWJW+EbyGLBPuFug1IYOG+DHGGBZQP7UNW7jnnqdy+g65F/1DR5TyPjF1WBtfiwqxtm6vQIJCjId6ms7ADw5gRxZp+nYkUtO68KkkNp05Hd/o3fB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAh7VcoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAh7VcoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0E2C4CEE3;
	Tue, 17 Jun 2025 16:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176732;
	bh=YwQQ/89n34L7Tw819CFhAwd1PSZgVcAvf8v3R8EJvrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAh7VcoW2pSqVYmGVtIkkI3JcN2tIfDxKwm6fTkBCoOhO+6HDPzISa1pUfyGPGYNv
	 XaRDT31Hp0rZND3+vLuuk4bGqYJ1wk6GHrj2OCUNcBjVkyqAN0JmL+7ZrKWveZwBCR
	 ihmxJAFrxmqeGAKcKq9Ai7lKExz/lrTjDMW9YOuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/356] powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()
Date: Tue, 17 Jun 2025 17:27:03 +0200
Message-ID: <20250617152350.564955032@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



