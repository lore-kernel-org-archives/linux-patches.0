Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9C2BDC00;
	Tue, 26 Aug 2025 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214873; cv=none; b=fz3tX6s2HrDQdOVCH/92EARUvt5/vOfgHBC/gykKGOuLK5x9ZvroYRAfsmTKIibyhAIivPJnfJtpPUX04QKz7vn+f9+OenEZfYHcgpsQGa/kFe6D0yFyYPLoQb6dzWzqaitCf/Z1unyNMdK35/qLryv1WFFt8lJqJ1p8me/ijho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214873; c=relaxed/simple;
	bh=+IoFj+FZ+MdQQQRJ3JBSG9TiNKhExYUBCIL5hiHqocQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEFXbiVEv5VuRmSQJE+YODEVeCF2ZzjR3dUR8sd0Ke256hbToNCjkZb8nNEFB4xtXXmPevwkL3l+Ca0f98JTIm7QOHoT1+LRxnY1LBhvv2/1m4bfw/VBd7giLlgG4PFsVg2a8cq+Z+3PzUa33CzQuHf7O95hntcmvGcPCtzzQI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGB9WABu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGB9WABu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7DDC4CEF1;
	Tue, 26 Aug 2025 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214872;
	bh=+IoFj+FZ+MdQQQRJ3JBSG9TiNKhExYUBCIL5hiHqocQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGB9WABu1FDNNG4jk6Oj1FQkPtYRMIvWTpc94/pSCqWIqjIKlz+v4TxDJmJ4Br+XZ
	 1zeqNYwXidD20mmAHVAeeFZheQ2YB+gwt2zORlwaZnPDNTYcnxbPYgPNQG7ZYuYlcR
	 yemN62NtS9p4782iNB0CsBF2SDX2A43gdBQUX9VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 284/482] ext4: use kmalloc_array() for array space allocation
Date: Tue, 26 Aug 2025 13:08:57 +0200
Message-ID: <20250826110937.802764255@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Liao Yuanhong <liaoyuanhong@vivo.com>

commit 76dba1fe277f6befd6ef650e1946f626c547387a upstream.

Replace kmalloc(size * sizeof) with kmalloc_array() for safer memory
allocation and overflow prevention.

Cc: stable@kernel.org
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Link: https://patch.msgid.link/20250811125816.570142-1-liaoyuanhong@vivo.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -590,8 +590,9 @@ int ext4_init_orphan_info(struct super_b
 	}
 	oi->of_blocks = inode->i_size >> sb->s_blocksize_bits;
 	oi->of_csum_seed = EXT4_I(inode)->i_csum_seed;
-	oi->of_binfo = kmalloc(oi->of_blocks*sizeof(struct ext4_orphan_block),
-			       GFP_KERNEL);
+	oi->of_binfo = kmalloc_array(oi->of_blocks,
+				     sizeof(struct ext4_orphan_block),
+				     GFP_KERNEL);
 	if (!oi->of_binfo) {
 		ret = -ENOMEM;
 		goto out_put;


