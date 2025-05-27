Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35B613A244;
	Tue, 27 May 2025 16:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364359; cv=none; b=OzStkyzdP8DG0Md2j64z6SsyOeSVYdpltUf4zB025nmMLzdOjOWH54YJAEhuFZ7pOlFmxz8z/RBvSzzgr/ipOGlQdiiEyYaTQthNvRsMHJbtOM/bDZAGYe46OjpxQxRcnz2qcy6FPLtvIcCadZO4u4/CT+POlKvkT3x1hXsMSi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364359; c=relaxed/simple;
	bh=NDq6XuWOEPIsxQ+fDTKB42V5hKSIZO+fCDFZrntFVaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjSTjasl2ArvL/0WFqB4KOq0JSVJ+oZ8gHeT4djZS0Ym2XLz8KH6cYKXufyIUi2tAMvBriiZZjJ6d5/Gz6POpVN9wNb4NxFn4lFyHrruS/3SZtHQkwwX0la68u5QqPbgqz30/6VgGE+nNk7HyISIuZzQ34HIWJ1ACIA9oTZXtqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erd6SIhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erd6SIhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1047FC4CEE9;
	Tue, 27 May 2025 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364358;
	bh=NDq6XuWOEPIsxQ+fDTKB42V5hKSIZO+fCDFZrntFVaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erd6SIhXx6tOfd0Ps+vfrre3ZwmMnYKF9PsZ48fC3oZxeR/ykF6cZY6OfcF5zDmIp
	 JVRbgHfXihPaniBiYcWqoIPsggTIy18HpPjIfAQRXaPneT9qmkIfvaP5+EGLIsdXGM
	 wOxsGw8aPwfmiPp4ZfAd1yupBncUM8EP8FqH2azQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@cloudflare.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/626] ima: process_measurement() needlessly takes inode_lock() on MAY_READ
Date: Tue, 27 May 2025 18:18:43 +0200
Message-ID: <20250527162446.289243888@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index a9aab10bebcaa..2f3f267e72167 100644
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



