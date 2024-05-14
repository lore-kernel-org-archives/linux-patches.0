Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048B13D2A1;
	Tue, 14 May 2024 11:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686840; cv=none; b=WVmdj4et7mjHii8lPXxpBNOrDaG33a+7MVsL+9Zg+6vkXRpFOR78NLkzc2AKDTXPEih1Mz1lDCCV5wDR3xJQvIsSBrNxNO77cYYpC3BsCkRB3shehRpnHbtUQ36MxrhXcMxRUSQ3hUkoK9H337jbhDDbGKs5IhkYXldWM9ka9M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686840; c=relaxed/simple;
	bh=M8F7EGkGEuuUZfkEHMRaMFD6hKo1hwEzygetsbscb4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bftHcZ9ABAZ0QCnhFHqd4REOg30iQW4i+5wX/lHMS3hlSlXgzx1y6JSbn4uvMh8owXK/q8bUaJTDA6/L3juqxQy3dc+0tRXTNP0za2Pp1HnquxBRLOYmKwtaXFErCuwB33WPP188yNQ5r2/CDrGK7+PGcXJPqI52FpWhdrNpC90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOZjHBln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOZjHBln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A99C2BD10;
	Tue, 14 May 2024 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686839;
	bh=M8F7EGkGEuuUZfkEHMRaMFD6hKo1hwEzygetsbscb4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOZjHBlnwNgkbntZhXtLQ/tfrVoc3ugFxFrBj8cKZSf04M7eV27YgRcmZA3aAmBWR
	 d5XjD4qoscQezznFLrEIyTMEWI4POJLK76QM6G5F25rruhg5PQ27Fxua7FmonaUTb6
	 g6ZOhWCIY3c7vhZ85r9VhGeDLW1ICUJjDtDwHEFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/63] 9p: explicitly deny setlease attempts
Date: Tue, 14 May 2024 12:20:00 +0200
Message-ID: <20240514100949.489332659@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 61e0c552083fe..5bb565856a8f8 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -691,6 +691,7 @@ const struct file_operations v9fs_file_operations = {
 	.lock = v9fs_file_lock,
 	.mmap = generic_file_readonly_mmap,
 	.fsync = v9fs_file_fsync,
+	.setlease = simple_nosetlease,
 };
 
 const struct file_operations v9fs_file_operations_dotl = {
@@ -726,4 +727,5 @@ const struct file_operations v9fs_mmap_file_operations_dotl = {
 	.flock = v9fs_file_flock_dotl,
 	.mmap = v9fs_mmap_file_mmap,
 	.fsync = v9fs_file_fsync_dotl,
+	.setlease = simple_nosetlease,
 };
-- 
2.43.0



