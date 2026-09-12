Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BB71DA62E;
	Sat, 12 Sep 2026 11:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213168; cv=none; b=AIuFRq4MAdVZxVGekLQCTAj9K+Mrtn5y9dytj0bIOMIKe9nTT/BheKOlVm2NzNW1Bbmfrsn+oTSiVSIF1dC7gArJoE7637bwjKoVpoS7Cmbm6/NNPBvPnn0iCz1I1eI+zWv8VsZBVYJa6ICLfupcS+nokn2KQw94J/bIcpER7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213168; c=relaxed/simple;
	bh=gGcyP7eVNTz1izuyGRg2gfLy03Hnn4SsSMCynYL6PUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXsUQboXCv/45ekgdCzONz9uG/7kqQULJRwXe2iyMHeHF6+Oj6EtYY/dCH4on/8/Tev3lZRK6jxNY6ZgHexlzOqXcZDwAFgNMAq8zarlZmULvKrlX494XR+feZ3SaS/YpL2SA1OFAPiC2JXd1BYCY09hROjvV6OHq0U2DQM9Ub4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uG0VBkab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uG0VBkab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B39A1F000FF;
	Sat, 12 Sep 2026 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213167;
	bh=WUuVrNeCNsr3RWSabI1cF7XdlhrJDil0Wj2EvXdpDsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uG0VBkabEY9FZw5d7uA5hyhKvquep1j4rYVRDjkq95+nJd0EP7SlF0/N/ZCHwYyuB
	 /3VGxOCWZkErnYl+aYZNinvhvoR9ZMrleOfnfQxqnD1OocuTXSzipr4czV26dAptbh
	 tigiRkov6VYKcdlbnpmQ7A6EuM2yaPmYg0uTQeOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5ebeb3089ea6439c37be@syzkaller.appspotmail.com,
	Bradley Morgan <brads@mainlining.org>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.12 0066/1376] ima: Check for ERR_PTR from dentry_path() in validate_hash_algo()
Date: Sat, 12 Sep 2026 08:41:32 +0200
Message-ID: <20260912065609.031551617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <brads@mainlining.org>

commit 8861f6d5c0678a7c5089c7b272509fc5931b8437 upstream.

dentry_path() returns ERR_PTR(-ENAMETOOLONG) when the path exceeds the
buffer. validate_hash_algo() passes the result straight to
integrity_audit_msg() without checking. ERR_PTR is not NULL, so
integrity_audit_message() sees a valid pointer and calls strlen() on
it, which faults:

    BUG: unable to handle page fault for address: ffffffffffffffdc
    RIP: 0010:strlen+0x30/0xa0
    Call Trace:
     audit_log_untrustedstring+0x19/0x30
     integrity_audit_message+0x366/0x4f0
     ima_inode_setxattr+0x512/0x5f0

Check for IS_ERR() and use NULL instead, which makes the audit message
skip the name= field instead of crashing.

Fixes: 4f2946aa0c45 ("IMA: introduce a new policy option func=SETXATTR_CHECK")
Cc: stable@vger.kernel.org
Reported-by: syzbot+5ebeb3089ea6439c37be@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6a8f89e5.1d9ded08.62e62.00bf.GAE@google.com/
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_appraise.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -754,6 +754,8 @@ static int validate_hash_algo(struct den
 		return -EACCES;
 
 	path = dentry_path(dentry, pathbuf, PATH_MAX);
+	if (IS_ERR(path))
+		path = NULL;
 
 	integrity_audit_msg(AUDIT_INTEGRITY_DATA, d_inode(dentry), path,
 			    "set_data", errmsg, -EACCES, 0);


