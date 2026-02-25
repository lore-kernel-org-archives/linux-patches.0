Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A443F2F7478;
	Wed, 25 Feb 2026 06:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002781; cv=none; b=K5xkWxKGGSQTpBR49D9P2bfxBjCtVpr7vCJHR55aUwuHu1OsDZxPC4Q5m3JNmv5idjcVCznyTWZXT0IJT2wUZdACUSQzR1h0yt8TDUdvbbNwt/5cZjIsGtMwWq2uMUgv3G1dzSHO7l/oEHLUds6+hKrUFDuMmC795yGMzqQaXy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002781; c=relaxed/simple;
	bh=tFzLX3TTh4pktmbeQu3SiYNOc46PAIIDV6xI5aEA+eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trdw4vJ3Gv/fTulnc7E01d0de95+T2M0e9A5ktOgFXIdCJ9kmSwD46SNx7lsjBAd9l4nbnqZDr+IY47EK8J+QMfCz1ABJw/HGhYHXdyecxwvbZuhHuqY0Xoaq26vCUZYqoDcrn57Z0O71YdN4r3KjcezfLW5p0kCk/OlVvO7gEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNl1GAg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNl1GAg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B973C116D0;
	Wed, 25 Feb 2026 06:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002781;
	bh=tFzLX3TTh4pktmbeQu3SiYNOc46PAIIDV6xI5aEA+eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNl1GAg7VkNSXgeFct/3PJPJ/zoBTPpAvsJkUinWVSnSwxreJgp/XtMQukxHm4cR4
	 fpOJ6MpCtTFhq7XsJ/dfKNaztP1rKAkiEhaNb7lgoQV9rSor9HL9a+O7mYz63HfitB
	 6aObHxwiqXfF3AM6yG0rx/hyyJAdnLwPqEQErNnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.18 621/641] ext4: use optimized mballoc scanning regardless of inode format
Date: Tue, 24 Feb 2026 17:25:47 -0800
Message-ID: <20260225012403.555526154@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
 


