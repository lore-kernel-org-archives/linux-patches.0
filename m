Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B423E7E77B;
	Tue, 14 May 2024 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687348; cv=none; b=U8N9keTs9OOadfRnM6H00dWmWw7ElST5lrBfj0dY1lPblWN8EzlgZY8JzAN2xFsYLl3tMaRmRaAfxCO500ih5u9mXuNSEhBR3TKLzD3qSfPSs+iTAEdWygZKvdE5VSaNLqYEQpUF59PPyXurN2sV//iaRjidbzS0vAmYxZqyoo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687348; c=relaxed/simple;
	bh=M1fmGWk9T3RiKJtk5PjJ/knsk4LtIeqe7ptYCX/ztOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d65tHNyhxQRlo6j8S+1fpufBVpsVRXuB67JsbkGKfMETDFBAj6WFyikLgmSfR/9Bddmu2oIlatoIT7wWG/IwqJr1TuOQABgS6quaMhxim+SX4sIXL6Rwqf5aYJFbJE4OL1d+jkKrt7dpgfulBFabaPl6KcblBvAT4W0EjomnOLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjl+LnGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjl+LnGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8DEC2BD10;
	Tue, 14 May 2024 11:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687348;
	bh=M1fmGWk9T3RiKJtk5PjJ/knsk4LtIeqe7ptYCX/ztOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjl+LnGY6khf7RFXkHMFrkQAmeKUaH2dUbhXUT0MJzzyOnKAz2C7RqRJJA6mKpchS
	 xoJ/VFFqFnGwt1W2A+UThPnyPejY4/0GaFQUrOrc9/qBsgyY1er2AIyHOr+zq4Pm2p
	 tSrNYP2XtQ+bGKYjOV+yPyx0+UzCPmOqpEp7Uerw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/111] 9p: explicitly deny setlease attempts
Date: Tue, 14 May 2024 12:20:04 +0200
Message-ID: <20240514100959.642740743@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 7a84602297d36617dbdadeba55a2567031e5165b ]

9p is a remote network protocol, and it doesn't support asynchronous
notifications from the server. Ensure that we don't hand out any leases
since we can't guarantee they'll be broken when a file's contents
change.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index be5768949cb15..5d92eaeaebd91 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -685,6 +685,7 @@ const struct file_operations v9fs_file_operations = {
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync,
+	.setlease = simple_nosetlease,
 };
 
 const struct file_operations v9fs_file_operations_dotl = {
@@ -726,4 +727,5 @@ const struct file_operations v9fs_mmap_file_operations_dotl = {
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync_dotl,
+	.setlease = simple_nosetlease,
 };
-- 
2.43.0



