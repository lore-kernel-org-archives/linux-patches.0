Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA62188A38;
	Tue, 10 Sep 2024 10:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963834; cv=none; b=k3Py//C3RjUrNQI5xu7AOlzTVrdORlbbIuzIaWu1JCVsESyK2LI6y8tv4VZgNBSx4bJxNI3eJzi/AU6QizoL/0qQnNH2eZuYe1WpcANFQ3dexJFhthohY9mJ/vN8Caanpyhwrm3A46ped6OKTncdngAYEFEMuXnBfwGOHTMk2/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963834; c=relaxed/simple;
	bh=IbImy3v4duGMe39mEa36WJ2Qygp2nJUsfBDoindqFBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEcVUre3A0RNXDLlCtjCgUZ+tZdHQSHh0/RCDlG2lam1Nq6GF1h6I9hWDCLi8MvF5pxcxWZpk5TRJJr6BCo7zkQyMcP2YtlFbxogFet0m5rWoRhai48hALYngebj50vF/ZBJLjMhxraI319RewpVO6V8+L17F89ro9mZ8QdclnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXFEzXt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXFEzXt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9880C4CEC3;
	Tue, 10 Sep 2024 10:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963834;
	bh=IbImy3v4duGMe39mEa36WJ2Qygp2nJUsfBDoindqFBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXFEzXt+eZLhbiyW1IgnPm6SFrLO3xRIXhR+nzk9jDTIy+paiBz1JNAovDMG/o6Kb
	 QLdSpVxXSM8KOylQMvgsoHX86+zWhG2DEOJJ7oOah6VK5iVJjxMPCHncbMoDZ/JKSj
	 PTFusgNyv3TnD3H1XDvdRm15hS+xalzUW03ZEM6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/214] ksmbd: Unlock on in ksmbd_tcp_set_interfaces()
Date: Tue, 10 Sep 2024 11:33:34 +0200
Message-ID: <20240910092606.457191792@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 844436e045ac2ab7895d8b281cb784a24de1d14d ]

Unlock before returning an error code if this allocation fails.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 9d4222154dcc..176295137045 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -618,8 +618,10 @@ int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz)
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
-- 
2.43.0



