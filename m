Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA5D4779A;
	Wed, 20 Dec 2023 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAknty+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E608BC433C7;
	Wed, 20 Dec 2023 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088656;
	bh=LH5Epen+O8TIOCjJlkoSfgdRLLZoBJe3CK2Br9mWinw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAknty+Cq63kyv83dYwL2JD+hyvm2BNUCmegstd8zx0o0uRj3Qgk1qRWFpqlycLHr
	 XRoRyY35zy2YkzEa2mv0gIviM4zI7uk09rraV1XaFQcTR05hN5gfyi1tHb4j47cCE0
	 XgH1SQB+QGPeaRXXGOPSZlme/eH8RYOUlBWVaQjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 011/159] ksmbd: set both ipv4 and ipv6 in FSCTL_QUERY_NETWORK_INTERFACE_INFO
Date: Wed, 20 Dec 2023 17:07:56 +0100
Message-ID: <20231220160931.815239095@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a58b45a4dbfd0bf2ebb157789da4d8e6368afb1b ]

Set ipv4 and ipv6 address in FSCTL_QUERY_NETWORK_INTERFACE_INFO.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7328,15 +7328,10 @@ static int fsctl_query_iface_info_ioctl(
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
-	struct sockaddr_in6 *csin6 = (struct sockaddr_in6 *)&conn->peer_addr;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
-		if (out_buf_len <
-		    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
-			rtnl_unlock();
-			return -ENOSPC;
-		}
+		bool ipv4_set = false;
 
 		if (netdev->type == ARPHRD_LOOPBACK)
 			continue;
@@ -7344,6 +7339,12 @@ static int fsctl_query_iface_info_ioctl(
 		flags = dev_get_flags(netdev);
 		if (!(flags & IFF_RUNNING))
 			continue;
+ipv6_retry:
+		if (out_buf_len <
+		    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
+			rtnl_unlock();
+			return -ENOSPC;
+		}
 
 		nii_rsp = (struct network_interface_info_ioctl_rsp *)
 				&rsp->Buffer[nbytes];
@@ -7376,8 +7377,7 @@ static int fsctl_query_iface_info_ioctl(
 					nii_rsp->SockAddr_Storage;
 		memset(sockaddr_storage, 0, 128);
 
-		if (conn->peer_addr.ss_family == PF_INET ||
-		    ipv6_addr_v4mapped(&csin6->sin6_addr)) {
+		if (!ipv4_set) {
 			struct in_device *idev;
 
 			sockaddr_storage->Family = cpu_to_le16(INTERNETWORK);
@@ -7388,6 +7388,9 @@ static int fsctl_query_iface_info_ioctl(
 				continue;
 			sockaddr_storage->addr4.IPv4address =
 						idev_ipv4_address(idev);
+			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
+			ipv4_set = true;
+			goto ipv6_retry;
 		} else {
 			struct inet6_dev *idev6;
 			struct inet6_ifaddr *ifa;
@@ -7409,9 +7412,8 @@ static int fsctl_query_iface_info_ioctl(
 				break;
 			}
 			sockaddr_storage->addr6.ScopeId = 0;
+			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 		}
-
-		nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 	}
 	rtnl_unlock();
 


