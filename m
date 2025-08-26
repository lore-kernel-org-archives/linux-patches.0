Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EAE296BDF;
	Tue, 26 Aug 2025 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219489; cv=none; b=ie0ixe+M/vsGA5JW2wi9QsKMfFuymmuVIr+dJkNV9i9Yb1kf1wwkLTBczx7YWpyMxEUGtBpl5D5QyJ3jW8/XG/ahxk4NYH4RvH/a0gX8nneHdyISFwLQKzgE1+zyiypDfd2cLfckaO4/9g0pXJxn9OHSt+KsqsnXBQkNCffjGeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219489; c=relaxed/simple;
	bh=dOUMbLtAjIfvvFM+salIZKWLvAwN1L1p0pzuCoLoKbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNAoBuTHbtxp3UH6p+Ezc+a7akrzKJ7PlM2u4R3z24YoxOpE1qrPFlITd0D5ygFxdbJV9I1VEZeZmjrPrY4eF85rIHuagLa6UYaVf+q3gwm016Sr3Mzc8kMyif5jJjmQf/ruOVZull81PGd/gMQz8j5CMgZ3TWJqf7qH/U0lFFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQ6rAtn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQ6rAtn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E12C4CEF1;
	Tue, 26 Aug 2025 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219489;
	bh=dOUMbLtAjIfvvFM+salIZKWLvAwN1L1p0pzuCoLoKbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQ6rAtn0ux1NPLLTD/uWPRuqPgQTGSGkBcGXnLXQUICa8qw7WLcCxd36rCA2vbR97
	 BRugedy10+iqJMooXjN1NsVp0rvuaEklpA2Lv72X7Xztys8xamUJsORFnLXZ3SEFxu
	 NApalOvjgjpBXGy1qn7f2FOBWsAc9DFXNDkIxi1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 402/403] s390/hypfs: Avoid unnecessary ioctl registration in debugfs
Date: Tue, 26 Aug 2025 13:12:08 +0200
Message-ID: <20250826110918.147802529@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f4c7dbfaf8ee..c5f53dc3dbbc 100644
--- a/arch/s390/hypfs/hypfs_dbfs.c
+++ b/arch/s390/hypfs/hypfs_dbfs.c
@@ -64,24 +64,28 @@ static long dbfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
 	.llseek		= no_llseek,
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



