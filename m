Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BDC276037;
	Tue, 27 May 2025 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366315; cv=none; b=VAjGpjzKSilUMhwu9SGGmKqHB6MHVfPZrKF3WZdlb3e78h5+r8KpKhi5qaCb6Pnzyhi6d5pDSaxXvHnaBl+66wBSo1nHr+UKXFXYeWH+1GdOgrW9o15lIRVeF7zcVClChX+qUs1KtSOvt10lENioFjTOTqBPDskYiwwZZvpHcCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366315; c=relaxed/simple;
	bh=YuNOzgBXUPa83sPz37oOGsJ8XIZGrSTV1xoD4AmI/yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgr4MT8sXFI94rGDz5688VDKSh2WKeXhoQqnPz4gwsNTZhRWFM89sZHodmlqOUMSi0UqNE3nCIvT52eEzgXneEh7mKXYikYjIXZHYjt8hHxv/1XaxxpSp3LKK8ihjNWFAamVeepeJRnLfuHWnsGmls1krLSXF2w8nYubH7x4iK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHJk1qZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHJk1qZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8B7C4CEE9;
	Tue, 27 May 2025 17:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366314;
	bh=YuNOzgBXUPa83sPz37oOGsJ8XIZGrSTV1xoD4AmI/yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHJk1qZmCX7oFNotcSfXXEGY1xylcAo019VmzLcJpzWhCPjGZNAkadFH8CJAjJplp
	 RVbhTl0FwNZRSHpAVQcQ6PmlJnb1bRabdZg4cyeT/J23cbQe4UfapQEJKhQU0qE6Wo
	 ulPelKMJwEmO4Hylvy9V56gt4hEFAj4iowmyEt4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@cloudflare.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 029/783] ima: process_measurement() needlessly takes inode_lock() on MAY_READ
Date: Tue, 27 May 2025 18:17:06 +0200
Message-ID: <20250527162514.302001685@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederick Lawler <fred@cloudflare.com>

[ Upstream commit 30d68cb0c37ebe2dc63aa1d46a28b9163e61caa2 ]

On IMA policy update, if a measure rule exists in the policy,
IMA_MEASURE is set for ima_policy_flags which makes the violation_check
variable always true. Coupled with a no-action on MAY_READ for a
FILE_CHECK call, we're always taking the inode_lock().

This becomes a performance problem for extremely heavy read-only workloads.
Therefore, prevent this only in the case there's no action to be taken.

Signed-off-by: Frederick Lawler <fred@cloudflare.com>
Acked-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index f3e7ac513db3f..f99ab1a3b0f09 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -245,7 +245,9 @@ static int process_measurement(struct file *file, const struct cred *cred,
 				&allowed_algos);
 	violation_check = ((func == FILE_CHECK || func == MMAP_CHECK ||
 			    func == MMAP_CHECK_REQPROT) &&
-			   (ima_policy_flag & IMA_MEASURE));
+			   (ima_policy_flag & IMA_MEASURE) &&
+			   ((action & IMA_MEASURE) ||
+			    (file->f_mode & FMODE_WRITE)));
 	if (!action && !violation_check)
 		return 0;
 
-- 
2.39.5



