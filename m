Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD4E39150B;
	Sat, 12 Sep 2026 19:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243190; cv=none; b=B80ViLVNPB356oCslQk86OOjfAq9YxuQBI6iw+eT9Alb5mylQiDrQuGM9MBmjrM3u6q31rW/2qjR8oXueP6DoMLsvrBjGtbljQqMnpgFa3GJ6AvQiDzCN7UyjF693k7ZuOI4/TyBNdjzSpXEQooni/bFrAfscKa5KjP2L9r/xWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243190; c=relaxed/simple;
	bh=7dKvDyn/nUiOhH4uOI35RCBG4Dbv/jYGGbOwGiKEDSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsM5jzBgj7MtGii7Pwg6lpXgI6hQoH5hRwK47ZYw0Ldi6t+5A7QGUA/mNM257Mq+9GOe7IK761Hbzrj6p0KDZI0we7gYW7OJUo573M8h/UKmdaMRZZLuAQZIX1FwdgxwNWjUzAnUSqxLV5BgbPYxNTX59+CWOOD0VeqoS2XhoAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a06NHRcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a06NHRcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CA01F000FF;
	Sat, 12 Sep 2026 19:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243188;
	bh=EnE8j9ZrUkDD9/7048PjpwCDvOLj9cONV2JcuKS6isI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a06NHRcA8Ys3qlXoyQDavSKtUwky0ApZjjtm+MNJRubirrR1qxdX2E99cVx4J3hWw
	 5BHCzCjjt0eoeHI254CXgfYTSCYEK8C8hHUq3qRnSXH8xGGC2ujKoal79nE5wdSbQZ
	 yD6cGb+9VV7+3eYS1kSWl0t+DPW0nC+/m2ZEYagQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 668/798] nfc: llcp: avoid userspace overflow on invalid optlen
Date: Sat, 12 Sep 2026 09:04:56 +0200
Message-ID: <20260912065532.415735198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 99985bfa8336fadcc69190ba2dcbd5386af3d661 ]

nfc_llcp_getsockopt() casts optval to (u32 __user *) for put_user(), so
the kernel always stores 4 bytes regardless of the caller-supplied
optlen. The existing min_t(u32, len, sizeof(u32)) only clamps the length
reported back to userspace; it does not constrain the store. A call with
optlen < 4 therefore writes past the user buffer, violating the
getsockopt(2) contract for all five supported optnames.

Reject any call with optlen < sizeof(u32) up front. 'len' is int, so a
plain size comparison would promote a negative optlen to size_t and slip
past the check; an explicit 'len < 0' test is added first to catch
negative values before the size compare.

Fixes: 26fd76cab2e6 ("NFC: llcp: Implement socket options")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260521-fix_llc-v2-1-ab44cc09179c@debian.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 57dea580c0291..0ba5ffe0ce6d1 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -314,6 +314,12 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
+	if (len < 0)
+		return -EINVAL;
+
+	if (len < sizeof(u32))
+		return -EINVAL;
+
 	local = llcp_sock->local;
 	if (!local)
 		return -ENODEV;
-- 
2.53.0



