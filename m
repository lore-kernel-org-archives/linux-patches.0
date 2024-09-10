Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17A11991BA;
	Tue, 10 Sep 2024 10:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963938; cv=none; b=j9+j9Xwd1oeSyuYjPMNgcSsw5EHN83ixj8BphETAxpFVYyPCuAsQYx9HURXiwvDQtojK3QTzQugBWEh3lzXa/jr1toVN01PFWeNusfNmZCHveuv/xUIZzHW35A3dFMg25Accjhcf5hipWahmGmIa0mGFT4JfpNqp9HA6pmdztuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963938; c=relaxed/simple;
	bh=xvRy+jTKXtSYQHW+M1IqJJTrNvHfF5BOmQKDzNnpaaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOO+YEqvNkzLS19aSs9RIFy1Hfy/nExVFFQL2KXl350EnZMd6e3FFXw/GAuHwcnKnwcVn1RcbH2wcg8pVOcn8kiKH2DAJpAmUT72WtAfGqONvNknRJKt1FVsYmtjUoBUgkMYMYjeB+/Pe5+8Zu+OL6YFSSmjI44yoiMaH06qHrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6rRcYld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6rRcYld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6916AC4CEC3;
	Tue, 10 Sep 2024 10:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963937;
	bh=xvRy+jTKXtSYQHW+M1IqJJTrNvHfF5BOmQKDzNnpaaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6rRcYld3kTM7Bhiiw+Miu2JrS9mOFfHyhLgpVLiSXSbhLjHAoMNjrGrnKQuHq8/S
	 SW+xGCFfKIxWTVYte+gC+ADCAf4YdlRl2hG27DStX9PCLWSou4QIB5nA2Hs8N57ZQi
	 53IaP6ZLwKLRbPuMLiDYC/gr0h2qn4+WloCG/LrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 013/269] ksmbd: Unlock on in ksmbd_tcp_set_interfaces()
Date: Tue, 10 Sep 2024 11:30:00 +0200
Message-ID: <20240910092608.728189217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 844436e045ac2ab7895d8b281cb784a24de1d14d upstream.

Unlock before returning an error code if this allocation fails.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -624,8 +624,10 @@ int ksmbd_tcp_set_interfaces(char *ifc_l
 		for_each_netdev(&init_net, netdev) {
 			if (netif_is_bridge_port(netdev))
 				continue;
-			if (!alloc_iface(kstrdup(netdev->name, GFP_KERNEL)))
+			if (!alloc_iface(kstrdup(netdev->name, GFP_KERNEL))) {
+				rtnl_unlock();
 				return -ENOMEM;
+			}
 		}
 		rtnl_unlock();
 		bind_additional_ifaces = 1;


