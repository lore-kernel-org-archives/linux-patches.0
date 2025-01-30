Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B381E522;
	Thu, 30 Jan 2025 14:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246955; cv=none; b=UK285lMFujuY1BAlDK7wECBaFfoe1zW+BWz7MqYt6vLz9dwbixPxL+Gwc3sbnirrD+wF2N4TxiH9f2o6wzcDOQVzFOUqeDXerna1NmA5UWZfZKLjpHcW5gqlFO1oyVuivWMtB0oLRx+FSRiBucilYi29bx8auZYHuzWYejtqWFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246955; c=relaxed/simple;
	bh=WH26S/rsFPOvluQIpee5bC2ySwb+5gb+cMp41rqForg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaSQrGTP2PeoqoRIXU5g1MgGZG9ifX6GluT8k0cmmIAUAqPBagyzfCZEruF2v6ud6xQSBMc3KAMkQEIAVeL0/5se2AEobkvAhWAFxx3KUzGR06t1HNBB1KINRilX7PzGhMwPSJEOpwIe460pU52gcBTJfSNFm7ulKiozQF34N60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdCuBpSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdCuBpSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0F4C4CED2;
	Thu, 30 Jan 2025 14:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246954;
	bh=WH26S/rsFPOvluQIpee5bC2ySwb+5gb+cMp41rqForg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdCuBpShcD3HHrvERmLriwI4OnIfFjc6YhOZ7sqiCnPEZStsFq/NznLCLHEwqkzd1
	 SQiESoR2oJ6n0gWMd5kgFw2+R97iKG0S3GK+hZo73kz7onneKp1Xniyxckqc6VizgE
	 GVkjPbouX7V69J4NxwQbwwkjXpNnvTCHjo05kmcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/133] exfat: fix the infinite loop in exfat_readdir()
Date: Thu, 30 Jan 2025 14:59:55 +0100
Message-ID: <20250130140142.752175170@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit fee873761bd978d077d8c55334b4966ac4cb7b59 ]

If the file system is corrupted so that a cluster is linked to
itself in the cluster chain, and there is an unused directory
entry in the cluster, 'dentry' will not be incremented, causing
condition 'dentry < max_dentries' unable to prevent an infinite
loop.

This infinite loop causes s_lock not to be released, and other
tasks will hang, such as exfat_sync_fs().

This commit stops traversing the cluster chain when there is unused
directory entry in the cluster to avoid this infinite loop.

Reported-by: syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=205c2644abdff9d3f9fc
Tested-by: syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com
Fixes: ca06197382bd ("exfat: add directory operations")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 4543013ac048..2c2ac7fca327 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -125,7 +125,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 			type = exfat_get_entry_type(ep);
 			if (type == TYPE_UNUSED) {
 				brelse(bh);
-				break;
+				goto out;
 			}
 
 			if (type != TYPE_FILE && type != TYPE_DIR) {
@@ -185,6 +185,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 		}
 	}
 
+out:
 	dir_entry->namebuf.lfn[0] = '\0';
 	*cpos = EXFAT_DEN_TO_B(dentry);
 	return 0;
-- 
2.39.5



