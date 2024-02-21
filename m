Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678D17E57B;
	Wed, 21 Feb 2024 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524155; cv=none; b=hVQxsXIWrJfwAqzULkaDobAKI3EMDZWuwKKpj0hVq9QT6RPdrYxsOuEPqWG89OtObK5D+Z4s0/YZXT9KzhSW6hX63joxonhuVquFctnnjr/P7yinXHwxPJxGOK5cl+KjtZUGfhtZl9dPzT60ke0RTclws2x7KRXJBwmsRmi56uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524155; c=relaxed/simple;
	bh=nWH3lUI5Xkr14pAbH2M27E2ZS7COJIdXpQKnxoADZ8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlZmBucg1uq+WX8K3T+YDRjutOcjFjGNB8WUeNQ6vNj7yYQBtoP5RtOb1zvfzVRI8DrjVEq+GLnzjH9cDkCi8/XQrO6dOy7DOMcbi4vXF2FueVnZN9WjDN24dBrG57WMg9xzZjZckVulRnZ/K1V+e47SLKDsDIywS6280hBgb9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnYRK2Bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnYRK2Bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C942FC433C7;
	Wed, 21 Feb 2024 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524155;
	bh=nWH3lUI5Xkr14pAbH2M27E2ZS7COJIdXpQKnxoADZ8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnYRK2BpuoyaFUYUtDpHyADmDhajFk0a8PkPJB+WRMlRO2a1Cvi8u9AIR1RkFhK9L
	 JZfwGP88F8/8foN50NLT+CNefW373Y2uNQo0cM2n/+ooLxxDP19sSdbnXKwnaeUxri
	 d+o67QYIPReeGWe1kppYWGNvHtUf9UqWEquD2E5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/379] ecryptfs: Reject casefold directory inodes
Date: Wed, 21 Feb 2024 14:05:11 +0100
Message-ID: <20240221125958.831556564@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit cd72c7ef5fed44272272a105b1da22810c91be69 ]

Even though it seems to be able to resolve some names of
case-insensitive directories, the lack of d_hash and d_compare means we
end up with a broken state in the d_cache.  Considering it was never a
goal to support these two together, and we are preparing to use
d_revalidate in case-insensitive filesystems, which would make the
combination even more broken, reject any attempt to get a casefolded
inode from ecryptfs.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ecryptfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index e23752d9a79f..c867a0d62f36 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -76,6 +76,14 @@ static struct inode *__ecryptfs_get_inode(struct inode *lower_inode,
 
 	if (lower_inode->i_sb != ecryptfs_superblock_to_lower(sb))
 		return ERR_PTR(-EXDEV);
+
+	/* Reject dealing with casefold directories. */
+	if (IS_CASEFOLDED(lower_inode)) {
+		pr_err_ratelimited("%s: Can't handle casefolded directory.\n",
+				   __func__);
+		return ERR_PTR(-EREMOTE);
+	}
+
 	if (!igrab(lower_inode))
 		return ERR_PTR(-ESTALE);
 	inode = iget5_locked(sb, (unsigned long)lower_inode,
-- 
2.43.0



