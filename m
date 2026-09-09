Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1EF4F55A5;
	Wed,  9 Sep 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962097; cv=none; b=aawp3moTKjEzcA4eHEbMNT4p6KJeS5ams8n1F5c7FzZuct8RufuZEx4SoCywPdpoSnTFB2DCp1zlJ/IoD1IDRMUziP0asFzzo4zdvwfeVcAlxG2IRn1pVwsct3am1abF6zygZ5iMJXcjsfj9SyVKtXg4Z5Ej9NyEm/2D8MEjJpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962097; c=relaxed/simple;
	bh=wXB6ynSCe25Gdalf2mGjfg/XRw+VYayJLfy54ECxr5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9p2SFb/pGCRDgWcIZ4Uad1+yXE2dn9OJNZqVvA9d9mnS0ACYNRBq9C2RYon+Pd7LubH0gSwO0jtL3LOH4ukEr+3ZDflD7IA6vqVrWLvOcV8kD7fRLJ7UExmn+uBUswYaW724FiCfxKVRXwjfIEDByNcTSM5rLylbJdb2Pr+9CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qho6Urz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qho6Urz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553701F00A3D;
	Wed,  9 Sep 2026 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962095;
	bh=AlxWqvmfYtHLdjfqwmCVk4e7W71ylBaNhty2evaj/qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qho6Urz5I6YpjblL0bzebCYNvvUIiB4BaVOMdBvCreXFHZNMVVKVFEZ9RkYs5UeYQ
	 aruMe79T0GbD9y/q+RqJYXTgEnly5afob2XLas4+XJ8SCq+jf22dMkefr27sg8AeKs
	 tIr8WTzD1CQwctYvyw0Vi5DED0IXF1Tc0R7WevC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5ebeb3089ea6439c37be@syzkaller.appspotmail.com,
	Bradley Morgan <brads@mainlining.org>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 7.2 121/556] ima: Check for ERR_PTR from dentry_path() in validate_hash_algo()
Date: Wed,  9 Sep 2026 15:36:41 +0200
Message-ID: <20260909134234.721971348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -748,6 +748,8 @@ static int validate_hash_algo(struct den
 		return -EACCES;
 
 	path = dentry_path(dentry, pathbuf, PATH_MAX);
+	if (IS_ERR(path))
+		path = NULL;
 
 	integrity_audit_msg(AUDIT_INTEGRITY_DATA, d_inode(dentry), path,
 			    "set_data", errmsg, -EACCES, 0);


