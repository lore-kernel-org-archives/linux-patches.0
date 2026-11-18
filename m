Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037761;
	b=Qmz2vG/J0yzi5ytX5y0zXGFUJeXvjxPXExwBBoitnt8mQXfbznwEwS6Ik4yY3s1XXbJL
	 7dh0vONgYdSBwkEIInxWSlGUDlELNBxqJWGnEpJIVwTARDzvf12fPLecHQ9nFpjDAhrhG
	 pu6wZKadwdZ11ccgXXGnNm2Mvj8Em4NX0GRnLPAtQQp+cJlPmXRzWOCod4OABuYQ1+AOS
	 ut14M8ef7oFswHp90dej2dQmKAXYBRI/P7KN8Cs67KjQZvNHdpWzigpwlSuj4XFLHdD8k
	 RkSXV0ffXerJ708DgcBkLJKfRH6uD60cA4cyfytpeHCpdSIr8OX3ZSJLA+uaDruBSWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IS8ByGGaWarmnehd3FKHf1QKxLF5qbyhD4REpt/9fLg=;
	b=WoWcUe43AK3+E29NB5te199q9ANC2Gj7zop4cTbfgsmnnLrDPk6VzpV3CjuYEaXs3bAI
	 hZUqz+4NB5CE/chelCP+Caz2HxtWv1lHgfP7gbLvcVzhc1V/OyVPnfKv4g8EGQErK8GuC
	 wz27lag/VBcGDqww/fY5k/OfHIw8XSPI//65M8RuFInJKgBnC8xQnrt/dYHxD0zUeOBYw
	 i0sfxEMb0nnvI/pyXV2q9rDtXwA/ogpdHeKbeqBdy7F8BrISBFRwcp44kf03LvJSmDa2j
	 KAjvcswTSTmpub7SdLKVQM4DgYRvN/YQXbt5V72d8saUfKUqqcaKRYDsC3GV3upPqIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TSN7tCp/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D5C606A325;
	Wed, 18 Nov 2026 21:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSN7tCp/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2718D1F000C4;
	Wed, 18 Nov 2026 21:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037761;
	bh=IS8ByGGaWarmnehd3FKHf1QKxLF5qbyhD4REpt/9fLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSN7tCp/db43b8TC9Gt52k/7S3GPf9+c8dL7LdUdwE/SJ+pHU1+mwbANdjxKlVVqQ
	 O0bGxXf7ILFssYsLPvHZvrTZDDUCUR6y6MMXaagUBK35jlJ93QrlenCIkvicbCN/K5
	 gg3W1udcGyKyhIA8y1Zee3/xmUHIPJKpIB92Cy4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1508/3318] xfs: fix recovery of partial attr removals
Date: Wed, 18 Nov 2026 15:35:30 +0100
Message-ID: <20261118150406.174645428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 30bb61651d2da5a502cf504bcdad16c093c1bb08 ]

When running xfs/753 on parent pointer-enabled file systems with DEBUG
enabled, log recovery will eventually crash after a few dozen iterations
due to an ASSERT that XFS_ATTR_INCOMPLETE is not already set when
xfs_attr3_leaf_setflag is called:

XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 3045

This is because parent pointer use logged attributes, and the attribute
intents do not track the work that has been done as the transaction
rolls, and the recovery mechanism is to run the operation from scratch.
Because of this various places check for XFS_DA_OP_RECOVERY skip work
already done.  But while recovery tolerates an attribute already fully
removed, it currently trips the above assert for an attribute that
already has the INCOMPLETE bit set, but still exists.  Fix this by
handling the case like all the others.

Fixes: 1d08e11d04d2 ("xfs: Implement attr logging and replay")
Cc: stable@vger.kernel.org # v5.19
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5969840b8b454..b327ea0eb5c35 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2937,7 +2937,14 @@ xfs_attr3_leaf_setflag(
 #endif
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
-	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
+	if (entry->flags & XFS_ATTR_INCOMPLETE) {
+		if (!(args->op_flags & XFS_DA_OP_RECOVERY)) {
+			ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
 	entry->flags |= XFS_ATTR_INCOMPLETE;
 	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
-- 
2.53.0



