Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAF034D4D8;
	Tue, 16 Dec 2025 11:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885563; cv=none; b=YQor3aJ4/2eTanOTe4bUHMbTnBM+c74yEIlim159Qjq5dNU+toi7acBymFt5JzgxD4CdKAch7W+ZNhMWErFinvzZmCxyKxS1rBrOG5nFkWq1MMx7Z5AnVWz29PPC08GiYHzB7/Q+6DAIDH1djF3JaTh4fkei4HmgYazU1pBddYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885563; c=relaxed/simple;
	bh=roPoDtzi87iV6X+yoyaDyJhVUcu7AlkzfdMELdWLmFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTBRi6qMhGir5/eTQXdhujTxdSz2XwCI4MKDlewm+CyuriNqy+Kbb4i4Q7pernkJc6vdNNlEXgKaLYqg4ol/ThE1Q+YqtHP4CnVv+WOoXTWfJHKgZGy6A7bf9O9EMTa471sOALuIci2qicLohjp+t4jFX73iiQXPTLrpN+NGP1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHwqdvyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHwqdvyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3557C4CEF1;
	Tue, 16 Dec 2025 11:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885563;
	bh=roPoDtzi87iV6X+yoyaDyJhVUcu7AlkzfdMELdWLmFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHwqdvytTRgMAwef8Ng3ir3pv7tS6OMD7+VqcN2GolXdIxIEG3VWctOE4Jy7IhSq9
	 KTpXpEShPb7pGvSfJQUXU2nXQpcRPXDjj5vG4xYG8Rua4CepMb0ZDYUd5BdOClW/NM
	 jfm5rPmkfQ67PBQvt4hjYKf0Hrun6mRgvl3NvBnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 132/507] pidfs: add missing BUILD_BUG_ON() assert on struct pidfd_info
Date: Tue, 16 Dec 2025 12:09:33 +0100
Message-ID: <20251216111350.312274985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit d8fc51d8fa3b9894713e7eebcf574bee488fa3e1 ]

Validate that the size of struct pidfd_info is correctly updated.

Link: https://patch.msgid.link/20251028-work-coredump-signal-v1-4-ca449b7b7aa0@kernel.org
Fixes: 1d8db6fd698d ("pidfs, coredump: add PIDFD_INFO_COREDUMP")
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 2c9c7636253af..3fde97d2889ba 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -306,6 +306,8 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	const struct cred *c;
 	__u64 mask;
 
+	BUILD_BUG_ON(sizeof(struct pidfd_info) != PIDFD_INFO_SIZE_VER1);
+
 	if (!uinfo)
 		return -EINVAL;
 	if (usize < PIDFD_INFO_SIZE_VER0)
-- 
2.51.0



