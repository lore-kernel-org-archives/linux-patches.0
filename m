Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D843B2FD7C3;
	Thu, 28 May 2026 20:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998660; cv=none; b=uR9AFf/lDU2/871SoIS5lzxPg+OZ56jMrVjIHx2J4H8uOsqKIa8N2RzUrXssTbbApfoUGWQqUgnDK/ZlyyO3yt1FpZH8ZE8W1FqRtCFe/LtrvGdDqaA/k902ph39u9c5yfSYlMdli3SKEZ0KGkbzb04AdJV14erPYBNBFV1p/as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998660; c=relaxed/simple;
	bh=If0CMijFyf77K1iE5mhwTItxyT5QcWW9CAPX9/Ed7ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGsv4+MgobjAMDa3LFwfhUofmYZFS8G6i3cI+DmrVe7fjFt+rt3Or6cT3crNR7vB1E4SFtiIlzuI6ckCf6ZKo3PmGlpt8sHXmVj/ECOhAAtmv/KL6nNZbb6K0qHFWhM0p+LfNgNG+Appsp6xOJHG1s1zv6fXPu3t7OSq8MYwN8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSZnj5sv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSZnj5sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410271F000E9;
	Thu, 28 May 2026 20:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998659;
	bh=OA1DnNxX/hWA8K9M/ELvB4EsvI6V9rNujhtD0q4RlJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSZnj5svIPeygaiEKavniuCWR0l2oFeDq+p3aHcBb+scgAR6Vjmv0rQC7/86JeQu9
	 BsdmJWigVyUo6a53kt6LBY7PN/UCiawALekZsxAW/oVOtq48k7Qu8gIreEmLwYPDaz
	 IrG9aQj+5H+R7E5EIccRshjiyg8fKNRaKzmWAda4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyoung Jang <graypanda.inzag@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 235/461] fs/statmount: fix slab out-of-bounds write in statmount_mnt_idmap
Date: Thu, 28 May 2026 21:46:04 +0200
Message-ID: <20260528194653.942216380@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junyoung Jang <graypanda.inzag@gmail.com>

[ Upstream commit a3bf0f28d4ba16e1f35f8c983bb04426b87e2a78 ]

statmount_mnt_idmap() writes one mapping with seq_printf() and then
manually advances seq->count to include the NUL separator.

If seq_printf() overflows, seq_set_overflow() sets seq->count to
seq->size. The manual seq->count++ changes this to seq->size + 1.
seq_has_overflowed() then no longer detects the overflow. The corrupted
count returns to statmount_string(), which later executes:

    seq->buf[seq->count++] = '\0';

This causes a 1-byte NULL out-of-bounds write on the dynamically
allocated seq buffer.

Fix this by checking for overflow immediately after seq_printf().

Fixes: 37c4a9590e1e ("statmount: allow to retrieve idmappings")
Signed-off-by: Junyoung Jang <graypanda.inzag@gmail.com>
Link: https://patch.msgid.link/20260504112649.1862936-1-graypanda.inzag@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/mnt_idmapping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
index 6472c4ea3d1e6..cb61fbdb52e90 100644
--- a/fs/mnt_idmapping.c
+++ b/fs/mnt_idmapping.c
@@ -375,6 +375,8 @@ int statmount_mnt_idmap(struct mnt_idmap *idmap, struct seq_file *seq, bool uid_
 			continue;
 
 		seq_printf(seq, "%u %u %u", extent->first, lower, extent->count);
+		if (seq_has_overflowed(seq))
+			return -EAGAIN;
 
 		seq->count++; /* mappings are separated by \0 */
 		if (seq_has_overflowed(seq))
-- 
2.53.0



