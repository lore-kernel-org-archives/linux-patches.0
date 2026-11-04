Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826934;
	b=fH962VIyUok88Sfex5374H7jZBQzlRGSKe+apGJwNlNfZ8McZQIqlcAHXwuoQUDjMqOr
	 wDsBHlCFTn+QhWvwyVHnyoOLODzf00NTHNxcrQcYp0fvRP5Wc6PkDq/TNaMfg4F3d8R8D
	 drP68Vr4HOKCd+cUL2xZDV15JKJyr1TJUPVz1d/QwwTW6HKzgkzfvMIr4fIFeNbxIF1u9
	 WzGT2RklfnxOeUBj2hfM1mqTkxGIGp6QXjSpAs/7GqaA9ngb5h6ebp/+PP269cjkEKkBq
	 cWgtb1/GLg8JtCW8dNXhYrgLyo3RHwk514xdUPDZPOhbMiylJ83g58ArtCuBC55VMGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IzpnGCJuQ58L5u+e5XsblkCyTlDOUD9BJZn/XxOLG2c=;
	b=41dum7ppssms+ZtzC0Mn12jtgpyZNE56YwHz8pb03++s+m5UFx0hMdJD6mVBEzEILF6H
	 c2O60whMZPZykW1GxrvneaiMew9tcnmKsxU6csPRyKVgVWPiau4U1Bx3Z4OS9GSeYYA4E
	 JCVeMgjeu/eHy8NnEn/rrRanAu+k49AFG1QDdR3OiXWjYPakJGezukzh4aGVOsRkFS0Iu
	 DqaRI7/BMYbMZCOTDDeA5i4LTh0mRpqN3ygjpC5RgQC3agWoiklyJ6kPaMkc+BlNfSQut
	 Gvp/rlw4EcDjzeQ5AJUPThMxhlrYZLm7875JIs5rCnLRYB+3a2jeolgwSG5k0TrhRTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMIiOkFy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011DF6073501;
	Wed,  4 Nov 2026 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMIiOkFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC931F000C1;
	Wed,  4 Nov 2026 21:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826933;
	bh=IzpnGCJuQ58L5u+e5XsblkCyTlDOUD9BJZn/XxOLG2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fMIiOkFyKwJ+O5RNN3Oa8zcxpO1VoZfgbKLw/DIky5SVbTa2ct4FV1t0D3hcAjobr
	 Q1qZ57rMEbnAOBoknXoQBKQL6AQXvQ37JELLPXXQn761gMfqJu1emA9xdi+0N+sQAX
	 eRLh2HDV8Aj417oHHwiE5Fs0veSAkSvQ7vxfYOYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7.3 092/547] udf: fix return value for non-recorded-allocated extents in udf_map_block()
Date: Wed,  4 Nov 2026 16:04:36 -0500
Message-ID: <20261104211040.839476766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Kobakhia <gkobakhi@asu.edu>

commit 0f242ca0878896df30292f4922700a32e8fdd039 upstream.

When someone creates a corrupted UDF filesystem where symlink contains
other extent type than EXT_RECORDED_ALLOCATED, it can leads to a crash
like:

 Oops: general protection fault
 KASAN: maybe wild-memory-access
 RIP: 0010:page_get_link (fs/namei.c:6503)
 Call Trace:
  vfs_readlink (fs/namei.c:6419)
  do_readlinkat (fs/stat.c:583)
  __x64_sys_readlink (fs/stat.c:605 fs/stat.c:602 fs/stat.c:602)

This is because in this case udf_map_block() fails to convert return
value of inode_bmap() from 1 to 0. Returned '1' propagates through
udf_bread() all the way up to __page_get_link() where it ends up being
treated as a folio pointer with obvious results.

Move the reset to 0 line outside the if, so udf_map_block() returns either
0 or -errno, even if the extent type is not EXT_RECORDED_ALLOCATED.

Fixes: c226964ec786 ("udf: refactor inode_bmap() to handle error")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Tested-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Link: https://patch.msgid.link/20260928200445.18722-1-gkobakhi@asu.edu
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -372,8 +372,8 @@ static int udf_map_block(struct inode *i
 			map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc,
 							offset);
 			map->oflags |= UDF_BLK_MAPPED;
-			ret = 0;
 		}
+		ret = 0;
 out_read:
 		up_read(&iinfo->i_data_sem);
 		brelse(epos.bh);


