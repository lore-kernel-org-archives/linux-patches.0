Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560432512DA;
	Thu,  3 Apr 2025 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693952; cv=none; b=NRDrOfY1boGbxaQIwhmnRhQhykY2Fr2nzMPJZV/u8kGJsRWLmNR4gCqb7Q1sn8MqYzRD5hQiyQSLjMqffksvYou+ZNAa5xNVMF8qXL+cJq4BfUCGxhrFpQg5VFqyVYPYKssIKxOJKcZSj5GaL958rwBZ+uiaZk3id6IDwfQlysE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693952; c=relaxed/simple;
	bh=V5z/GArI0oUGL8tgjvyLMh6ZHKnxoQUnjnZz+Gf8YVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkdB/jbZtUpe1Mdh8k+k2qlNlAWJslTgcjp0sDvRklHSOB+wsARnxMQ+u6n6DlT+9z7qf4IBVenOnsmbs0BJMHIlyT9Vmv3QS3ozx08g4ZcZg/dxCZc++KXzrtKa11lNe0MUevVT9rG5cTi0gh2gdlMXIIackO/oldBHdrgXm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dp3sNKVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dp3sNKVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8253DC4CEE3;
	Thu,  3 Apr 2025 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693950;
	bh=V5z/GArI0oUGL8tgjvyLMh6ZHKnxoQUnjnZz+Gf8YVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dp3sNKVspu0+WyKd8l67qM5mt9ZP13SPntSdZMmIQH0CbZN4GLld3YcpfZJVcOdtr
	 gp5jT14Xai3hDZ1sZneRG5AdQKP96W0FrL1DsclzwfIuX5P+WexHlN/ExOQUARBiMv
	 JyCaN/ac4rmRPcwBpcc8p9I9RrT2gcN5/xpFnJXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.13 23/23] bcachefs: bch2_ioctl_subvolume_destroy() fixes
Date: Thu,  3 Apr 2025 16:20:40 +0100
Message-ID: <20250403151622.952025211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit 707549600c4a012ed71c0204a7992a679880bf33 ]

bch2_evict_subvolume_inodes() was getting stuck - due to incorrectly
pruning the dcache.

Also, fix missing permissions checks.

Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fs-ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -520,10 +520,12 @@ static long bch2_ioctl_subvolume_destroy
 		ret = -ENOENT;
 		goto err;
 	}
-	ret = __bch2_unlink(dir, victim, true);
+
+	ret =   inode_permission(file_mnt_idmap(filp), d_inode(victim), MAY_WRITE) ?:
+		__bch2_unlink(dir, victim, true);
 	if (!ret) {
 		fsnotify_rmdir(dir, victim);
-		d_delete(victim);
+		d_invalidate(victim);
 	}
 err:
 	inode_unlock(dir);


