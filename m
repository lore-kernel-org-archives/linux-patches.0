Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB9835FF58;
	Tue, 16 Dec 2025 12:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886877; cv=none; b=lGehGqG28MyTKUrloMYBHCz2RSQoqvwyPIaxfk/ZUk9CbUIYYVoCBmQW4+59lcucmQUnoReHOnmEC3s5SCmE1KyMINQ4FxhpiqXruDF+AaU+1KEYlttUplSIZdQb/JF2EzXfaCDVTszWCXUiiv/QWQI1CJohrgtfL3dJjjSwBSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886877; c=relaxed/simple;
	bh=HpmlNLqqGSbKG05pZIm0+32dqKCGY/zRMc3gvT54qgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGdSoFmMeI1SyopFgGKybr7elsexQwh4RX/zfYz2PBKDPGTNaeEZhRPd2xo/tq4UhagEQWoR+S8btDnMv4OkWeszN4G4rO9ixGkvAmtFi6v4awB0ggFA9K23Y5e5yHoJvcW7RGV+Fc4aTCbzqJ6EAzL7w8O40o+3HjFM9VdSqNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4Mmxcyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4Mmxcyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A515CC4CEF1;
	Tue, 16 Dec 2025 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886877;
	bh=HpmlNLqqGSbKG05pZIm0+32dqKCGY/zRMc3gvT54qgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4MmxcyciZZmfsXEr/shIYRM2OWMJEw12+xNullFR6/68MvZ1gefuvcXxcwowJwO2
	 A9hbOOGXNLa7SrQMJs+LETKXLXXhM3p/NYlSzMX7jqhP424dWYv2ilmJeGhUxhuTxT
	 W2nyWZKes1m3+I1dfiN1amwOPmJJtUasnRLQmLIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com,
	Sidharth Seela <sidharthseela@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/614] ntfs3: Fix uninit buffer allocated by __getname()
Date: Tue, 16 Dec 2025 12:07:05 +0100
Message-ID: <20251216111403.413478045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 3959f23c487a2..3a0676871bade 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1722,6 +1722,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	de = __getname();
 	if (!de)
 		return -ENOMEM;
+	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
-- 
2.51.0



