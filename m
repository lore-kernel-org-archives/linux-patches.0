Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E902469951;
	Wed, 21 Feb 2024 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522434; cv=none; b=IPOGAAHThQ8zDKpCGO5TBRGz+/fDiUGVM1/J2RL2yV6TNWj+2qflmeviTRlMWU4ToQ8rsKdG8kTDtb/axoqwNBW+DUi9m2N45i22r4q+zghb30o0tO+EHWWtdOsfBS1DvbrqNa2pmxyNOW0vNpA58/Rtbaa6+gSsJhXpqI3tb3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522434; c=relaxed/simple;
	bh=fBsB3/5mAlhHmxQPO8V/T6EksugQMiOsNmXX51CpGYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK/jma/C34oAY2SCcGTLBhVORCoJiJHVf5FQwtb/+yVushMDdH/R+W8zbsqLJWO0t2lIEGYzUmcWdT4c1/e5IaFEf2uUL+Kn0aEo5F2QRFP01oXQIKzO2joo6+z+r+N/aSJAIbRLIqsbBpXSCFjZL5o7VuAHdRwWn2Ps00HpoDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbEaAD3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbEaAD3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25648C433C7;
	Wed, 21 Feb 2024 13:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522433;
	bh=fBsB3/5mAlhHmxQPO8V/T6EksugQMiOsNmXX51CpGYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbEaAD3tqX8i7bvai150cEmaM5Ni7a4GU+xfj0+DHUnoJ9WvmaKUHwEicK4zx3lX+
	 jwhySS4+LoNmtJZvCS04oUnfFHhhsIrDpN5xJ6WIEnsCHw/MjNV4GBX+qgkYOYjpUE
	 h3KbC8OvYQTRKtMtQ58Ty/2arA0UqtJcnRWdfhNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/476] jfs: fix slab-out-of-bounds Read in dtSearch
Date: Wed, 21 Feb 2024 14:03:17 +0100
Message-ID: <20240221130013.318272191@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Manas Ghandat <ghandatmanas@gmail.com>

[ Upstream commit fa5492ee89463a7590a1449358002ff7ef63529f ]

Currently while searching for current page in the sorted entry table
of the page there is a out of bound access. Added a bound check to fix
the error.

Dave:
Set return code to -EIO

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202310241724.Ed02yUz9-lkp@intel.com/
Signed-off-by: Manas Ghandat <ghandatmanas@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index fafcb90219cf..a222a9d71887 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -633,6 +633,11 @@ int dtSearch(struct inode *ip, struct component_name * key, ino_t * data,
 		for (base = 0, lim = p->header.nextindex; lim; lim >>= 1) {
 			index = base + (lim >> 1);
 
+			if (stbl[index] < 0) {
+				rc = -EIO;
+				goto out;
+			}
+
 			if (p->header.flag & BT_LEAF) {
 				/* uppercase leaf name to compare */
 				cmp =
-- 
2.43.0



