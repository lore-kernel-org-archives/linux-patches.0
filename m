Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4B32566;
	Tue, 15 Jul 2025 13:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587281; cv=none; b=BvyrTQUJ8jwPuyVpjr65sx2YvONVH0uZw7+TB5En9yOawq5XH6T2Qm6X/pPpyUOoqgax5SHB1FjFC2hMPMmasWlnyFiE9CJKUi909aSxtD4PGBxHU4fIhbYG+jTIYVUSeDdYSFm25cR8QqjXiDRaZKQd+IoQXW+sdUZ4z9z55bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587281; c=relaxed/simple;
	bh=xqlekwcaxr42tctdZzfpiT004gFbsGdZxLQpxLarN/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/lemFwtu+F3qGbqU91YSc6G7aKWC/OzvoQgnmeLgl3Nb9Sy+Yzjb8DzObDWcVeucGMXLI/6EaHjVB3st/6X2LkxDvTN4OdnkliSJ8I4htdud6wOJuaKlZ7y4pKqZxnVPYu1nK1rP1FRt48tpG9y6PG8jDmLGniKqQVmQ0sjg8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNsj5E7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNsj5E7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C934C4CEE3;
	Tue, 15 Jul 2025 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587280;
	bh=xqlekwcaxr42tctdZzfpiT004gFbsGdZxLQpxLarN/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNsj5E7OycOsuLGQOU7WzNzhgHp9kK2q89IAfoiyHpKc5VTsHM8fvR2Fe9lhqjFsg
	 S9mCNFjiKsMaCJXZun5jFHl+/Q5xxFT6UxcbJmLY64h0eCCm6t0o4OanAMVYGgX/LX
	 isZz2JslfSXfrgJRMSLXlZEPrzzIQ1cINU0+zePY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/88] vsock: Fix IOCTL_VM_SOCKETS_GET_LOCAL_CID to check also `transport_local`
Date: Tue, 15 Jul 2025 15:13:47 +0200
Message-ID: <20250715130754.960271812@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 060e971299873..678b809affe03 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2365,6 +2365,8 @@ static long vsock_dev_do_ioctl(struct file *filp,
 		cid = vsock_registered_transport_cid(&transport_g2h);
 		if (cid == VMADDR_CID_ANY)
 			cid = vsock_registered_transport_cid(&transport_h2g);
+		if (cid == VMADDR_CID_ANY)
+			cid = vsock_registered_transport_cid(&transport_local);
 
 		if (put_user(cid, p) != 0)
 			retval = -EFAULT;
-- 
2.39.5



