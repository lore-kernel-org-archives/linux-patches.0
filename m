Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591344;
	b=33mgaGPD0j3KrojNyzilJ11ILXDTFzSUsaESxm7UAItURIr24w5U6KGS4wSx+yxLdHjG
	 wd8cpbWANVJuyxsL/6ncJf1UdYC6dO/wMKUcLeKcwC+A2b3BiSGIHhP7wh0a4VizwK/HQ
	 B0kPNGr3GMdZYTV1D07li7bTbCbzd/KShjv+SYCSbwWaNInshN1+TZFvUQaBO/x6Bdfbv
	 kiROWL23zUiIcOBgwIL8Y9nu9V7cjBlRvgFkO00SjvvzTY+a9upBP05UeXPlDGOaHzsFs
	 a4CPnW+cNfUrpY+ckijsBq1qmsV7LAN4e1L5pYPa7Qm/h2+aXAfUVF75l3I4WC/plHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YPQamdYBR2e1wu64xRU9WXrhiClZ0u6h0saNDmeBy/U=;
	b=Vyqr8/nh7o1CYPoO1CdOGrS3D6/BqijQoj5M3uph9BCjLNdwjds7oEiYwPXwSyeaH8al
	 LBb3850bztP8rPRIcWWunG9JiUgJtDxZEl6SZx2jmpE24C70Q0b5wvvy5EL4sAvLFCGU5
	 2gPieev2koyB92aCtCF1RT4OJS/Y4sEBY1LBq8vhFFgLXAqKmvHznSVIGVwd5cpJK/ltf
	 w11d6x9hQOkUll7FJv5XC12wCpy2vmAQ+10+/mRvKSYhu5qPST73L/mvfCO+psK2ZRIGx
	 Q3AyIiP/Axgs0dpCl71agzYGy775/lEA4O/dhMBe9c4UKs+zPyN2hIMOIMqex6mHjZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emkAerh+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527FE606CEED;
	Fri, 13 Nov 2026 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emkAerh+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11031F000C4;
	Fri, 13 Nov 2026 17:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591343;
	bh=YPQamdYBR2e1wu64xRU9WXrhiClZ0u6h0saNDmeBy/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emkAerh+v2aiHurQQq7a6xZ66oKhcwGXrAHXcNmWiXGTpK14rZQvf9Xu35UmxQSuA
	 sVlyc7p+6ij5noW/irA7xVoFdP0x5Sjd02FWcV/3NwcAGxdnr9Gyix9ATU7eevAmtL
	 sWhewxFOun5jic7MLaTsENf7CRHAvyKMsvcEr+yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 452/670] gfs2: reject invalid inode sizes
Date: Fri, 13 Nov 2026 10:50:16 -0500
Message-ID: <20261113153827.229389372@linuxfoundation.org>
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

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit 33ed0a0567e0abe66ea65e89dad2e35082890fbe ]

A corrupted GFS2 image can store a dinode size that is larger than what VFS
i_size can represent. gfs2_dinode_in() reads the on-disk di_size as a u64 and
writes it directly into inode->i_size. If the value is larger than S64_MAX, the
incore i_size becomes negative. That negative value can bypass the existing
stuffed inode size check:

inode->i_size > gfs2_max_stuffed_size(ip)

Later, gfs2_quotad may try to sync the quota file and unstuff the quota inode.
gfs2_unstuffer_folio() reads the negative i_size into an unsigned length and
passes it to memcpy(), turning it into a huge copy size and triggering a
out-of-bound issue.

Reject dinodes whose size exceeds sb->s_maxbytes before storing the value in
inode->i_size. Also make the stuffed inode check use the raw on-disk size while
it is still unsigned.

Fixes: 70376c7ff312 ("gfs2: Always check inode size of inline inodes")
Closes: https://lore.kernel.org/lkml/CANypQFaF6bvORKKbRALvEL0k_epFaneFiOQqco4gjdmKVbdURg@mail.gmail.com/
Assisted-by: Codex:gpt-5.5-xhigh
Cc: stable@vger.kernel.org
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[ sashal: adjusted context for direct inode->i_state access and existing depth and entry assignments ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index d13a050bcb9dc..dc51608272019 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -395,6 +395,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	umode_t mode = be32_to_cpu(str->di_mode);
 	struct inode *inode = &ip->i_inode;
 	bool is_new = inode->i_state & I_NEW;
+	u64 size;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr))) {
 		gfs2_consist_inode(ip);
@@ -420,7 +421,12 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	i_uid_write(inode, be32_to_cpu(str->di_uid));
 	i_gid_write(inode, be32_to_cpu(str->di_gid));
 	set_nlink(inode, be32_to_cpu(str->di_nlink));
-	i_size_write(inode, be64_to_cpu(str->di_size));
+	size = be64_to_cpu(str->di_size);
+	if (unlikely(size > inode->i_sb->s_maxbytes)) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
+	i_size_write(inode, size);
 	gfs2_set_inode_blocks(inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
 	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
@@ -459,7 +465,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	if (gfs2_is_stuffed(ip) && inode->i_size > gfs2_max_stuffed_size(ip)) {
+	if (gfs2_is_stuffed(ip) && size > gfs2_max_stuffed_size(ip)) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
-- 
2.53.0



