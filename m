Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48DE2E06E4;
	Tue, 25 Aug 2026 13:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665829; cv=none; b=KvBeg/6cFQ5+yHq77LTPZ9wIuZLIX3MBpXb6XW4enfd6fRScJyIt2XF/1z9RBbmv2YDQxcvPKLJQ90vfrUsMakasVRodELPZWVOGeUgF7tPxC7Uehv0OEvTbQcWYMPFMIuqDmoyfTgQ7iYBw1ASgSwv/pWfblRi0oGq+3ecMzJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665829; c=relaxed/simple;
	bh=aR+F6aKKGowyUqDy/7LTNu23QMhFqjnTcRtWX42tVJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loqWxRn8WDEfkryqjYEMndhXQeNCuuHhT2wZItJVXMRkhEelqMcERRTH53711anqXOAzRIa97OrLN0rJhd8NTp98t/EzMlZiruWGShhY5rvSCmJog4iZISS3SddNdQkik7jIvBEUhE+LwD0gICBYS+qMywRs+kUnfbNVL2aQbxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/FcaY0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/FcaY0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B851F000E9;
	Tue, 25 Aug 2026 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665827;
	bh=EKHy2wk18iodn3KwPrOeNbMCV75EVJLNAPbPMd22Eu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/FcaY0LhwQjRJ9H10t0TBK8rjrRMH7DTF/0yMenzf9QD+pq9LKNA2xeJNia2BHav
	 nUb7kPDDD8PBrF0nRwRcYnGCefsRxGBjpjNHYG4m6nTZQ6BnaNo7CPsn80v5e26o9R
	 pAh63Jp6PupuJIbWCHoG5IVvSgCvNjLVtxlGT7bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 80/87] selinux: reject a permission value exceeding the class permission count
Date: Tue, 25 Aug 2026 15:26:43 +0200
Message-ID: <20260825132544.963026626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit d14b5d0e97fccd27974fedc03b903408872907fd ]

perm_read() bounds a permission value by SEL_VEC_MAX but never by the
nprim of the owning class or common, which is taken verbatim from the
policy image.  security_get_permissions() then writes perms[value - 1]
into an nprim-sized kcalloc() array, so a class declaring fewer
permissions than its largest permission value drives an out-of-bounds
heap write.  The top-level symbol tables are validated this way; the
nested per-class permission table is not.

Reject a permission whose value exceeds nprim, which is already set when
perm_read() runs.  Well-formed policies are unaffected.

Cc: stable@vger.kernel.org
Fixes: 55fcf09b3fe4 ("selinux: add support for querying object classes and permissions from the running policy")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: tweak comment for line length]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Stable-dep-of: b98a8ac50775 ("selinux: require a class's permission values to cover its permission count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/policydb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1120,6 +1120,9 @@ static int perm_read(struct policydb *p,
 	rc = -EINVAL;
 	if (perdatum->value < 1 || perdatum->value > SEL_VEC_MAX)
 		goto bad;
+	/* indexes an nprim-sized array in security_get_permissions() */
+	if (perdatum->value > s->nprim)
+		goto bad;
 
 	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)


