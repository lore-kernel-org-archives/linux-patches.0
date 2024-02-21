Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B813169D09;
	Wed, 21 Feb 2024 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521245; cv=none; b=lssUawNkHu4LRQ9AnZs2ph/7Xn9z3Jg4MaNgkSviWitqDRDOt2jfnut6kaWY3Ri5GTjEjG1MQ5tN0b4oCjWtc2PYZlwWRLxj/TBfPW3s67/llmNLodOTN+SJ+uxQoe+fOdmiGgHV8O5tX+Vi7OIMkj1psTpRqyNUCmEMaliKoik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521245; c=relaxed/simple;
	bh=9R8wcQPJwuGnE11ob7SIgYDDAhVZ+tULda1Q6vqc0h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVZ0PFMI8uJz/z5lgn+ZzqaX6tUCptMcwIg+84WOQnrJjJSoVL/1g7NW6hopbhxZrZY9FRyxz3QopNOldPbOlcQ1o7re2iIT5l9Q+7osxLQtKVXdwhFuKeLcmiO4AsMHqVgVtazuRLiYSP1s7CDO9ZWEzS5MiDHmjoBUFipcrMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r685LTmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r685LTmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD5EC433F1;
	Wed, 21 Feb 2024 13:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521245;
	bh=9R8wcQPJwuGnE11ob7SIgYDDAhVZ+tULda1Q6vqc0h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r685LTmRpXWUzzPTHPtICcQZxEOeHnVBR/Vw6Z4JCL6Wsw/gFtW8JT+QySUc5RJ1L
	 pbDdt432PDED6/yjn22sbHbgVunsIA1TMn/fzJjxKcc6tkgJOE7IAniqU6nyyzN/Pb
	 b55jQ84huCTUAHDl0oRF4ZkcdnVQpnr1FPGSxxDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/202] jfs: fix slab-out-of-bounds Read in dtSearch
Date: Wed, 21 Feb 2024 14:06:01 +0100
Message-ID: <20240221125933.784762726@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 320c9f42b65b..ea2c8f0fe832 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -646,6 +646,11 @@ int dtSearch(struct inode *ip, struct component_name * key, ino_t * data,
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



