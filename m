Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008272EE614;
	Tue, 15 Jul 2025 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587791; cv=none; b=qBeSJIs2McVdgBn9F+aZ4xBOMXMZPp4rXz/GQnmIyMy/i/fJVESjakXK8pp0yfl3lLo3ELokzVovfD8zDcRVVKf1Dyec7rEcrHoRWFu8Ia+qVvz7S4u86otz+RbiqK4TN9IoD46U3wMN0ZoGgwwyICfvCNQVd57Baw4ac3apJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587791; c=relaxed/simple;
	bh=F83vGXlXxq90SMjMJWucD4JPpuvnhbHzDeiSFljrKKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e24aMae2p7CkydOf9Nwv2VqDRxGGh+CjOxq7RfZZXyQjG6BDy0tGEexnONu6o51Sgz4iZa8iwRDkdIpVuQ95VR8AtRmd5EU6VSEBTjeow9HsErU55kSIwwdvCTAf1cVXF4uAn/lbsXuxVG6Rzbys7VgfTUAiA9IduqQdpzeD0ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekeubNnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekeubNnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877B4C4CEE3;
	Tue, 15 Jul 2025 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587790;
	bh=F83vGXlXxq90SMjMJWucD4JPpuvnhbHzDeiSFljrKKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekeubNnqF1U0/RHpu6fFWMWIuQ1QVKFGtl9623w97dzdgzlH4Ks61wiIFrL7paUUL
	 Q1SqcwTD1xZ2ddpX4EGCjpqhP/vz0CiYY6CDHyozlVZAHapj6fnUt6uFNeJQAlL/OU
	 Uu9kIvDS/iHlKZX879rH0MD5uGFr5L7CD8tM0Yf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/208] vsock: Fix IOCTL_VM_SOCKETS_GET_LOCAL_CID to check also `transport_local`
Date: Tue, 15 Jul 2025 15:14:14 +0200
Message-ID: <20250715130816.728754335@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f65868d2e82c3..56bbc2970ffef 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2186,6 +2186,8 @@ static long vsock_dev_do_ioctl(struct file *filp,
 		cid = vsock_registered_transport_cid(&transport_g2h);
 		if (cid == VMADDR_CID_ANY)
 			cid = vsock_registered_transport_cid(&transport_h2g);
+		if (cid == VMADDR_CID_ANY)
+			cid = vsock_registered_transport_cid(&transport_local);
 
 		if (put_user(cid, p) != 0)
 			retval = -EFAULT;
-- 
2.39.5



