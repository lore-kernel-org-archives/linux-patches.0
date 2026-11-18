Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053043;
	b=M4ZRkxUvl18zT0DM7NXI3XNmSXaLZgbGQagiYXncqlku/OoUIRUwAlgGsVicOqu5S7PG
	 zc+NVkMWfEHkNMNK6D8gtWCGL924GrEpF7qOGSWhBgO237fgvNDLLPHHGX4kHfTvyQ7eM
	 Octx5hAc09krRX4kfGwS66pTd6hQodXcQwDZ3wy52iPfahIOh0cbOQ9MVojWqudgZp5SR
	 deXzbyRr5V/Q09S404H6jefGjjtN7LYztdgCJdi22niHfQrmU6LgFBb8pq1TiuKqnMOfK
	 PWvrB+s8AZKMqFixdse+M40ojku3z56tbIaoctwuPpFbr5bXIhiK3Dui7ek+37ZHxEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bU1a/CCfKiAkbtnoeUHvCzjFOTUNHVWxYeVECH7irss=;
	b=TSzNGt/A5MGhFlDNsDwG01d714ugTg1/iBB7ps1M7RMeTmTJDqrLtpkUPJtFsSAUiFOC
	 DQYsfG1EeSWjT0B/eb2KfgxePr5KDqe0M/wie3nfyXhMmEdjLgCYpq+1e2DOKNckWBOWy
	 NRj1vl9Z49DGMDJY/7IYxs6TSckvBhNkhN44eF1D+Gu9V0QiAxL9FSMuA/fFCWdW2yyXy
	 45AwnoElnFU6Hvs0ik9cGdQaB84Jg++lNZDglSzWwdbRmJjohus6xjuL2JTFcJNxUp3Is
	 whSM102VeYdCoGxFHd+9kGtj0j449VCY+sqKCLo6p5c62GMKZDdJ9XkbMss2Lf/QeTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nBtcLBNK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF68A606A325;
	Thu, 19 Nov 2026 01:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nBtcLBNK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB28C1F000C4;
	Thu, 19 Nov 2026 01:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053043;
	bh=bU1a/CCfKiAkbtnoeUHvCzjFOTUNHVWxYeVECH7irss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBtcLBNKbO22UpMlwYB2XTEdlNiqZOD1pS73OCVyZuT7MmbhnWNzlovNdvOHKaw8l
	 uASrLzFXdMLH3KLZ3Z4WiOBTQwHBNtEfB3CpYrxznE8onqcWOl5rwmYQiT5uVg9CEs
	 jkRSY2wZaCzSy6MwVme+B/C73GaCtlyBtiW03f1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0777/2214] xfs: check for buffer overruns when examining local/remote xattr entries
Date: Wed, 18 Nov 2026 15:40:53 +0100
Message-ID: <20261118150042.728150468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 91c41f9524906a8ebd2ae68c98a07b4bd5255ddb ]

LOLLM noticed that the xattr scrub and repair code can walk off the end
of the buffer if the xattr entry record starts so close to the end of
the buffer that there's not even space for the entry structure itself.
Strengthen the bounds checking here.

Cc: stable@vger.kernel.org # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted checks to the combined void xchk_xattr_entry() function instead of separate scrub and repair helpers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 601e02d749881..01a2f893c156f 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -276,6 +276,12 @@ xchk_xattr_entry(
 	/* Check the name information. */
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = xfs_attr3_leaf_name_local(leaf, idx);
+		name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
+		if (name_end > buf_end) {
+			xchk_da_set_corrupt(ds, level);
+			return;
+		}
+
 		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 				be16_to_cpu(lentry->valuelen));
 		name_end = (char *)lentry + namesize;
@@ -283,6 +289,12 @@ xchk_xattr_entry(
 			xchk_da_set_corrupt(ds, level);
 	} else {
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+		name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+		if (name_end > buf_end) {
+			xchk_da_set_corrupt(ds, level);
+			return;
+		}
+
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)
-- 
2.53.0



