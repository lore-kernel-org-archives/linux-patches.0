Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97D326E146;
	Tue, 11 Nov 2025 01:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824450; cv=none; b=pmQ6ovaj672R6Bl00Bgv2dzOm2PMkCO6BT7Dsna4Vkj84rUPil8MYz6ENbOjsXBHb/RsYprdgY+fDBlj69bo8JjFN4zRUJuCWLyvXhw/l3R+EBED4zJg70amdWicJ6GvHWnqoWroon3GX3diLJtBGsTuq9O9iNuINlJVt69ImY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824450; c=relaxed/simple;
	bh=4bNaVSR6Ph3EqGls69mPtMQIfTz9Zyyta11Daj0ZaH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwa8DjJRTLbcALw118yRfXF7lrB50bNFWtH8Lcs6C9fEcbHaY/p+tE+1IOVB+zW8fA6vLzsBW0daG/EFBtJ8fPIe9us96bpp22jpvoOxlBEMQLGsEXkk5bBk8C8wYu8H7TVjCG+otnzUmKG4iTe6+lv+oxJe8wXfBfmiLcLM2Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsPOlXHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsPOlXHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1EDC2BC86;
	Tue, 11 Nov 2025 01:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824450;
	bh=4bNaVSR6Ph3EqGls69mPtMQIfTz9Zyyta11Daj0ZaH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsPOlXHqvSXEWwXeAZaF92b1Fgu4cTQ9flfagQhzMKskpbLK2EYeeffthkr94kKWu
	 3m6axaqjgEru/BrH8LD+S895QJUK9JyUdCxCXqGX3en8OmeJeje/3xOWm7H2vZQsrv
	 OUoX08raFJriLiEyVKB+233RJ50J5JqMHm/0ovpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 448/565] ksmbd: use sock_create_kern interface to create kernel socket
Date: Tue, 11 Nov 2025 09:45:04 +0900
Message-ID: <20251111004536.967436847@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3677ca67b9791481af16d86e47c3c7d1f2442f95 ]

we should use sock_create_kern() if the socket resides in kernel space.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index b51ccc16abe11..169e3013e48b5 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -475,12 +475,13 @@ static int create_socket(struct interface *iface)
 	struct socket *ksmbd_socket;
 	bool ipv4 = false;
 
-	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
+	ret = sock_create_kern(current->nsproxy->net_ns, PF_INET6, SOCK_STREAM,
+			IPPROTO_TCP, &ksmbd_socket);
 	if (ret) {
 		if (ret != -EAFNOSUPPORT)
 			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
-		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
-				  &ksmbd_socket);
+		ret = sock_create_kern(current->nsproxy->net_ns, PF_INET,
+				SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
 		if (ret) {
 			pr_err("Can't create socket for ipv4: %d\n", ret);
 			goto out_clear;
-- 
2.51.0



