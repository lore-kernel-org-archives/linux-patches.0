Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022297;
	b=icqT0n+i+vZNourbo4dAeGpF7yOzXicRNHuaTPDjbeiQQyEGmzJRvcKuhv0TFQHQu4/L
	 yQDdXPm4jOvRDj8ehLcT1mE/ESFQtbEbJupfhwazyKotDdPDFOXGqfEwNanpwObekqhyx
	 +IKsWBfmBYC1rmbTqCtUQJ4JY0jjeWxSK9pCRaxtLsNQHq6P2M8IVkMZ1qlPfkIi55xE9
	 Aqlv8WEZqJCzLL6WIee6mpkCbYHepaYJWyQJmhtC+PblkCkUCgQhUF+ECoJbUO6qsSVL5
	 JcZbcv27rf2EPMpFBeCl4/pbAXB4gpB8Iz/8MaoX35c9DQO1OvS2Xio2ls8q7Q7P8uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ppaLjOXDdkIyCfaZ57lSI5sD4zQHf8TKBVVtuien+Uk=;
	b=gjLPwF7tmeWcqpVj7iRN19hBv/Lyr/rOadODkokFUNe5iqPP+80IDfAt0NhUQVYadQGH
	 rYoGAujvbf4DrlAs3SArqWP34anL/weyM6IHYl4GSqZLiLhRUrhBycI0dd2VI0FYy1ldf
	 t6dNu/NQiyY/2v25CUXW3oZx1wz2RlnD+Ls6N5R/hi8kqrcWAYLQGbT38H2001xf7Ajxd
	 mDuOOWpwgIqC2xaYVVQSRYb8xa6pVummF9bnN/hykKFj74bsbGS2rnOTsKrGkoEwZTGyr
	 iOmC5MpXbH307AfUtUQw5WYepa0PlcJ/696D6mz898wIl+c0J3hUYAs6Csf3xbsX5Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvyOaYoO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82FD606A31C;
	Wed, 18 Nov 2026 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvyOaYoO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033A91F000C4;
	Wed, 18 Nov 2026 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022297;
	bh=ppaLjOXDdkIyCfaZ57lSI5sD4zQHf8TKBVVtuien+Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvyOaYoOTNDOiOkQ4U1u/HWQhVYM0wLaY6a9zESmCInkPQW6M+tmUfSIWbEVX0I8h
	 5CZdC6WyTc6BymOhyPhOG7hEbTPXJPAuipp4wMQOUAlnwChg+QAsyx1QMSFbmzyfiD
	 slEkTR6vVHWlIxEFOdIWJrui7lvPmK1QQMa03i8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2611/2651] apparmor: Fix namespace reference leak in __aa_find_or_create_ns()
Date: Wed, 18 Nov 2026 16:04:11 +0100
Message-ID: <20261118150418.246045026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 8f1f7f664c1822af34c5465f9820b4e39146786b ]

When the namespace already exists, the reference taken by aa_get_ns() is
overwritten with ERR_PTR(-EEXIST) without being released. The caller in
apparmorfs.c clears ns on IS_ERR() and so cannot drop it either, leaking
the reference on raced mkdir of an existing namespace.

Release the reference before returning -EEXIST.

Fixes: 73688d1ed0b8 ("apparmor: refactor prepare_ns() and make usable from different views")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_ns.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy_ns.c b/security/apparmor/policy_ns.c
index ae9168c1a85e7..7d5c768493e88 100644
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -265,10 +265,12 @@ struct aa_ns *__aa_find_or_create_ns(struct aa_ns *parent, const char *name,
 	/* try and find the specified ns */
 	/* released by caller */
 	ns = aa_get_ns(__aa_find_ns(&parent->sub_ns, name));
-	if (!ns)
+	if (!ns) {
 		ns = __aa_create_ns(parent, name, dir);
-	else
+	} else {
+		aa_put_ns(ns);
 		ns = ERR_PTR(-EEXIST);
+	}
 
 	/* return ref */
 	return ns;
-- 
2.53.0



