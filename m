Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037157;
	b=0eF8ZQ+EyXvo5Nc16tpV3HVriFWK4KHYj64u/YPUUMbUaFNfvaIIvTtB/2aw3utq5Dms
	 tGzOg634ueVA3l8mdwVdCLI6HEzAqDhk9uTPnVgNvQtLs1ZUU8Qi6XpQZPVughugEnafG
	 ZZpDsWQKD2rcrFUw9SENuAvSYqZ4phUsjpW5SXBYUF0MWu22RG/OLa7IXcDeVkAVCKheK
	 FtCCqXUHPOkxGJerF45dUSinLSXE+wCGyt5DOvxNPTxtF4r/TGRdX4bP8KKek+gNb/QHa
	 +jDlJRpL8mcERbvup8K9MyZ5iilg5MQN0nMtG8AhMxfJ2iLio95vdhl04DU/JUUscTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nWwZ+nauXGyGoDPO434lIiNiN2RPbV0AS2qcPhM2k/w=;
	b=MYJCpQJTTOhtxUGsXvutdxakBdYvXhWDxbpOL/9AOg2RILbsoSUDQqEBqRil3UBgIuEv
	 aPwGXsXd2upojYE9DtRcLXtoZxJcIch2B2/YfJwD9CFPSd+yNwKmbX7Gp+X1Ya/05YWTn
	 SoVPluIdxkXum85jranSVZgIkLMAiP0aJ6D2+cZgSdrBDqPKFdSeXnNhfUZek/FAGKmPa
	 o88Gh556J36xv5wWQarE0qBjmBPZPAyHPDpBW5CQSvSwlODxyfkAPrLDuS0uTsX7Kfbqi
	 38jCW9I1mifmew0Pvg8jYWeFn7GBhoKi2+1jcgUWppoyDliFoOrOOgRpA94QdMsDcPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m4ae3H3F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0738606A334;
	Wed, 18 Nov 2026 21:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m4ae3H3F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95D11F000C4;
	Wed, 18 Nov 2026 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037157;
	bh=nWwZ+nauXGyGoDPO434lIiNiN2RPbV0AS2qcPhM2k/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4ae3H3FdncFlESBArYUut4yvVFWwVKVSYx1IWMSwvlxNUIvlaaPb7J5mOgKalW7I
	 K7TJQ7sEoZIdrvOwzTOBN56YjjdsdQ0BhoHiWDmLW9Y5MFvsgXeK3fjN3+IEe2yw0G
	 Hs9mvGbdzKcBOPF6e3EDhTXxd5rJqp3T7KXomZlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1314/3318] xfs: check for buffer overruns when examining local/remote xattr entries
Date: Wed, 18 Nov 2026 15:32:16 +0100
Message-ID: <20261118150359.720059628@linuxfoundation.org>
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
[ sashal: adapted separate local/remote helper checks to the existing void xchk_xattr_entry() function using bare returns ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index c785d80bbfe50..5e5115bf6c05f 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -334,6 +334,12 @@ xchk_xattr_entry(
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
@@ -341,6 +347,12 @@ xchk_xattr_entry(
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



