Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39391B87CF;
	Tue,  8 Apr 2025 12:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114902; cv=none; b=CPzd1Vpz9EU7dyC1RigunOui58wt1yr6tGj928AWyVBoeVG4bpNQIydOqBXiLN2hZIEdD0jlNll2mnbAfwjLmiy1jC6ngDk1W1jFQGkZUCrqwW48Ik19a8YLv/47/o+q3YvVaY/99dFzNGDag9bizgqv+eVdSFne19HgH2HMonY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114902; c=relaxed/simple;
	bh=Sql4/UO2k6+cdqvpTXKa4s+PiAgE5WWj33+a3bcc7ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLUk4PFxGZVdoj2XpCQ/84ArDFe0rWc008xOVC7YUm3iJn+FzoxPaeReQsVkQbyyKYENUP0TnyjUQXUsQ7wHlmd+kzKuIeaJ3pnU/45QkwwVzAaLucRxj7GHV3EJbrQHc/oMxK+cI7OGwFRK8dNNUn/JXN9JJUFlGXcxB4w7VeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNXLD4j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNXLD4j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ED2C4CEE5;
	Tue,  8 Apr 2025 12:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114901;
	bh=Sql4/UO2k6+cdqvpTXKa4s+PiAgE5WWj33+a3bcc7ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNXLD4j2Qw6Ws7pJtPbSbKd8Wm4+21vJmPGmv+DUajRHsBumc1ngzHR8qhzzBF8Sq
	 XeBIldOJS/+6Q/JIrhxgPFXY039H+QOzhqZ5sesD5eXC+BKz6PP22PpqmCEdaju1rn
	 /kgCt/iH5dyhpKW/h1lVidMsdvQeqPW80MkgMglc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f7d147e6db52b1e09dba@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 277/499] exfat: fix the infinite loop in exfat_find_last_cluster()
Date: Tue,  8 Apr 2025 12:48:09 +0200
Message-ID: <20250408104858.126396477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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
index 6f3651c6ca91e..8df5ad6ebb10c 100644
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



