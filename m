Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBD869D2F;
	Tue, 14 May 2024 10:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683402; cv=none; b=ij/KSjWSfBXH9i9F18LnQdd9drR2VqLo4tohZ3L8uomY6+ahvrIBMitI6QJjtZ5NEVBgNLXPlXkRy+a0tCcd7KSGINEk32dGxBxuM+pWtL1SoGIMrwMIJm6FlO743g5vRpgsGGGYCRzcvDE6V63fEbzUHfAzVb/KqbrHo75Pw38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683402; c=relaxed/simple;
	bh=eWOrbSwKVsMpBoSEz9SjnOHFVarQ7rVfLKYcTT2VdwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV8gBdlHVzLogW736/newDWAvqUImCOmp2Py1IAWmkQWQhB2f7KiRzDPHjrar663txgcaFh6EmgQRx1i5zSsUt40fVhNvC5v0T3g9JG/iScfVDlk7g83M3Ceb+pw4+IyTQPUJJoY54CLXdASUdLKRBiADZddSKQmBMG3+RTR5rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otbgp6JI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otbgp6JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7CFC2BD10;
	Tue, 14 May 2024 10:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683402;
	bh=eWOrbSwKVsMpBoSEz9SjnOHFVarQ7rVfLKYcTT2VdwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otbgp6JIG4mMn7Mc6RipvNrhlgWaW9Pl3fZHf5EPu4pCImq5qgtJzNPSVXZwu183N
	 iC4WYsVaCkdtWoi9HN25MEDjheRKuBXrQg1tITY4TlqEY1bIVQ8tDNDq4bArIOPROi
	 qd+Hv3/DbrfJA4RAp7JGAhmij3CV8Qlml/9WjOAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 180/336] 9p: explicitly deny setlease attempts
Date: Tue, 14 May 2024 12:16:24 +0200
Message-ID: <20240514101045.399336069@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index bae330c2f0cf0..a504240c818c8 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -520,6 +520,7 @@ const struct file_operations v9fs_file_operations = {
 	.splice_read = v9fs_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync,
+	.setlease = simple_nosetlease,
 };
 
 const struct file_operations v9fs_file_operations_dotl = {
@@ -534,4 +535,5 @@ const struct file_operations v9fs_file_operations_dotl = {
 	.splice_read = v9fs_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync_dotl,
+	.setlease = simple_nosetlease,
 };
-- 
2.43.0



