Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9957C35B12D;
	Fri,  9 Jan 2026 12:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961555; cv=none; b=SJnzqwmdlQ2xN4+WYtnUuJwjG9LqrljcAM6V9jm4xcTjj8FYx5n3eua00BQXhHpgoBAkjoDsbE7X93s50pf9JcfoOeRBQSGyfzTFAEX9jtLScHJDVnGM17TNoswRE6ZfgGDhzr+Zxcl2Uld0RyNbXxtlAAoidD05DzBCjapna6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961555; c=relaxed/simple;
	bh=mO6o5jrCb03+zoHWJbYFUQkCvRZojCMNTvRolCyHghw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHsqxYE/FAP06CXAdBiRJf/9XBIlcHXRQpDN7UusTUrvcnRe7Ow6yMuyifTYHhzFuXmDkJOEAjDyOhBwbuqD6nGW7h3WI+Hqxp7zr+/wbyUtrXQCSMNrWwOc3PfOpvXJX/hRrWtbDaxGa++7Q2vOcBAPcbqu4Ptqm6aXel1cbJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVWt+Dno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVWt+Dno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EB6C19422;
	Fri,  9 Jan 2026 12:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961555;
	bh=mO6o5jrCb03+zoHWJbYFUQkCvRZojCMNTvRolCyHghw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVWt+DnoXHFJsbTb3QntUS57tZ4GU+qBmvUsxMLb5Fp9HDf3afGukL0X8UD7vANWi
	 Ft3i8cuJdpCRIuYtrK/YGdqOZqsRnYd2JRuV7O98wvIyEbaLj66YvUNqADIchtkzMP
	 XUvyulabbFHADLUH/QSIfv0b75xf5xN/Hb1Ee270=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com,
	Sidharth Seela <sidharthseela@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/634] ntfs3: Fix uninit buffer allocated by __getname()
Date: Fri,  9 Jan 2026 12:35:33 +0100
Message-ID: <20260109112119.515987088@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 9948dcb2f7b5a1bf8e8710eafaf6016e00be3ad6 ]

Fix uninit errors caused after buffer allocation given to 'de'; by
initializing the buffer with zeroes. The fix was found by using KMSAN.

Reported-by: syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Fixes: 78ab59fee07f2 ("fs/ntfs3: Rework file operations")
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index accff95baa847..785aa1673359a 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1700,6 +1700,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	de = __getname();
 	if (!de)
 		return -ENOMEM;
+	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
-- 
2.51.0



