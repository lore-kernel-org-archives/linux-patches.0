Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8357D7C6C0;
	Wed, 21 Feb 2024 14:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524019; cv=none; b=U3CU7AVN6CrN1qVMYpeVnMKfs+fowB0ZomLSUuscMQRqJ0ivm1KN2Oc7oigXObBdpS8YdO/7ejp48YFJwgj4Ux1PriZsTqU9MHwpLyH75fu97lqrZyI6DOEaRvXVS+PGwgGCC4ZFOsVOF6Dsv3jw3BdKgW5vLlkZJAuRIen7B/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524019; c=relaxed/simple;
	bh=aamcWPAk7g5u49/GZtbfyBwwp3JR03/jhAerAiNYYM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiTVAMWnEN0EG9iI4KKwsGpX6eMJLR9HN5d0rIAs93JYw1Ss0nHNu+GkJwW4/QwYYo7ZxRC7BbS78YbXa1M94PAp6wp4ZF8HNzksX7GhEIRNuY2GWoFYjT8v0oarhJluVZCSaFFagnxJshMaUxKFTcUCWbk7vI8q+lTpFQreFdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8rJaU/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8rJaU/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D9BC433F1;
	Wed, 21 Feb 2024 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524019;
	bh=aamcWPAk7g5u49/GZtbfyBwwp3JR03/jhAerAiNYYM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8rJaU/glXPPvZqzKqJgg0XzCqiWsxVr9As6Co5YHxTs4LqKeZ8E65RxBPsYpZStV
	 cnOJW60U+Bd4BdvyuDeuxyFqKZc9N57ViHz3hjhSED/ew8XBdp/KY2YrpSk//U5jeS
	 J+UoBOWE0xfrvf19luQZ2m3MJ2XdXUtIrZMT5Q50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/379] jfs: fix slab-out-of-bounds Read in dtSearch
Date: Wed, 21 Feb 2024 14:04:59 +0100
Message-ID: <20240221125958.477385435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



