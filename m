Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033332;
	b=TjmlAZ6g0OCiXkHlCR0Ahj14kLGCN1uBBkCR5l23qNjyqwsdFfagZ2HuXg50f8ts3+Pn
	 hAI2KwaoBIt1V2E0HDfdTzg6q/FfEKYNsI3+dfMEmFATA9wphPwFjqdYu5Vfcx9c8F1kS
	 eGIGnGDHAesIcgWj729hqLL+dLmz2fKhI8haPrC5LlLF2BQeYsyraJ3KiYiLcmkfXCGhI
	 eafyHXJF805z+7uClCDG62lofLF61sdOhLfV3b9GvbDUvghq79rJ8hy9eF+VKhpupnCtR
	 apsGOH1OQud5Lo+rfmbQ7+wjVkaGZUPmj/dTX2nT79lyZtf4pxtGEmuBSq+Ln7S/rlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hTHV4U179/1+liHVti+uyZVyoyy45S+eUDEQT6/Od10=;
	b=Pki05hFU0jnwnb0LDzuuxzs0lETu2SfaYHtoOk3Waz5lnubux5cIj5Q/CWrgV30ejk9u
	 KH1nErKQ0gdmtzfvO0ovafKV9/EtvwREaO+Cfo5g5ACRFY43hTG95QM8KLjXCP0mvrul4
	 LOeXXqsYnRzaSSsMLOI+ASxwd4Uuk7/Y5mNPSeoBfnAUmER8DSw56ciEJGpvIr3MONKbp
	 arW3CfiRnneddW9RXqsdDeehaY94T0dhZs2aVmJiU1Pha4OmNjWgqMQNUh59vCq0gR4ZK
	 YoxKJHP3XZVaS0voGox8rMpKmKbkskV/fFSkQmKsYxWFXY/nW8HwjWqPpJYA8QFSQnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqntuPyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A8C606A320;
	Wed, 18 Nov 2026 20:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqntuPyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E021F000C5;
	Wed, 18 Nov 2026 20:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033331;
	bh=hTHV4U179/1+liHVti+uyZVyoyy45S+eUDEQT6/Od10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqntuPyORqkVC8J6b48QdvykY4cTzIp/qwCybeRQ9lW96hLDe8pvrRl4ZyiXPEKaB
	 yrD83A2GbJ1k6/gWGesvlWBOpcOxeXeMR3kTNSxlH+ZzxtyMqTOPyfvzeKWK+x0pDe
	 8s0f4LOu52ioY2/grk7fWc/zALFQWW+9ZUHFASuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1694/1756] apparmor: Fix namespace reference leak in __aa_find_or_create_ns()
Date: Wed, 18 Nov 2026 16:03:41 +0100
Message-ID: <20261118150117.102402141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 96f49a73d681a..a6c222a6778b9 100644
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



