Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447E336BCC0;
	Wed,  3 Dec 2025 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779490; cv=none; b=Tez63l/nl8hucG+XZX1Rcd78xOl/GNc1oShuluC1dntQ4oe23n8XwsVoss1voC5+GfjezsnMKV82epLJLJOVrCnhOXmPIvGeUE3sTL1ANNoWdSUG5Ysjvt5rFj8bIzAO4qamOpJ3fFTaaHdZBtHOrdjX4znEM2eMdRBks36CrME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779490; c=relaxed/simple;
	bh=ffQ6JKNL93DklYpV4DVYrXT9xOCVSt+Aa8kh0/fxK5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip9VcuRsHfgRc6xd+oXN3r8YCDTNtQ1m8K2Ieb5i3wSrPnwbKJmU1S+vpBeva1zvdfy11qUkVtnwhAT9jM91GXnw0VM1mFELBVfpvEqmYLg2RaQ7r+Ep/0XsfJ1yFXj57K8bMRVk54a3CM11kaydDxA66I0q3PtGVFFV4wJTmXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9IbZzqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9IbZzqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900E4C4CEF5;
	Wed,  3 Dec 2025 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779490;
	bh=ffQ6JKNL93DklYpV4DVYrXT9xOCVSt+Aa8kh0/fxK5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9IbZzqbrDd2FXKINNXyj4M/kcSfMKaEvIasJ022LZ+L7ym6lXTiTtk9Al5rXW9X/
	 8UXo6AVrjs4pyGv05nQB7QA/NJZEQCddVAvJaSHFaYV8yjw2nnery2ZLP/n1gjRFKA
	 VSozCo7ky4w+vR7uP4k69jABp3EKnq0jna+BTrEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 272/568] ksmbd: use sock_create_kern interface to create kernel socket
Date: Wed,  3 Dec 2025 16:24:34 +0100
Message-ID: <20251203152450.674477017@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f07b9e147fe2d..e0719b70c96f8 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -469,12 +469,13 @@ static int create_socket(struct interface *iface)
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



