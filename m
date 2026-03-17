Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767933F7A8B;
	Tue, 17 Mar 2026 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766642; cv=none; b=ibduE0uZbka1vXkWPI6+ZbyqvhHLzJ8Mk4QpJNjomLNs90e4ltbqnGDh6RkkEsEE11Nu3a/uTEjDj/pmk7wUSEVxSxmnUMdEq45Wj8aGOT2RHmli/KjWa3FJ9miaqxKFxrkXEXYl6Fp/0ge4zbB6yxhW1kqsIM1OnKYBWXgetW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766642; c=relaxed/simple;
	bh=4+BdIaJy6eQ7JGoHp/9V8gOwy/M4n91ScRarHkXfyHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7HXrRLruw6tIPRC+ArbWBSQ3qA2IPjxUxcSPqyJ35ANvEyLr+v1wwLd4JNLZxCbGu4SS9zy9+/dpEwSuzap7AkON3Y1vrT4qARP8UPoO5YW2QcbRVXTXQh6XxH7nuqJUQVDFlDLrHYYu5YBEUCVLzurazv1Ioz48/XydeX7mYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBUalQRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBUalQRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA91C2BC86;
	Tue, 17 Mar 2026 16:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766642;
	bh=4+BdIaJy6eQ7JGoHp/9V8gOwy/M4n91ScRarHkXfyHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBUalQRUIB9/7i5ykWXf3nimv6VDtv3VIlVeTMVloND+X4FC1gVb3lDkbEgDL99hA
	 f+1rFl7eKgtXmzXd2jjwfESVmWtZO7OyFPHinT/VU21rLEC+kyh7FpLis6YhlxKhwD
	 5kPiVjws3H9HpMDsxW2hmZet8hDGo6ymO7nQyXWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 290/378] ksmbd: fix use-after-free in smb_lazy_parent_lease_break_close()
Date: Tue, 17 Mar 2026 17:34:07 +0100
Message-ID: <20260317163017.680403962@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


