Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF21D545;
	Thu, 23 May 2024 13:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470619; cv=none; b=RK2OgRxsT+7UUN0Ix7Skj/KOgEnmMaF4Qgi6N7CZ7nhKpECf79a+hW7e+9haqM6tic1bq2I/a0eN4c73954qEv5B9V9rm6Rf0wZrc20D47rAyU7ZN7L9sleCdi5ZJ12p1UmgS+mkgZ84VbuntEjNhi3YF9tmLCyKxqP9cVmXJ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470619; c=relaxed/simple;
	bh=uaJx5xKa7R1e7pC6dwo/WlkBkDH0IPk2ylhcy6qdRtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNcgJJ+BwpxHiS00G5+LlhbPXduJiDTNrrFGyh3qLR5I1tFvYuG842zXbzO0b0N9MViRJtdQ6ts+OwNfIuvAFYT9J6YyMgkqBJA704czEH5nC05sYMUmmkip3UFnFJa/QlLoGHu4PaN05ztEVc49GEuIH0QM3msSdaWIKHghA0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tu6TwlXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tu6TwlXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA153C3277B;
	Thu, 23 May 2024 13:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470619;
	bh=uaJx5xKa7R1e7pC6dwo/WlkBkDH0IPk2ylhcy6qdRtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tu6TwlXk6yHmRa9HoXg1/2Whe8H2oZjGXnF8HoeOPScK1M604b/smxyWEHU4L1N4q
	 xQP36Yr3wJl1XMoMhh3GM7n+D3D87oiOPdENXS1ldl2eHhHjShsCIZmScB9gaZOYEX
	 tZL2Qh3S1ScAsrKMmZxE5J+afSNCMmNJvfO4jpkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/102] smb: client: dont clobber ->i_rdev from cached reparse points
Date: Thu, 23 May 2024 15:12:55 +0200
Message-ID: <20240523130343.600043667@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 66c9314b61ed5b7bfcff0d89359aa0f975c0ab53 ]

Don't clobber ->i_rdev from valid reparse inodes over readdir(2) as it
can't be provided by query dir responses.

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/readdir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 47f5a82bc2507..73ff9bd059682 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -133,14 +133,14 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 				 * Query dir responses don't provide enough
 				 * information about reparse points other than
 				 * their reparse tags.  Save an invalidation by
-				 * not clobbering the existing mode, size and
-				 * symlink target (if any) when reparse tag and
-				 * ctime haven't changed.
+				 * not clobbering some existing attributes when
+				 * reparse tag and ctime haven't changed.
 				 */
 				rc = 0;
 				if (fattr->cf_cifsattrs & ATTR_REPARSE) {
 					if (likely(reparse_inode_match(inode, fattr))) {
 						fattr->cf_mode = inode->i_mode;
+						fattr->cf_rdev = inode->i_rdev;
 						fattr->cf_eof = CIFS_I(inode)->server_eof;
 						fattr->cf_symlink_target = NULL;
 					} else {
-- 
2.43.0



