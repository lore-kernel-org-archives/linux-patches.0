Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C701118F;
	Sat,  3 Feb 2024 04:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933515; cv=none; b=rC7FZrzFfphESSQvOmHZL4YBLA9tFPkBEp0Xu30l/al5Qo20w2gHckY4cJnAQFtVLh21qLdALbxqhAtvMGA0pzkme4ju7KAYRMb0vN1D04AQXVBTdw/qR1ymUuFiu8n8ilCOhQ49yJ14XRMBm2vgGGnBC//f5gMyVZRUJnNvW4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933515; c=relaxed/simple;
	bh=mQcNMdXlCgWtEOptkQvKuj8mo4iJFZZ7fpdaFUAkhPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU66bKyp3W/SR4aDGkMcKYGVKJcfukJqZZNT1gFNQVFrf9a4CFZ46kemVkH9jCu6U9yNLBltwitjc4H9pKpXktUtqDJHdbwMDoiHRG20whsoP/3QkkfZAAqKvVa9Thn1IBiJT6XAbZhAI8Oji8I9Gbhz0sYUp3pyVAoATEdlBAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAc7W3cn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAc7W3cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0FAC43390;
	Sat,  3 Feb 2024 04:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933515;
	bh=mQcNMdXlCgWtEOptkQvKuj8mo4iJFZZ7fpdaFUAkhPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAc7W3cn38CyhyFdCco8c1cMuV5tXAYL+FbL1ShbvZD3VT4OcEGKwFrFdR/+s6k0v
	 ERpJJJg6OUpiiuFBi6h2by98zO8lMpiw7Exhz3ioIxnXvsWjdkFMigAbUYJyzxf79k
	 3CZCdEfgBLD2u8nbNO/igjCVbqgLgtrxBothq6AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/322] ecryptfs: Reject casefold directory inodes
Date: Fri,  2 Feb 2024 20:02:30 -0800
Message-ID: <20240203035400.839034452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index 5ab4b87888a7..795e9fe2f721 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -78,6 +78,14 @@ static struct inode *__ecryptfs_get_inode(struct inode *lower_inode,
 
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



