Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936961A23AF;
	Tue, 15 Jul 2025 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585425; cv=none; b=LqoaxYBdd+Y2sLFDyE8viIDYRqNJjKAW9veM2rpv/vh1yEsUA7mwgutFqaQTsFCYbSyplYZKem66Z0vLjiKfZ4eWRJETSXkQYG4njy4e0e1hrPtDh98hFsupl0SqXNB4UZ6J2KNhCTo/8azXBS+8adTxdRRBVUDRwRQBpcjowPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585425; c=relaxed/simple;
	bh=yr4yyJ1vfKDvIdY/3aFkg/cD+ynguTGN6VgN5/SSKGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkS+5hFxyn5ehZcoUzIa2hHxqbYaVpIG9WsWwlbgUrGB+jP6B6ihyhzmj4etCJ95jZAaG6KOke1mJRXjk+cDJNUbWrlWkR+cvDx5DrDWdTqyL0I7P1k53uxE79k5ANWOYbZLDAb35jLPHslge8/BghdAKzsO/nSVQgavoCgJBi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzsYcnL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzsYcnL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272CCC4CEE3;
	Tue, 15 Jul 2025 13:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585425;
	bh=yr4yyJ1vfKDvIdY/3aFkg/cD+ynguTGN6VgN5/SSKGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzsYcnL23dt4zYq2ibdbI3MUFDgVjPXuXvYfKckls8ycMAh+aaqDOu1LryduJBkOy
	 mWpWUNUr+TTnH9Wriy4qG6ucOZSG4Ocii+xtJqnExUFoKd1Xl0ywimbUMPESq1PmBs
	 1lhkk9f5+oa90jtfBhxxHHMil48Pd3uF/9AxA6vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/163] vsock: Fix IOCTL_VM_SOCKETS_GET_LOCAL_CID to check also `transport_local`
Date: Tue, 15 Jul 2025 15:11:43 +0200
Message-ID: <20250715130810.164708093@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 1e7d9df379a04ccd0c2f82f39fbb69d482e864cc ]

Support returning VMADDR_CID_LOCAL in case no other vsock transport is
available.

Fixes: 0e12190578d0 ("vsock: add local transport support in the vsock core")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250703-vsock-transports-toctou-v4-3-98f0eb530747@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 108e4cef7edd5..08565e41b8e92 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2547,6 +2547,8 @@ static long vsock_dev_do_ioctl(struct file *filp,
 		cid = vsock_registered_transport_cid(&transport_g2h);
 		if (cid == VMADDR_CID_ANY)
 			cid = vsock_registered_transport_cid(&transport_h2g);
+		if (cid == VMADDR_CID_ANY)
+			cid = vsock_registered_transport_cid(&transport_local);
 
 		if (put_user(cid, p) != 0)
 			retval = -EFAULT;
-- 
2.39.5



