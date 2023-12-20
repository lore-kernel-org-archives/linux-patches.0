Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791EE48784;
	Wed, 20 Dec 2023 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHJAyfuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75D7C433C7;
	Wed, 20 Dec 2023 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088812;
	bh=z6HQWmTt5jIgxkJF55hIeHWndO1OulG6QnnJALsQziY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHJAyfuUaHpaqfQjBmn5tWj3jU9lxxsIZ7AvvM770qUjBpoYyi+GQlUULgEhr43cq
	 c7CGyp/UG0zpiSOPRKZpEIYpAumzBlWygtK1w4C9F4L5nS+IQONEU6LcDL0lC4MrTh
	 WHblIwmaVIbQFZXBgIBVPEVaeSXG1Ztvj4TXmb7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 060/159] ksmbd: hide socket error message when ipv6 config is disable
Date: Wed, 20 Dec 2023 17:08:45 +0100
Message-ID: <20231220160934.146099740@linuxfoundation.org>
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

[ Upstream commit 5876e99611a91dfb2fb1f7af9d1ae5c017c8331c ]

When ipv6 config is disable(CONFIG_IPV6 is not set), ksmbd fallback to
create ipv4 socket. User reported that this error message lead to
misunderstood some issue. Users have requested not to print this error
message that occurs even though there is no problem.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -428,7 +428,8 @@ static int create_socket(struct interfac
 
 	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
 	if (ret) {
-		pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
+		if (ret != -EAFNOSUPPORT)
+			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
 		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
 				  &ksmbd_socket);
 		if (ret) {


