Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247581C84A0;
	Mon, 23 Jun 2025 21:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715186; cv=none; b=UMFT51hKyFa5isov4S0xYMYsJmrWst+RriC+FXXb8n4BV2HhmmVaH4p8k6A+0qZLKRH3OznAl58R6f9u+SugAWmY8FDtTGF3PDq9edmN6xc218LTzNrYUcn0eNHDM4k/5KLGwWIJnfskqq6IZJ6wMKzEULNbRD53PdjU/0vtnVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715186; c=relaxed/simple;
	bh=sae+piEytPIA76lVBVi+KRvdNIhvoHLTVQ7gACmchQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1oMDbSD2DcCFNnTiyk07TL5WXl+p/cTqOI0nYu8SWAa0jOfeQOWCHKFmucucakC4ou/YhIyIAz8kmjKSMbxSjXWqf8BRp0RmhOawZ15DxtUnGd1XcudoqY1l9TZFPF3ZFgN9zRGA1dbL8xlub+c70sV8B9VRYLOyd2vThtG+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJKF4wgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJKF4wgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7232C4CEEA;
	Mon, 23 Jun 2025 21:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715186;
	bh=sae+piEytPIA76lVBVi+KRvdNIhvoHLTVQ7gACmchQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJKF4wgs1uipALn9fhAToQFW6ITcN/seehkKjZx+MVEf23qitldfFGHiyhFxco7GH
	 FVz9/+Mdi3koVxIa1ZaD7PqYiUdHFAAq/dmbKnZaD2pIonH/PVpAaQMLAr3gJnbJj5
	 GMQMlByo9VUDSDitZpq/DhzOO9NrpUAntDptthh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/508] powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()
Date: Mon, 23 Jun 2025 15:04:45 +0200
Message-ID: <20250623130651.159217111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d954ddf7f0592..0f73554c6ae90 100644
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



