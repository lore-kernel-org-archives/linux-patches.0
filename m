Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D64248F54;
	Wed, 25 Feb 2026 01:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983680; cv=none; b=ZasFJWBEeKapFW/m3SQZ6EQvlwDmUdOQenAkuaA5bCyikCkwQLW1Yjv1ungAlNqEWzpi+2O5hNiTOm4QDpXU63/RxJZvEJ1XIahDoLKuPbVkgpOwswWE8EmHlQHzqMlewjjKIS/h7V/amx75jGCtj96f7IU3m1q02z9qi0dqiJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983680; c=relaxed/simple;
	bh=myv6e9AWl64oz9oofk2gwrr+5oS4+JpuJeCoLJal0Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIe8Hb25n9csd/feVLd547FE+//Ae5MdmxY+mqdVSawAtRv+dGCXkM+SYQv3WrdT8z97Hgp8E3WKhAC4RS2WVRyD3rQ1aldTMM/ijEo3tr1tlIchi1Pc9soQRjm4EFWHcLQGaO2ZHR6j2CNoiB5hV4s7ZqQTxkgpLfoPUJPytHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAM69zhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAM69zhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B518C116D0;
	Wed, 25 Feb 2026 01:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983680;
	bh=myv6e9AWl64oz9oofk2gwrr+5oS4+JpuJeCoLJal0Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAM69zhI830UJPM4pI0YOjmpgu3BXmHcPhmbwzBLE6/CMdb4Lay5T3VuUaxMlg+4/
	 ULDc91beCGteFlTF8+e5mPDOg1kdWWwnZkOO56oTrdu5GeRWdHsGTWFDDGX3h0eTX1
	 ZdL3Cjw5Dik0DBfCtSrfDwLH4x8CgYpmqP0hYIjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.19 764/781] ext4: use optimized mballoc scanning regardless of inode format
Date: Tue, 24 Feb 2026 17:24:33 -0800
Message-ID: <20260225012418.457591680@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 3574c322b1d0eb32dbd76b469cb08f9a67641599 upstream.

Currently we don't used mballoc optimized scanning (using max free
extent order and avg free extent order group lists) for inodes with
indirect block based format. This is confusing for users and I don't see
a good reason for that. Even with indirect block based inode format we
can spend big amount of time searching for free blocks for large
filesystems with fragmented free space. To add to the confusion before
commit 077d0c2c78df ("ext4: make mb_optimize_scan performance mount
option work with extents") optimized scanning was applied *only* to
indirect block based inodes so that commit appears as a performance
regression to some users. Just use optimized scanning whenever it is
enabled by mount options.

Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20260114182836.14120-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1148,8 +1148,6 @@ static inline int should_optimize_scan(s
 		return 0;
 	if (ac->ac_criteria >= CR_GOAL_LEN_SLOW)
 		return 0;
-	if (!ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS))
-		return 0;
 	return 1;
 }
 


