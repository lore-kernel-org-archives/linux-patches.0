Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E222FA627;
	Tue, 17 Jun 2025 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179229; cv=none; b=B7hlaGgIzInJKuURmJWYBZ6XvoQVHp5yeHSbXdyLQ+23va8ymL+QFsfQeUTdpVxG3xvXPX5IgLVbc6zet8F/HOw9ZuUgUxV/kO/pa98gXmDQTrqtBzMFO13Ye+dWzgkXUZ08lHAtGh9dystlqddlLhNsphn+qWQagY+JlLo7maU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179229; c=relaxed/simple;
	bh=ExFLiFIc5kF50gZsm6BSoPU5G0n9IXE87DQZh+ILaqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+caZODJrcB2IqPIzOd5SI8/a3kkbWIbVRZtOhWjILgN4n+bQ2jXVS2Y72TluwiUasAQjAhxz8BXzonj93SgwKF9O9g/zIxrRiwLQlBxcxM1xSNXUcqgxmeeUICZidDUF3hRe9AAwLBWbVY6dzPmkcZj+gSogdVjT1w2xQSkER4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CDnA3Si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CDnA3Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBDFC4CEE3;
	Tue, 17 Jun 2025 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179228;
	bh=ExFLiFIc5kF50gZsm6BSoPU5G0n9IXE87DQZh+ILaqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2CDnA3SiJz1JkhApI7ODgB3mnkcnmL8AwgLX7xPt9Cj1tV7ZSwDlY2td4xkbszarA
	 y/K0fTEM++nChxPSxYeOw/PhKm00rQytJJrMIrRHJk+63/I44FtpP184qvJJrzENBm
	 bu2tY+wtvczEqq/eOMUJN/pSu5kkM3tXidRnYJ4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 688/780] powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()
Date: Tue, 17 Jun 2025 17:26:36 +0200
Message-ID: <20250617152519.507646435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



