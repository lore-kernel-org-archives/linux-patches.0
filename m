Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6913EC6AE;
	Fri,  4 Sep 2026 05:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500271; cv=none; b=hCw742c18s91LfO+Qh+360bdQ3DHy13tuprDs741UajG6bIlgsrunGHHcsWGzQvz0Jva99LR022qfOoLCa0gJbiucTN5Zd3XHDSc6o/Ii3lil/TiDuQSlUMWKSYqQjsTrKDJV7ybbQaRjWWtkFrU7JbXQmNpBP0loRnc31o91OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500271; c=relaxed/simple;
	bh=+PNWobQoW4FFN+TS9TeJ/AfSqF69K4Hqq0s3jYZ4/qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmXhWIbXdeX/JtYQBC8m1/YL/2utPmcMljwYo6E0bXeiTsitfXrBgNbstks1p7EZFtOZeDvUJPPQQkQZZ5GVkQb9JUEIAO8/FN0Q1HeP5ouAYizq4Fq00Wqnpw24snKJ0x1CFJiySjpoulMG6QJ6L9OsBjxJi6KHjwaxfoILLVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W2a1cNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W2a1cNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EEA1F00A3D;
	Fri,  4 Sep 2026 05:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500270;
	bh=AqeHMXWNH0EiMhIoeAKHr1j3fujnN4i9jixTqEapoHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0W2a1cNxwYJNYc8dCMyjb1P2EM27Gv7dkJHC0phJj1pn4k+QSUtJClpDWKlRDa5sm
	 2X5Vf2SSe6M4Lon9hHdzKUiVeG1VR4lzz3EGx8zmc9xpuhSVOYhz2ZQi/6GfXkIjr6
	 Au0VTCgT5AOw/3p/4qs551blYCHJ11LllBy6PaSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7.2 710/713] udf: Fix i_lenExtents truncation on 32-bit kernels
Date: Fri,  4 Sep 2026 07:01:18 +0200
Message-ID: <20260904045819.762815585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -531,7 +531,7 @@ static int udf_do_extend_file(struct ino
 			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		iinfo->i_lenExtents =
 			(iinfo->i_lenExtents + sb->s_blocksize - 1) &
-			~(sb->s_blocksize - 1);
+			~((u64)sb->s_blocksize - 1);
 	}
 
 	add = 0;


