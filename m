Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBCE268691;
	Tue,  8 Apr 2025 11:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110228; cv=none; b=NJGrSuwIB7AoXuowigpYOZztlAC/mjgvubxlqMLDsDH5kpP880sB1GgNYuuXp+uVGQklzM4edwJ3fXJ8OZLpthFQCM80UiMTMb0liT/JI8rJ1Xf8/W67swkXn67k4kJu/pJocvvdzr/RgF5EEBi6icHnaZtQGljC71jK5MC3G14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110228; c=relaxed/simple;
	bh=mafat1F8V8LZqERpH20p14Xc3K18nD2HFt5mekbv2Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrcTV7ZqHoAb3UwwoOSgmcVle7r0cGCufS1ACcaeYDN9mYZ32IUvYQG95b9IvlrDKB5GJQFKdyGB7BKSzc/NgMnqnqRg87+TevW0+PCMESqNX4ybkon2FlGePkLCs55UPUOGbAEoNcLOzzag0rE6SOc7zAJhIt8BuhcwowgsT2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCAxqnHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCAxqnHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBF7C4CEEA;
	Tue,  8 Apr 2025 11:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110228;
	bh=mafat1F8V8LZqERpH20p14Xc3K18nD2HFt5mekbv2Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCAxqnHErFqdQrtsztrmTtT7Y+Ak0bVixOMrhM7WMh0F4UOKzVm+gtoS+7q7jdWFy
	 msmT3oPag2SkFRvQrTzuY7GBEwZE1zOPTu6tjCFWKwkUXooZcHfE7FGw4858yoNTzv
	 yz5lBtg+3+3uEzdLA/JuPAz6pRd73FR6e2+X/Oko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f7d147e6db52b1e09dba@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/227] exfat: fix the infinite loop in exfat_find_last_cluster()
Date: Tue,  8 Apr 2025 12:49:13 +0200
Message-ID: <20250408104825.564508770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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
index a1481e47a7616..b6cce8225d058 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -208,7 +208,7 @@ int exfat_find_last_cluster(struct super_block *sb, struct exfat_chain *p_chain,
 		clu = next;
 		if (exfat_ent_get(sb, clu, &next))
 			return -EIO;
-	} while (next != EXFAT_EOF_CLUSTER);
+	} while (next != EXFAT_EOF_CLUSTER && count <= p_chain->size);
 
 	if (p_chain->size != count) {
 		exfat_fs_error(sb,
-- 
2.39.5



