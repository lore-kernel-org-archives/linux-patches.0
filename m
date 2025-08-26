Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D088E2192F2;
	Tue, 26 Aug 2025 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217075; cv=none; b=mqwih7S7nWrPLBjsEztzfRTN8eAdXDwA9HCvJCktGAzvN00fbxXok895GRFA6l2qPxWHyPCJbF0naMixegAO/zaQKiI4X8K9LZfzIeJqr4tn7KT2tKDfQ3EY9h+G/zEPMeainBA/jncyGzDoUAss3Gamjmq5l7wPLNPxgc8sBuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217075; c=relaxed/simple;
	bh=+oeCs66aO5prwh7mQAhuGWqbPHR58QLLwYiVgI9nDtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqY6ikUfoR3IPZPiaCDxoLAWbKqVz876dB+UxPVUGN3zCo7nLcI/JyUrrSMePmAmP6E6DkFiOSsLoAohnPFK5i3eVT+TpGc0G8wLr46sxD+Z75VMnbOu6GrAqSh7VxzCv/9Gdym+VmpSIv8lAL+nwSg0COUYcni4vnjE1pKI63g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7bhKF9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7bhKF9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63286C4CEF1;
	Tue, 26 Aug 2025 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217075;
	bh=+oeCs66aO5prwh7mQAhuGWqbPHR58QLLwYiVgI9nDtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7bhKF9a8ygubQFdYQ9Wger5RskeQ4MmFU62VAsRsjAq1avzpov/6DrD00yX+VVqC
	 BfiQuls/1a0erCpjsNXP4AkwvcMqNoYzklEN9OH8CkgoUtvqKhMwt3Ogzl8esQn7i0
	 /KRAjUYCx0kdEnfw/deRpeNTtmq6Kxb67RbO6Q84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 641/644] s390/hypfs: Avoid unnecessary ioctl registration in debugfs
Date: Tue, 26 Aug 2025 13:12:12 +0200
Message-ID: <20250826111002.446609938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



