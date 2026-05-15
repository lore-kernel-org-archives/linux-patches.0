Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69E93E0081;
	Fri, 15 May 2026 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861226; cv=none; b=p4PbKEXLWzhxc0UqcCiomzGqhTS8uMGlIw4E6LAoHhdf0Qvsu46dYP7MVAjeZr5eM2EDMa2BAhOJmWwOHwqJbcovxb7Vkf7it6st5xXjNRUoQ38Hdy2wFFF6qlU7FTsBE7PZJ3aCGRqMGt1hzEE33n/fMbhG8jJSrn7jZTRQDNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861226; c=relaxed/simple;
	bh=ibEDBS9xz68cohX03o7QEcpuEa0ekUd/lrtfacWLfM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiggPrkFqaM5wEG2zh9D/eoZb337PsWXZWj+N/yEE99sris4yu9ytaWhbiL64dijX1lE0sNkFYqO0GIDGbmBzPc1w8DAFnxcnZs3jVKL/YoQQCTv6jrapsMLEvti+eX3rO0+TCxlwoy+JH3kbv5kQVWtg/DgYk70zzE06u9vJaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lerDe4ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lerDe4ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC26C2BCB0;
	Fri, 15 May 2026 16:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861226;
	bh=ibEDBS9xz68cohX03o7QEcpuEa0ekUd/lrtfacWLfM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lerDe4MEK3n2nArbqfXMCtFTkKVtF3+GWX8GCG2BF+JlRKr7dEYKW9H7AZ0uxXv8v
	 zQkXL+Wokt7x7/RGQhQ+RmTGATdFQoHOpfoZjvTcdKNcBHqjNnfMoyBA/g4R8eGIkV
	 al9nc55x/a0u/CdTH/Imlv9LP9jCkp89oezFA07s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 205/474] selinux: dont reserve xattr slot when we wont fill it
Date: Fri, 15 May 2026 17:45:14 +0200
Message-ID: <20260515154719.448813120@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: David Windsor <dwindsor@gmail.com>

commit 1e5a8eed7821e7a43a31b4c1b3675a91be6bc6f6 upstream.

Move lsm_get_xattr_slot() below the SBLABEL_MNT check so we don't leave
a NULL-named slot in the array when returning -EOPNOTSUPP; filesystem
initxattrs() callbacks stop iterating at the first NULL ->name, silently
dropping xattrs installed by later LSMs.

Cc: stable@vger.kernel.org
Signed-off-by: David Windsor <dwindsor@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2903,7 +2903,7 @@ static int selinux_inode_init_security(s
 {
 	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	struct superblock_security_struct *sbsec;
-	struct xattr *xattr = lsm_get_xattr_slot(xattrs, xattr_count);
+	struct xattr *xattr;
 	u32 newsid, clen;
 	int rc;
 	char *context;
@@ -2930,6 +2930,7 @@ static int selinux_inode_init_security(s
 	    !(sbsec->flags & SBLABEL_MNT))
 		return -EOPNOTSUPP;
 
+	xattr = lsm_get_xattr_slot(xattrs, xattr_count);
 	if (xattr) {
 		rc = security_sid_to_context_force(newsid,
 						   &context, &clen);


