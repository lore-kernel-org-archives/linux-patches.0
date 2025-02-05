Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AD214A4E9;
	Wed,  5 Feb 2025 13:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763132; cv=none; b=Lbb2f7rXzLD+OoZaKyD/EOLHskNEK/j4dT8YtJEP/N8lblKGl+6strHh2OLEX5h16PZ6wmV4bpPbEs8KFHDtRmPAyxdjjYaSaehBL0PE+slSANW8BpIHG30XHvE96ZGu0NucpDFreM60ooopmonWohyVw6hcf4FWMFOH+Rh3Ng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763132; c=relaxed/simple;
	bh=EbHBpOM15JQQBQ2qNk/wu+QK5kBPK12I3PCTPtJ/Sxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gK9QXnioWe+OiC63C9MU5XMKIir8Mu7+ulb9HQ+pH0gwV9iFeoIt6U35o40QZdaaX4pVhqjVCG/D2yWQZcAHHFWWtcF+Yr/ytJVoOb5TV1BmA1XGmraSMC3o14CGq5SDNdQ0NmnNFSKkUmBNb5bTgnh70LIPwL1zx7aP3w5To+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYV7GhGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYV7GhGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE55EC4CED1;
	Wed,  5 Feb 2025 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763132;
	bh=EbHBpOM15JQQBQ2qNk/wu+QK5kBPK12I3PCTPtJ/Sxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYV7GhGAojLMuihpO9/nqxrqG5PZ2++vcSU2fASLr2vTyf706nlTRJXngQNNHkWpY
	 wr/JUCoiHIiOnDXNOmrmdwoYQCJaNlnugbTW1X6VucK5ap3HZNup+/gd8RFb9IYUMm
	 JP2Laj6e0LfS2IfOdc2MzCmhZhRevpYxM/ChTnYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/393] powerpc/book3s64/hugetlb: Fix disabling hugetlb when fadump is active
Date: Wed,  5 Feb 2025 14:38:40 +0100
Message-ID: <20250205134420.344308523@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit d629d7a8efc33d05d62f4805c0ffb44727e3d99f ]

Commit 8597538712eb ("powerpc/fadump: Do not use hugepages when fadump
is active") disabled hugetlb support when fadump is active by returning
early from hugetlbpage_init():arch/powerpc/mm/hugetlbpage.c and not
populating hpage_shift/HPAGE_SHIFT.

Later, commit 2354ad252b66 ("powerpc/mm: Update default hugetlb size
early") moved the allocation of hpage_shift/HPAGE_SHIFT to early boot,
which inadvertently re-enabled hugetlb support when fadump is active.

Fix this by implementing hugepages_supported() on powerpc. This ensures
that disabling hugetlb for the fadump kernel is independent of
hpage_shift/HPAGE_SHIFT.

Fixes: 2354ad252b66 ("powerpc/mm: Update default hugetlb size early")
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20241217074640.1064510-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hugetlb.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/include/asm/hugetlb.h b/arch/powerpc/include/asm/hugetlb.h
index ea71f7245a63e..8d8f4909ae1a4 100644
--- a/arch/powerpc/include/asm/hugetlb.h
+++ b/arch/powerpc/include/asm/hugetlb.h
@@ -15,6 +15,15 @@
 
 extern bool hugetlb_disabled;
 
+static inline bool hugepages_supported(void)
+{
+	if (hugetlb_disabled)
+		return false;
+
+	return HPAGE_SHIFT != 0;
+}
+#define hugepages_supported hugepages_supported
+
 void __init hugetlbpage_init_defaultsize(void);
 
 int slice_is_hugepage_only_range(struct mm_struct *mm, unsigned long addr,
-- 
2.39.5



