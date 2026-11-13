Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590879;
	b=HQUHN/skvQgTEU34r4NtJOsPngjgG46lEQKK/WkSo2NmLFwfNwu3jd903f0z5K6qug47
	 jq9Alotyq8RHeo0a3nr3d/cciFL2P2IcBDJ8af6YfcpBEmGb61PMqrVOCBE99TIziPyaO
	 sedKjcBLPejuWupVI9OhXUmxjHn9uSbi9h1oK2BUjiUgIG1wAAja3rZuIH9ZpQPTYlC+r
	 3DK/JNwIDFPgLeq8BKV27UGkINffN229KkqxT8S0aUOBiimZgr0JTlmW+LmCzRB4LPq8m
	 m8uL2NdO8Xua6Zwjmb66iLnupyGxCA2QNDdyySW7VSjz8KbFsyaAJcg9WX8CsI+v7bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MOrn4XjSSjceFR2gA6glCZmjCxCanIgBiCbA92TiF2Y=;
	b=IrD9sbtRqgR0ptO5EFV2/cgmmgTAi2gGMGHZLWvliMwVXA0iKCRGxq18e2PSyLdmnzNg
	 4JRGsMJSABIq2M2TMrrrtBLLu8Wm4Dfy2XPy62Gj8cg1ohHIUL2OwxA+UqzSR0Dcm4Cq8
	 6KMFVJWx1XFz/2elxt0s5sA17RCQL9F0iryjwHxQAp/VZ1ejk9j1nJ7yhaZ9aMTF1P7yV
	 iwoYJVxc/+zWFIc1k96qg/InoqPaaOeKxAbnFYfDhqBZLVICwQWQdctlAs3u8ojKIcY1Z
	 +AenlRYrh/mn3bWtK42mviq9EDNRstiEdKb2OfyOrrJrIsIE798k7Q2Oyq7O1vJS6YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbZs6ecN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA25606D4BA;
	Fri, 13 Nov 2026 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbZs6ecN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06011F000C4;
	Fri, 13 Nov 2026 17:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590878;
	bh=MOrn4XjSSjceFR2gA6glCZmjCxCanIgBiCbA92TiF2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbZs6ecNw8cbAYNzVkOLHsuHCcWyU+k5j9fo0sDMlUIvLXAskee0d8j/M7Gs4OYQH
	 l7z1l9dEoLk4ZNftPMf7ETxK/3aGExzYL3fRcd8l2yZFKN7GXicy4aEIUZhTyU6xh0
	 Abm44YofWYA56OFX9QR0Iz7wkt6sKjbTsx+yW27k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/670] xfs: reinitialize dquot block if non-first dquot cant load
Date: Fri, 13 Nov 2026 10:43:58 -0500
Message-ID: <20261113153814.073242718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit faa9aa9e846332aaad78096a2cebfeafe68a7776 ]

LOLLM noticed that the early exit logic in xrep_quota_block is defective
because it only looks in the first ondisk dquot for corruption that
would prevent dquots from loading.  We need to scan all the dquots in
the block, not just the first one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 780212c8d810 ("xfs: forcibly reset quota timers when upgrading to bigtime during repair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota_repair.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 95d5bb8c10032..368be503334fa 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -299,7 +299,6 @@ xrep_quota_block(
 	xfs_dqid_t		id)
 {
 	struct xfs_dqblk	*dqblk;
-	struct xfs_disk_dquot	*ddq;
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_def_quota	*defq = xfs_get_defquota(qi, dqtype);
 	struct xfs_buf		*bp = NULL;
@@ -321,14 +320,21 @@ xrep_quota_block(
 		break;
 	case 0:
 		dqblk = bp->b_addr;
-		ddq = &dqblk[0].dd_diskdq;
+		error = 0;
 
 		/*
 		 * If there's nothing that would impede a dqiterate, we're
 		 * done.
 		 */
-		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) == dqtype &&
-		    id == be32_to_cpu(ddq->d_id)) {
+		for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
+			struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
+
+			if ((ddq->d_type & XFS_DQTYPE_REC_MASK) != dqtype ||
+			    id + i != be32_to_cpu(ddq->d_id))
+				error++;
+		}
+
+		if (!error) {
 			xfs_trans_brelse(sc->tp, bp);
 			return 0;
 		}
@@ -341,7 +347,7 @@ xrep_quota_block(
 	dqblk = bp->b_addr;
 	bp->b_ops = &xfs_dquot_buf_ops;
 	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
-		ddq = &dqblk->dd_diskdq;
+		struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
 
 		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
 
-- 
2.53.0



