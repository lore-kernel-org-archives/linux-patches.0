Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84917530DF7;
	Wed,  9 Sep 2026 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964575; cv=none; b=AeBAnyZo8SYl5UM/SEND1nIbiwQC5Pnst7EoV4iU6wIzkf+OSis0AEFkXs8mmTus7t1E+YvQ3+kzeXyXRf5IDNBOzt6EuRCe7DCOhDOGREb/5SouuhBT7H+AqnUlzP9gxtTftqGyr/0bHaDYuqQsThcXikiHv+zODgEZraZn6LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964575; c=relaxed/simple;
	bh=r28rozPhr1Hw0sH7M2V2YNp1+yzZS9ZF3YfFb+FDSWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBNZHL96J/U0+dSIV/uGeRndMRC5DLPhwyKJRtsXKHe/ZRv5Tf3RzQW3pE8deElVuG64lbopOFN3YB1qZlhHFOfKZpItBCuBGv5RgnA5neY+wq/28olDvBvikQ+903k/+TXtb9O5p8F/jAJP/EecGC88uFC7UV4w9CG11NNjWA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adM1BUzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adM1BUzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA201F00A3A;
	Wed,  9 Sep 2026 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964574;
	bh=6xZqzp/PI3Qe+mqskpBOkuPoTMGJmoXA/nZFKpCodaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adM1BUzcxLCZMfvuTWBzZ3aQDns3hsvzPBy9+g4Zbs++eB41VzWOn4Dgt0SSPiI1E
	 H4ZtXOc8pWAZuMRFnkbHkGLFg83HfCQ8nRICUo27wP4zOJBr3X71y1KAWoQRQWOqjN
	 xzQ83FhfdRJ1NV+lQd4ARv8IKC4OY6IMo6JzMfYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 469/583] smb/client: emulate small EOF-extending mode 0 fallocate ranges
Date: Wed,  9 Sep 2026 15:42:34 +0200
Message-ID: <20260909134254.129418716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 7a06d3b816d73448b4e38b83d65049f090b7b201 ]

When a mode 0 fallocate extends EOF from 1G to 2G + 1M, the client
currently sends SetEOF for 2G + 1M. This can make fallocate return
success without allocating the requested range, or allocate extra
space before that range.

For example, on a fresh file:

        xfs_io -f \
          -c "falloc 0 1G" \
          -c "falloc 2G 1M" \
          -c "truncate 3G" test

The second fallocate should allocate [2G, 2G + 1M), leaving [1G, 2G)
as a hole.

Before this change, the result depended on the server allocation policy.
With Samba "strict allocate = no", SetEOF could return success without
allocating [2G, 2G + 1M). With "strict allocate = yes":

	# filefrag -v test
        [0, 1G)             allocated
        [1G, 2G)            allocated unexpectedly
        [2G, 2G + 1M)       allocated

SMB cannot allocate that arbitrary range, so write zeroes to small
EOF-extending ranges instead. Limit this to 1 MiB to bound the
client-side I/O cost.

With "strict allocate = no", the requested range [2G, 2G + 1M) is
allocated by the writes. With "strict allocate = yes":

	# filefrag -v test
        [0, 1G)             allocated
        [1G, 2G)            hole
        [2G, 2G + 1M)       allocated

This fixes the small EOF-extending range case exercised by generic/213.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 32a7af68df73 ("cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3553,7 +3553,7 @@ static int smb3_simple_fallocate_range(u
 	int rc;
 
 	buf = kvzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
-	if (buf == NULL) {
+	if (!buf) {
 		rc = -ENOMEM;
 		goto out;
 	}


