Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC56221F14;
	Tue, 17 Jun 2025 16:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179274; cv=none; b=sJnLs4Wwo2MlUr/s1o/txjvAYzdIv5/ViatbYXndAQknsilBXVnad1bc6F+9gBSbfLdRnImz5oNnD77QDzFDbRpQtBstYW8DsWnJfJCaRbh6smtsytf1eERlFCZYwaRiqdMwHqszJQtq76o3CmZZ4gNvVOSLlAe8iTzsCg8wzxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179274; c=relaxed/simple;
	bh=i5L2lCCUos5cjimQZHehqJ0Z+YkL2JjQl5Yq4Gul5UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpup32ET7HC8b5FFt7HGOZ0K+XDJ6+Fv7qC5n/mFXDJaEji+e0mKnO97wLJ0zEV7aAIrmcsBBN9lnhB8NgAZ9MHg9a/DD416uIoHVKYgzTjMBsXqe4GinzWDigU0yuXMSMadJ1mRQqxNikJ67RF6sluHt1jjEzifWoj2XgNZUiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVWElEea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVWElEea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C3BC4CEE3;
	Tue, 17 Jun 2025 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179274;
	bh=i5L2lCCUos5cjimQZHehqJ0Z+YkL2JjQl5Yq4Gul5UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVWElEeaX4WjfzZZrA9rR1O35lZgRrYQcmhOdpt/YOn4foq+5U+fTlZicBvkZCsmg
	 zz6HiwvTQjZRY9YRXhPblY7PVuzM1vdDt7D5ciYIs5oAuK6OkwSVUwJ/IOyURelozJ
	 ODHY37uNCeuGlXzN8gA37AHkYPmWSIRurgolNp1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Michal Luczaj <mhal@rbox.co>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 700/780] net: Fix TOCTOU issue in sk_is_readable()
Date: Tue, 17 Jun 2025 17:26:48 +0200
Message-ID: <20250617152520.000913353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 2660a544fdc0940bba15f70508a46cf9a6491230 ]

sk->sk_prot->sock_is_readable is a valid function pointer when sk resides
in a sockmap. After the last sk_psock_put() (which usually happens when
socket is removed from sockmap), sk->sk_prot gets restored and
sk->sk_prot->sock_is_readable becomes NULL.

This makes sk_is_readable() racy, if the value of sk->sk_prot is reloaded
after the initial check. Which in turn may lead to a null pointer
dereference.

Ensure the function pointer does not turn NULL after the check.

Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250609-skisreadable-toctou-v1-1-d0dfb2d62c37@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 694f954258d43..99470c6d24de8 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2978,8 +2978,11 @@ int sock_ioctl_inout(struct sock *sk, unsigned int cmd,
 int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
 static inline bool sk_is_readable(struct sock *sk)
 {
-	if (sk->sk_prot->sock_is_readable)
-		return sk->sk_prot->sock_is_readable(sk);
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	if (prot->sock_is_readable)
+		return prot->sock_is_readable(sk);
+
 	return false;
 }
 #endif	/* _SOCK_H */
-- 
2.39.5



