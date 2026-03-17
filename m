Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BE63793CF;
	Tue, 17 Mar 2026 17:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768158; cv=none; b=pvVfopwqARxwZ97mKIrNMpU2wJD5hDhY2XbIad4XQ7xKTukB0VvAGM+ULRiJ0ran7PVRUMZ5zpHEVriyTTzydsCWi5cXXL0ZlYdQDk5rgFQmKKYsfOFCL+dI+b03JwpmnulFm35NfaJBZO5KT8TBWq6ZTY1yERBwCg/eo5FINtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768158; c=relaxed/simple;
	bh=H6gTunECsE3O+55Wyo7HdBeurFXymgBhAAS0qGlUz50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlL8hisNN22llwfk7XNh5KroKbKH1w+7ZWAlVyiiOHa5ZLBJ/yEZaHTQGIoJ9pvhAmxuPS64QcU3qCXQJ4H7+J38LojpNJ7Dx2rqZLbqz3HdgITWxm5ETjYhZWhZ8rVmTryvqKKr0mnG9FXx4C1afoXMHLWsV3JUpcTFUhD1eXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7/h5Pd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7/h5Pd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF11C4CEF7;
	Tue, 17 Mar 2026 17:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768158;
	bh=H6gTunECsE3O+55Wyo7HdBeurFXymgBhAAS0qGlUz50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7/h5Pd0xzF43mgFN7MLQb3hd4uD2J1UwG+d4Y2x0AXiuj53YDmcVvZyryM6GcCMb
	 ln602o6WgCAddUunDCFUgx/I1W5c43XMpir9nH7Q4+FUjtNYB/l0ypt2bX+KleQD2D
	 2dhIs42JVUdZPcqWFCCMP2bEx6X8B7BTF4pEatnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 242/333] ksmbd: fix use-after-free in smb_lazy_parent_lease_break_close()
Date: Tue, 17 Mar 2026 17:34:31 +0100
Message-ID: <20260317163008.339146008@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


