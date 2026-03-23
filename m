Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8441A00F0;
	Mon, 23 Mar 2026 15:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278637; cv=none; b=BLuXfvLimmQ/3RmmstEU1OwDKN20RLREx8oq+kCpwQHOYFxzR8XN9BkehKU/C4dkdgYy/kuzQC2fr5+cqvqS5VqEndKpuRN2lfuYyMlYJI7Opp68kxz4x8UVZUyWaklVrUMPpC7PZ7RFcpKw+LW0vKRZ1JXoINids5nvtOkeYXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278637; c=relaxed/simple;
	bh=HcomlFf98fbDfsKOGt0R3SmRFkQYqI4K6BpnIRLX9tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmQdl4qS9102q1UHEvNguV1UXG/66rFGa/3B2NDe7vV5CaxmwMMeuGytt4MxdHNFA8Ica8Mub0lNR07jc4JM9sWGMRr1L4MWeg4AG50/v6Tf3rsj0kBKVoqPTgBd6zmI9naue+KU4KmyZYIB/Wd8BDreZOc36Posug96bbj9U4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGeMa8JV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGeMa8JV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506EFC4CEF7;
	Mon, 23 Mar 2026 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278637;
	bh=HcomlFf98fbDfsKOGt0R3SmRFkQYqI4K6BpnIRLX9tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGeMa8JVzt8GSX0Kiw3teY0X0luszpglSLwX8t5IK4vHNUH6f1rPea+OOrKdlQaLi
	 rlaMBS2kaJTmEN2CDgc8OM7RKw8X13fUvVvV7BULilRR4qvYUzoFQrgRYzBy56ic26
	 cgNUetbg4NFcRMh6EBFbTGBSzTu2L6KaA1tGO168=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 328/567] ksmbd: fix use-after-free in smb_lazy_parent_lease_break_close()
Date: Mon, 23 Mar 2026 14:44:08 +0100
Message-ID: <20260323134541.947706856@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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


