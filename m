Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEC846551;
	Mon,  1 Apr 2024 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987066; cv=none; b=aMRjrkWbW+H+T+1bHVAmaRqwT1+ApwTa/fr86mQpfERiHR6aCeaDS7bsfB0OuhED95zAwCNj9NQKsJtkgDWJADgbA2oMo9Tok30qfAmTWf4kFLJfaqAjqYqlIPmVESUu30FMEh/XQXxYQW7apLjmzkyduhW4LY138w07HL86egs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987066; c=relaxed/simple;
	bh=1m+tSdA7Iy8ZbA3paClrbRKvf2NtcPI32kvrb+qsC38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkkZYUORf+7u0CTaEh24/wcOPxGKxyXCLuVBmLzkXtRj/XGJkauBGrXO4Go9oP6Yqz052Vj9tvVX1rQDs8Tafuw7o8jd3AKYdPGxvu0KLd3s7QRCG8yxDnc81pUj2ubIioV8TShkGmd1ODHPqxjn5nqhvjuPzA+s2BKBREWnOfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSer6tGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSer6tGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FE5C433C7;
	Mon,  1 Apr 2024 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987066;
	bh=1m+tSdA7Iy8ZbA3paClrbRKvf2NtcPI32kvrb+qsC38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSer6tGSR0sshlhCvU/O/e7sdcNU2Ua0ozs+hWsbmleuCC/jv4lcwbHE+BOUiZICn
	 uaStaWbr2DV3gIaTArecvvBvJ9EHH7y7OMB83/N/fRnfx/unhW5SzL6ifSSkSBDWAc
	 iGhJhROq+ZcpdGcM53upCvUHvK/Ui2+VFMCSUMro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 174/399] lsm: handle the NULL buffer case in lsm_fill_user_ctx()
Date: Mon,  1 Apr 2024 17:42:20 +0200
Message-ID: <20240401152554.371322475@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit eaf0e7a3d2711018789e9fdb89191d19aa139c47 ]

Passing a NULL buffer into the lsm_get_self_attr() syscall is a valid
way to quickly determine the minimum size of the buffer needed to for
the syscall to return all of the LSM attributes to the caller.
Unfortunately we/I broke that behavior in commit d7cf3412a9f6
("lsm: consolidate buffer size handling into lsm_fill_user_ctx()")
such that it returned an error to the caller; this patch restores the
original desired behavior of using the NULL buffer as a quick way to
correctly size the attribute buffer.

Cc: stable@vger.kernel.org
Fixes: d7cf3412a9f6 ("lsm: consolidate buffer size handling into lsm_fill_user_ctx()")
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/security.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/security/security.c b/security/security.c
index fb7505c734853..a344b8fa5530d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -780,7 +780,9 @@ static int lsm_superblock_alloc(struct super_block *sb)
  * @id: LSM id
  * @flags: LSM defined flags
  *
- * Fill all of the fields in a userspace lsm_ctx structure.
+ * Fill all of the fields in a userspace lsm_ctx structure.  If @uctx is NULL
+ * simply calculate the required size to output via @utc_len and return
+ * success.
  *
  * Returns 0 on success, -E2BIG if userspace buffer is not large enough,
  * -EFAULT on a copyout error, -ENOMEM if memory can't be allocated.
@@ -799,6 +801,10 @@ int lsm_fill_user_ctx(struct lsm_ctx __user *uctx, u32 *uctx_len,
 		goto out;
 	}
 
+	/* no buffer - return success/0 and set @uctx_len to the req size */
+	if (!uctx)
+		goto out;
+
 	nctx = kzalloc(nctx_len, GFP_KERNEL);
 	if (nctx == NULL) {
 		rc = -ENOMEM;
-- 
2.43.0



