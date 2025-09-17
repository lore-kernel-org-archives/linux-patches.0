Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FABD32899D;
	Wed, 17 Sep 2025 12:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113420; cv=none; b=LcMsA7w7qmdK4MBZwTibue4kywCK8owenMYrac0ubiL/Dw2TB0qCbDpODSZUu3Ti7274RTI/A3VLN1DygIyjN8A29tSnWwdJJ7l8BsOFCdAMi1sSgXWZCpn8lDtTNuBAm4NLD4Gl1gLbrenhtVcSD22z7IMG5RE6B7Xq3ABIhNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113420; c=relaxed/simple;
	bh=qL/1lEPLQ8U/EZC0KxLMOBbxD+Dh32Wr2FYPh9tylBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ40bZmLwO5bHhs+rVPxC+sSbS/63QzEX6ST6tv9O3MnthkIOCQ0jH7MmP20grxtHN/y+i8Ted/8VE4iON332OS+gZhNc8yzRAXlFaPQlJbt9QFAiyuokHH3KkAb8tKD0Jwa5GDWPpupb2+0Cotk+xLZpTHtoJHKLyJNKmhMRO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rs8jGlnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rs8jGlnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6F5C4CEF0;
	Wed, 17 Sep 2025 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113420;
	bh=qL/1lEPLQ8U/EZC0KxLMOBbxD+Dh32Wr2FYPh9tylBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rs8jGlnF9PM7M7fhgsClGifvFnUy6SH5lVKMWTEx2GWhZ9aYgopq6orwHB8GSfnc/
	 cCZC70is6NLNXV+VE1rtGsOfkYhkdaATUy/gDkBesQ2UUY5wYSgC+Z2jZyuHTQ+zmR
	 h5UO+zfq/b+4xYmTAWhbpiPZyJTzEvbh6u3ODEiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/140] NFSv4.2: Serialise O_DIRECT i/o and copy range
Date: Wed, 17 Sep 2025 14:33:28 +0200
Message-ID: <20250917123345.191851271@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ca247c89900ae90207f4d321e260cd93b7c7d104 ]

Ensure that all O_DIRECT reads and writes complete before copying a file
range, so that the destination is up to date.

Fixes: a5864c999de6 ("NFS: Do not serialise O_DIRECT reads and writes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 66fe885fc19a1..582cf8a469560 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -356,6 +356,7 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 		return status;
 	}
 
+	nfs_file_block_o_direct(NFS_I(dst_inode));
 	status = nfs_sync_inode(dst_inode);
 	if (status)
 		return status;
-- 
2.51.0



