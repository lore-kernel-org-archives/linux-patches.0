Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312994C6E;
	Mon, 23 Jun 2025 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686231; cv=none; b=SPs3IsS1AWsIbh3c3g6fmULDsCfMMf4b58eAvMgsKom58OadzZd8BQBCMWF7bhbrgwMh5foWEQP4/8vEf9OgdFirsdZcbEmw5x76lQCE5ajg4iJlAP6SP/VIjmuFMDPBObGNRvM3Cmhy8aTprKaFlPdKAipNLIcTbKCNn8PklcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686231; c=relaxed/simple;
	bh=8/yjF8Qut8CeLHQQRSZryp8GsfAXabGCc9TBwvOYErw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLnJxyyVJUyYGqmsSbo9321o8X/pyZlW2vY5oWZn7HeeC5nAMNVPI6nLGAAt1VUwmGN9slTf17IpZIUDp7LRiWWW+Sl1ii2tXUGVd03OxW+pcu+am9L8LrxazO1KNhGVQzuwzwUC/ZrCpOi2jhSJsSnc+3lrYDxxls9hND13OiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9PJ4Kir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9PJ4Kir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91B3C4CEEA;
	Mon, 23 Jun 2025 13:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686231;
	bh=8/yjF8Qut8CeLHQQRSZryp8GsfAXabGCc9TBwvOYErw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9PJ4KirWnHFh4wW9ac4CYz1Rs20B6fhRvijv6uNG9tB9bPUDE5oGiIlJBT6arRaE
	 3+HJ2Qn83OkC+7y1p/2lmPgFSKhpuuRM/FhABUOjfMk5wVPgKaWeBOKqQOu9yr6NCQ
	 fbFsw8MChEOw80Ea4HmSZbr+fBvVWvLzSWg5IA/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/355] powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()
Date: Mon, 23 Jun 2025 15:05:23 +0200
Message-ID: <20250623130630.420603055@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cfc9d7dd65abc..9bf6bc700ae98 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -162,6 +162,15 @@ static int coproc_mmap(struct file *fp, struct vm_area_struct *vma)
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
 		pr_err("%s(): No send window open?\n", __func__);
-- 
2.39.5



