Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D50267B89;
	Tue,  8 Apr 2025 11:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113399; cv=none; b=TORI0iQMacLlCY9/a08a83446RYbovuw9phXgSoC/7ch0GyjWmKuJlYoFQ+Wo7UA8yXRkHyLYnzvSaC62zwMCt+imwA0XTSyautEKt9gX/YQ7UjJhKRAsLFZYI+Y0g5stutLGFCgSp6W3snvgmKy3X+2YTO3HkaHj7D2cSo3y68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113399; c=relaxed/simple;
	bh=9tgDTGrMZNfoUeDBM6pCIWP2edUG+alOn8b34EckRvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS9FOA094Pn7qGq5qMRsawCxuea/9tYgx4CutuI/5OhbuQzzmjUJ+sqCbd2oig5sxUj3Eri4DnNcv0X/CW8QJvh24Nzx4mQYotDcudtvQvz13Qb/RlBEoeLhcu8tZ7FTB8ppvc5CRGgA0LaahWk7czXoISbh5xG2fUfbdLy8T7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsrrT/Fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsrrT/Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC89DC4CEE5;
	Tue,  8 Apr 2025 11:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113399;
	bh=9tgDTGrMZNfoUeDBM6pCIWP2edUG+alOn8b34EckRvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsrrT/FdQtklm8X0XPTW2ZbbCF8RQO/pmchbrrRF/xLKryUfRMe6FsfiQuePHRhFw
	 U7qaGTb39aZtOzeZepafie591mMI3iNIj56+LFk7vFiqFRua5PWQxPKCjssCo8f1oj
	 2c5huXxqGxtD0YmZnJf0GYqgOR+B+TSaMV8aJ6MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f7d147e6db52b1e09dba@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/268] exfat: fix the infinite loop in exfat_find_last_cluster()
Date: Tue,  8 Apr 2025 12:49:15 +0200
Message-ID: <20250408104832.414281087@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit b0522303f67255926b946aa66885a0104d1b2980 ]

In exfat_find_last_cluster(), the cluster chain is traversed until
the EOF cluster. If the cluster chain includes a loop due to file
system corruption, the EOF cluster cannot be traversed, resulting
in an infinite loop.

If the number of clusters indicated by the file size is inconsistent
with the cluster chain length, exfat_find_last_cluster() will return
an error, so if this inconsistency is found, the traversal can be
aborted without traversing to the EOF cluster.

Reported-by: syzbot+f7d147e6db52b1e09dba@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f7d147e6db52b1e09dba
Tested-by: syzbot+f7d147e6db52b1e09dba@syzkaller.appspotmail.com
Fixes: 31023864e67a ("exfat: add fat entry operations")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 74590041fb2c7..24e1e05f9f34a 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -265,7 +265,7 @@ int exfat_find_last_cluster(struct super_block *sb, struct exfat_chain *p_chain,
 		clu = next;
 		if (exfat_ent_get(sb, clu, &next))
 			return -EIO;
-	} while (next != EXFAT_EOF_CLUSTER);
+	} while (next != EXFAT_EOF_CLUSTER && count <= p_chain->size);
 
 	if (p_chain->size != count) {
 		exfat_fs_error(sb,
-- 
2.39.5



