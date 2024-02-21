Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DCE7BAFB;
	Wed, 21 Feb 2024 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525261; cv=none; b=oIKP2XAD1qMwuq5AgLrstv8uoJJS+iYbAt/LdHEM6ohhqvF4bZjYW0kvU91nVvCe6qHHEMOX3ao0DNGY3Ejb8awmmeI8m2iShi2WyZrxNAPVMzNkddjJSEDEMUhfA5IX+BZ8UJcKrpBLCOGx1lC1x0ffNjoE90j1uGycpmjS8Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525261; c=relaxed/simple;
	bh=vkHuUg7K+rRIjab9Stc987kpyk37oFrqmkLICGBDVXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu7PLi+PsB2dL5CZcWN/Xvg67Ug+P48ig/5QnsNFzioz5YT6boiF/20cdaJ84AfYj/ZZ396ybyAs3ZNYQZCsWxv0lR4MD0KI4SGOJ6PZ/aCeXgx0CeV6WYw9JY8pRakBHip6ihikW6T1GyZqmZQtgBXp1cyp8aEgtOHJsrEqsHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1LFbLGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1LFbLGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9224C433C7;
	Wed, 21 Feb 2024 14:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525261;
	bh=vkHuUg7K+rRIjab9Stc987kpyk37oFrqmkLICGBDVXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1LFbLGQIOr1sWf0a5eWaNNJrUGA6n2fu/zOqRBvPxU3qnm7FyFik28qhkd13Woar
	 I+8Bupz6Ie6FNjt8/ZbokJJrp8SsvFEcb26AmH3/XvM0aMwY6SMIHfhmHe98B2dx3f
	 0L/t96i9TPFsz+1ZE0MCDaZga9efUsoB/EcmU5VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/267] jfs: fix slab-out-of-bounds Read in dtSearch
Date: Wed, 21 Feb 2024 14:06:56 +0100
Message-ID: <20240221125942.339109433@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a6d42e49d156..077a87e53020 100644
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



