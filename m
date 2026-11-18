Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046428;
	b=cGAgXyeYIKANUmNxd7OWGOCRSF7FFcxGPlTgjOQkqUM7aImBKWu4vHbpRQwjfxVtqaQx
	 GULntV1xaiqU1oCqniQcSmWlmSbCxtZ9SoV/XgVT7pRDWIyY4JejyjGsBzIJvfHy26qF4
	 oYkOJMvRQdYqzkiAGTqYptZ5xm/GNCVnmVH8ua6mS6Hh0iZRF49mVJRE+WmN3RCKwg4fr
	 ghB2nnzivzaJnWaB0Fzh2iuiqLpQDCXL571RivX5zuKCQnDMH9QmzUc6NcY61fw32VrJk
	 nbTiDGxtry4A800kAPGUvm+lxgYClxeZQLzf2gdNRtv0Vr/MxZec50DeGQ9QehZ7KeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PzsyQpGBlYH/a979YoaqJs7bSK95Uzc2qSZB2gBw5+E=;
	b=HQnSh1b+azcw3N1e0Kr6AJR5ShKEC0d10pJXmxC8uGeI48VG5kIvLAlkSdkQGkmNu9Eu
	 sRQMMluJMZsrQtJgfFCDztHA97uOo7Q7iuZYOe/HRxA7/lquUPhVr9IuUv9aKWXsJE6wH
	 GDYYRdKf7y62x/HALTPDK1taCHZlAwi78NBHv7Pwoif1X8XAU91BC6kiZyv3HplXJLsso
	 d7TIcLo0fwrvMwlOLMBBci4rURlgqVOAE6MJIs+ug7cqE8lMwS4drwVbBWNctk5CMLZRf
	 2/KpQtOUmzs2wOnOli2JZOqbVlzRwWdwpOG9sLvFXMATQjVPi0od+t0CH9btaq2pb7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RF2AlqFB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10066606A325;
	Thu, 19 Nov 2026 00:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RF2AlqFB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B941F000C4;
	Thu, 19 Nov 2026 00:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046427;
	bh=PzsyQpGBlYH/a979YoaqJs7bSK95Uzc2qSZB2gBw5+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RF2AlqFBb9PSgOhRDPzdaDBTqdwn272u8h/O4B638g8k2DQegWZkiMnKz1d5sJsO5
	 /uv4o62zXNIuMcmeAD+i96zso2gmdX0oINnRgJyOSHj7pypys64k3k7+3CPgwUsslQ
	 TH+u3s1tF3sq6iGcSijUV9umRSjKujrY+1TYwXms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1276/2857] xfs: fix recovery of partial attr removals
Date: Wed, 18 Nov 2026 15:38:30 +0100
Message-ID: <20261118150247.457904740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bdf4fe0146b7b..344e166cbf7ca 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2931,7 +2931,14 @@ xfs_attr3_leaf_setflag(
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



