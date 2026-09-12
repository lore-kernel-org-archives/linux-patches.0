Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1C4313545;
	Sat, 12 Sep 2026 13:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221279; cv=none; b=itPZPlbJtxAOHC3u0QveXbrxUPAPcBEtGZqasgxnxoN/oCHcgQrTgbVjur9PloV9zA10L+Qsaho1kBTbbCY1ZLXpnUHckpuoyc8ozeBWN/Fqsc299gwzPcsum3ThiXMWlj/TbCKzq4oO/eoVOnM287hWuv5s+8ofWlyvJo8NojM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221279; c=relaxed/simple;
	bh=ikWrw5GSYMXwE+rPUIYzqAfHwjy+fx06ky4aaMrPfco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6xVxKE1C9JK1ITqDaGa/Qi5faadIhr2qDtZybU7VOB6mwgtXvFawDesBL8ln+SRtOEar22mdkGrTm5uqWHgCy9KHkCpKzaQJrwRdJj/sQALf/5/aDM7ZmgjnS8NJH21+DOWMXzIcP73V5qiY1bSJgjChxuA6Pui230dTeytaa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrNMnNnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrNMnNnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AD01F000FF;
	Sat, 12 Sep 2026 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221278;
	bh=Gsiw9P7Tk5v7+JL4g1/pRXUrKzsr1TSVEFvP65FOGPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrNMnNnAPIu57trJ/035+eUmXkI/GCgdUgvFLAxpLy/d3F6lfl4RxWSWBL55aCbXj
	 hqyd6chUIbPVVOMX3Ozwx2KZu7/PzaxZqJUIf0OBS/QdnwrJ9YDFEJ1VtAuDxDM9BX
	 GCsRK761lqy7hM/YykY+IjRf1Wg1n7UW7Q7En/+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 0307/1424] udf: Fix i_lenExtents truncation on 32-bit kernels
Date: Sat, 12 Sep 2026 08:45:39 +0200
Message-ID: <20260912065614.158479463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit a5a5ed23b1340ff0f32a14a7ca8585f7c4e9b2e2 upstream.

In udf_do_extend_file() the total extent length is rounded up to a block
boundary with:

	iinfo->i_lenExtents = (iinfo->i_lenExtents + sb->s_blocksize - 1) &
			      ~(sb->s_blocksize - 1);

i_lenExtents is a __u64, but sb->s_blocksize is unsigned long.  On 32-bit
kernels unsigned long is 32-bit, so ~(sb->s_blocksize - 1) is a 32-bit
value (e.g. 0xfffff800 for a 2 KiB block) that is zero-extended in the AND,
clearing the upper 32 bits of i_lenExtents.  For UDF files whose total
extent length exceeds 4 GiB this truncates i_lenExtents when the file is
extended, corrupting the tracked extent length.

Cast the block size to 64-bit before forming the mask.  64-bit kernels are
unaffected.

Fixes: 48d6d8ff7dca ("udf: cache struct udf_inode_info")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Link: https://patch.msgid.link/20260722082425.213311-1-zhanxusheng@xiaomi.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -529,7 +529,7 @@ static int udf_do_extend_file(struct ino
 			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		iinfo->i_lenExtents =
 			(iinfo->i_lenExtents + sb->s_blocksize - 1) &
-			~(sb->s_blocksize - 1);
+			~((u64)sb->s_blocksize - 1);
 	}
 
 	add = 0;


