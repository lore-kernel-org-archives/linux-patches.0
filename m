Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADA93090CE;
	Tue, 26 Aug 2025 11:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208163; cv=none; b=hydCFi/56fifgzBSLRCmvdsZJG27nJ9G0RPj6mfvVquqpWVQ6RROExIhs8Q3Yf6WyYfMospi8z6rlq0W4nyaXa/zx74AhMu1UxklT5YwvUfHn70P8UToY4Rk3fbyrvczG25Epj93Dgb99keVlr03afu3vst2mz4yYnb68Djkfi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208163; c=relaxed/simple;
	bh=C0OiWlTl/rxOPIh7tMYZonMvhMQscZCtMsFXGKsb6ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8NkpHor8/YyVoGJUCc0RDUOrQ+aS6VlTTVB3TLtUrsFUdJqkYiO0tbeR6DokKxGM3wc890dZF1wUy1ipc4/4O0FTYGDGmyq0ryyu8yoouN0lUcc98CHJFUcHC+hppu1cxCnNWU1ccOgiSUBeZTV8wR46wvBcioijdhQaTz3KIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5hnxdZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5hnxdZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFED3C4CEF1;
	Tue, 26 Aug 2025 11:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208163;
	bh=C0OiWlTl/rxOPIh7tMYZonMvhMQscZCtMsFXGKsb6ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5hnxdZGZ28bS9ceCpAOvwMQNnISNnarbLGAjZxrJnqI5K7oW5FdGSpRqTbg7lbLL
	 g55DhwlVk4Gkm2qA8IMNqHIaMPuvf4jwIgnwfRp1Hs7AJpl48NSP9l3Cny4anQbR1b
	 XoTc9TrGW5GoEifZ5HUXdyj9EIm/Fj2CLGRi7dzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 453/457] s390/hypfs: Avoid unnecessary ioctl registration in debugfs
Date: Tue, 26 Aug 2025 13:12:17 +0200
Message-ID: <20250826110948.481541008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit fec7bdfe7f8694a0c39e6c3ec026ff61ca1058b9 ]

Currently, hypfs registers ioctl callbacks for all debugfs files,
despite only one file requiring them. This leads to unintended exposure
of unused interfaces to user space and can trigger side effects such as
restricted access when kernel lockdown is enabled.

Restrict ioctl registration to only those files that implement ioctl
functionality to avoid interface clutter and unnecessary access
restrictions.

Tested-by: Mete Durlu <meted@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Fixes: 5496197f9b08 ("debugfs: Restrict debugfs when the kernel is locked down")
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/hypfs/hypfs_dbfs.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/s390/hypfs/hypfs_dbfs.c b/arch/s390/hypfs/hypfs_dbfs.c
index 5d9effb0867c..e74eb8f9b23a 100644
--- a/arch/s390/hypfs/hypfs_dbfs.c
+++ b/arch/s390/hypfs/hypfs_dbfs.c
@@ -66,23 +66,27 @@ static long dbfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	long rc;
 
 	mutex_lock(&df->lock);
-	if (df->unlocked_ioctl)
-		rc = df->unlocked_ioctl(file, cmd, arg);
-	else
-		rc = -ENOTTY;
+	rc = df->unlocked_ioctl(file, cmd, arg);
 	mutex_unlock(&df->lock);
 	return rc;
 }
 
-static const struct file_operations dbfs_ops = {
+static const struct file_operations dbfs_ops_ioctl = {
 	.read		= dbfs_read,
 	.unlocked_ioctl = dbfs_ioctl,
 };
 
+static const struct file_operations dbfs_ops = {
+	.read		= dbfs_read,
+};
+
 void hypfs_dbfs_create_file(struct hypfs_dbfs_file *df)
 {
-	df->dentry = debugfs_create_file(df->name, 0400, dbfs_dir, df,
-					 &dbfs_ops);
+	const struct file_operations *fops = &dbfs_ops;
+
+	if (df->unlocked_ioctl)
+		fops = &dbfs_ops_ioctl;
+	df->dentry = debugfs_create_file(df->name, 0400, dbfs_dir, df, fops);
 	mutex_init(&df->lock);
 }
 
-- 
2.50.1



