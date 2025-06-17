Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685E82FA64B;
	Tue, 17 Jun 2025 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179121; cv=none; b=Onn+NUmFr0gQlmT1jnlbz4Wgv75d+JDt2OrfFwW1q4W/qk1ZFoVitX8JIuy4LJKIzEEbOCfXkKYWJGCfoxF7NXyN3VexnO/mO+AILj4ADLI2WexBMvHz7fqTfNqsh5ygdA3Sd2RlNSIRU5m1fQoJv2OxgogQeSX9x5Ax5Smz/QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179121; c=relaxed/simple;
	bh=+EcobqS7Td1NDBFGDMuquSuJl98Sk4TjrPXUDPcKBD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBsEPvmcmfriJ8uWe0+8AM7Uuf5qHaHv2wbCs+5HyyOjp0xrfsBx8SXJDMBTkjJGga2SJ/3Oq0Q8CzNVQ8ibA5zPuacxg/Z/oLyZVH0c3Y1lInqQ7lbGAxpymW8xyikSAa2Sy9toDetcp7HgxKeP3l1zbe3Nzs84JsJ6hP10Mz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTlS/q4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTlS/q4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDE3C4CEE3;
	Tue, 17 Jun 2025 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179121;
	bh=+EcobqS7Td1NDBFGDMuquSuJl98Sk4TjrPXUDPcKBD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTlS/q4ipmJlWdhPwHJANmnA9+fXGKDRHX5RVqJeHEcZ4nz/pyoblSm1kNzYzXF4b
	 neBNRz6OypUhxjaaCHDyFADRDJRkAPiv/fb/FDQQYDaLvnsrEANO79KY70p13boQ4y
	 nR5UhDxmbzLqKfjKouSBga7k0l/qhhC0AVFGpbxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 655/780] clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns
Date: Tue, 17 Jun 2025 17:26:03 +0200
Message-ID: <20250617152518.146283204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit c28f922c9dcee0e4876a2c095939d77fe7e15116 ]

What we want is to verify there is that clone won't expose something
hidden by a mount we wouldn't be able to undo.  "Wouldn't be able to undo"
may be a result of MNT_LOCKED on a child, but it may also come from
lacking admin rights in the userns of the namespace mount belongs to.

clone_private_mnt() checks the former, but not the latter.

There's a number of rather confusing CAP_SYS_ADMIN checks in various
userns during the mount, especially with the new mount API; they serve
different purposes and in case of clone_private_mnt() they usually,
but not always end up covering the missing check mentioned above.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Reported-by: "Orlando, Noah" <Noah.Orlando@deshaw.com>
Fixes: 427215d85e8d ("ovl: prevent private clone if bind mount is not allowed")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 07bc500a248ec..163ffdc042284 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2509,6 +2509,9 @@ struct vfsmount *clone_private_mount(const struct path *path)
 			return ERR_PTR(-EINVAL);
 	}
 
+        if (!ns_capable(old_mnt->mnt_ns->user_ns, CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
 	if (__has_locked_children(old_mnt, path->dentry))
 		return ERR_PTR(-EINVAL);
 
-- 
2.39.5



