Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA074369204;
	Mon, 23 Mar 2026 14:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275643; cv=none; b=iK6W9Q3GTzlE9J+UOgf+9FEVSYbW8Ofn/+XqNQZUbvmk7Gzil9EjrfyYAotswthicMgamOwIZeW0lJr1r105/L5N8KBtxj7Ypp9q//Acn5UJYZik4L0iBEXJD2dyH4jwIqDv2t8giecMdPkOXS/+SJ2a2Lg9KPpGcpXXWlct94I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275643; c=relaxed/simple;
	bh=1kZq8OIeBXOp7N1jcXLHXSS6LJBghEdnYeFbw20EL/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy+6yoSvUCaKnG3tuX41jLi0igNKA6k9Z7wqG6ycmvNMnQUCMpDkgAgNrQmPlwb32qxKn241zlHvK9cB87B/LbxFdu/RjEnRDlcJwI/O+ajtgm/DFFZXpVZ29+0BZXkEmzLXc9J4pbWRh4S2mh7txSJBKGHGRUIpyJm4V4vPjf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfziB0RC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfziB0RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C95BC4CEF7;
	Mon, 23 Mar 2026 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275643;
	bh=1kZq8OIeBXOp7N1jcXLHXSS6LJBghEdnYeFbw20EL/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfziB0RCFzz3iNbUq8u5gQCZFWm3MJoWLOOCh33l7FHzl9KskKIVM8LR6qXzGVOK4
	 ueI3HZwIDq6D71gAsxNqTnpv5mDAQzC53UG/R0YjDfbCviykdl8p+NQkZh3sZVXWv9
	 QGn1qqhDa7dL2oUvabtcHknaRZxfmBpLX5apbE7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 170/460] ksmbd: fix use-after-free in smb_lazy_parent_lease_break_close()
Date: Mon, 23 Mar 2026 14:42:46 +0100
Message-ID: <20260323134530.719980912@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit eac3361e3d5dd8067b3258c69615888eb45e9f25 upstream.

opinfo pointer obtained via rcu_dereference(fp->f_opinfo) is being
accessed after rcu_read_unlock() has been called. This creates a
race condition where the memory could be freed by a concurrent
writer between the unlock and the subsequent pointer dereferences
(opinfo->is_lease, etc.), leading to a use-after-free.

Fixes: 5fb282ba4fef ("ksmbd: fix possible null-deref in smb_lazy_parent_lease_break_close")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1123,10 +1123,12 @@ void smb_lazy_parent_lease_break_close(s
 
 	rcu_read_lock();
 	opinfo = rcu_dereference(fp->f_opinfo);
-	rcu_read_unlock();
 
-	if (!opinfo || !opinfo->is_lease || opinfo->o_lease->version != 2)
+	if (!opinfo || !opinfo->is_lease || opinfo->o_lease->version != 2) {
+		rcu_read_unlock();
 		return;
+	}
+	rcu_read_unlock();
 
 	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
 	if (!p_ci)


