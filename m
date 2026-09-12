Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429DD1DE4EF;
	Sat, 12 Sep 2026 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227769; cv=none; b=ZOuMR9xcMSfki93cPhVWbuYvnVlmCKJSIW4iauB7uKHoD+8B/QgVFwX7b0Xdd+SeDBREinK6Y61IL5MnU7eTH4QeesFEzEoTcU0kldQH6+1tCoFi/c6iMF1PBteXCdU28bD/v29UQNQR85EqK+2nyfUPTpTzLzhQCo3QB/WKkCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227769; c=relaxed/simple;
	bh=i5m1mRQltKoiiVR3fwuFQrLPz2WOmYQ615HCgdWxtBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YH3CY/w7LX6ePaYDfSMI47MjMBKd7ynN9KjpvCNuVBU3o4pix5VaBpg0lWdJSh6xko0Pqho37cpVwdfycbhTpuyB6/vLG1RUUm8KVbdt08+VMed4JDUe1b2BsAgNZB70+qmK5usmlYzCT7ilD4Y+f+jc5+sionpxU0l1N25yyXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=um5VZf0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="um5VZf0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23DC1F000FF;
	Sat, 12 Sep 2026 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227768;
	bh=m3kulppaiWAGdzcMqS+vhSkWoNCKRARbMDZjjjL0q64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=um5VZf0OyWEH+uukwFw9FTyYpbIPfrCDtjz0pMSUFAJcNZ1NN1h9tu84WM56zKR6d
	 fEWRl6lA6JbAzqxRT/xn7cMrd0hxuZoyXtqElqMVPYUm1n9TYhWh1kxYHGV/vGbDp8
	 CfyiUqhJ1T7bKtPvmfYVNv1wmUIE0S0gGoKgl8D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 0250/1191] udf: Fix i_lenExtents truncation on 32-bit kernels
Date: Sat, 12 Sep 2026 08:49:38 +0200
Message-ID: <20260912065553.833360908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -398,7 +398,7 @@ static int udf_do_extend_file(struct ino
 			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		iinfo->i_lenExtents =
 			(iinfo->i_lenExtents + sb->s_blocksize - 1) &
-			~(sb->s_blocksize - 1);
+			~((u64)sb->s_blocksize - 1);
 	}
 
 	/* Can we merge with the previous extent? */


