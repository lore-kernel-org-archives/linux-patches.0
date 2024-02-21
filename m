Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0659F7E115;
	Wed, 21 Feb 2024 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524760; cv=none; b=FNNuN7Wsck+SkvKFb/wqVSxN3PjDCuCEjqw5yZPHAnjeQAHDSEXzZwvrMZsKda9owcK2uvUwF8BLEXVI1WxtE7Doy9d552K1nNHi3V2btTn725QSNRebuMhNP1r0rrsdkOKluDfbR4CeqCV9xO8VveFxZ6HHLepoF8hMAsqH0wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524760; c=relaxed/simple;
	bh=anG3fuM12QvkboLUW2CAH3LyujcA//WzageQIlc0VLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp5jawpF1QdSsa57jGphgvvvNI+25k3q44rcmdzVXuDB5cqJ2v+HfNN7vwN7pPJBZmzi0gQXf0m8oFLD2w4dgDhm1rnG6IDelaTstqnB6w7WUZjfyyPL//kt639m9NouPW1ea+IKdOsFo8mrcQnufUBJOprJ55Fgvy6aB6+hDiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBPdbs3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBPdbs3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A87C433F1;
	Wed, 21 Feb 2024 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524759;
	bh=anG3fuM12QvkboLUW2CAH3LyujcA//WzageQIlc0VLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBPdbs3EVAhBb+4d6FOR3CNtTX2+nhZfyP4l+tLzvoQ+cJEwmKy5yBnHzNX4mfQpk
	 3r2KXyj+m16XqwDmkV8IlRLDr5AlU57La/FLrlknwQrgl5veFUKo7tQFrkKNlj/GWq
	 MMQXlYEk72rDg8zW/Nhgwbk2m8pyxTBGxuHERdYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 312/379] lsm: fix the logic in security_inode_getsecctx()
Date: Wed, 21 Feb 2024 14:08:11 +0100
Message-ID: <20240221130004.154053307@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 99b817c173cd213671daecd25ca27f56b0c7c4ec upstream.

The inode_getsecctx LSM hook has previously been corrected to have
-EOPNOTSUPP instead of 0 as the default return value to fix BPF LSM
behavior. However, the call_int_hook()-generated loop in
security_inode_getsecctx() was left treating 0 as the neutral value, so
after an LSM returns 0, the loop continues to try other LSMs, and if one
of them returns a non-zero value, the function immediately returns with
said value. So in a situation where SELinux and the BPF LSMs registered
this hook, -EOPNOTSUPP would be incorrectly returned whenever SELinux
returned 0.

Fix this by open-coding the call_int_hook() loop and making it use the
correct LSM_RET_DEFAULT() value as the neutral one, similar to what
other hooks do.

Cc: stable@vger.kernel.org
Reported-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Link: https://lore.kernel.org/selinux/CAEjxPJ4ev-pasUwGx48fDhnmjBnq_Wh90jYPwRQRAqXxmOKD4Q@mail.gmail.com/
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2257983
Fixes: b36995b8609a ("lsm: fix default return value for inode_getsecctx")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
[PM: subject line tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/security.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/security/security.c
+++ b/security/security.c
@@ -2098,7 +2098,19 @@ EXPORT_SYMBOL(security_inode_setsecctx);
 
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 {
-	return call_int_hook(inode_getsecctx, -EOPNOTSUPP, inode, ctx, ctxlen);
+	struct security_hook_list *hp;
+	int rc;
+
+	/*
+	 * Only one module will provide a security context.
+	 */
+	hlist_for_each_entry(hp, &security_hook_heads.inode_getsecctx, list) {
+		rc = hp->hook.inode_getsecctx(inode, ctx, ctxlen);
+		if (rc != LSM_RET_DEFAULT(inode_getsecctx))
+			return rc;
+	}
+
+	return LSM_RET_DEFAULT(inode_getsecctx);
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 


