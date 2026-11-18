Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028303;
	b=4QAAew5ujLbgzHxZg8Ad3b3beuWc3Of+StPtVZkhFMKppSceyC7mmLoyHy9xrFtsd+mu
	 7qt8+0tt6i5H7nFSwu793rwCw1yL0ojwRC9hcnlgHZPxd67egJ6ozwZzM/YBCxVV/9R4r
	 UEg/LQSE3WjTkMBpAgAj+mA+BN3OIfasmBHIKvkcWEipUtaH+3Vp2MgUi9zSqvwIHe2QA
	 Umz+63RRd4qRzO3EOeUhDyEkuYoyzP2EceC/jnnpXVeICCRu1KxDP1MQIEcjq8MJ3NSve
	 qdmcapO+iFe1EmyWCD0v1x3NE5Eb30LZ5nWa8MWLQER5MIztuByR7dLSlt7JDTHS8zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4BGi2ky54j55I+IaD2KfMY6umqck9Z2IyHFtHbvGoKg=;
	b=avgKa1L9JaMMAW86bsplyhsvaAYXNQ1fZ07SJ85qLu4UVWi/iYvWF+3XoYZthG8Q6l9g
	 zGp58Vaj2/D65bm9My9HY7WmRq876Qd/n3Q+emzi86NZknjDScRZtrqkx22wMbHYRSRDw
	 rVeNbkx5azkSyLShxFx+pfDQ0x22+bAa1bUj+4+dI9Zkr5+gTP148ctiZBEPXeTHNzZOi
	 moiJqEv7WrxxP49Q2YM8PxhzJKEhIqNX6hf+0iuX7SLhjO68LwGHe7XnaVUBPk4ZwCk/Z
	 Ne1jLxDxWO3srPa/5RBcJEnZtI2JAWF8ORKTN1NWsYxAQ4wh+/8qRVLHOBcp13JJYPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ythsped5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225E360A2600;
	Wed, 18 Nov 2026 18:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ythsped5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7449E1F000C4;
	Wed, 18 Nov 2026 18:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028303;
	bh=4BGi2ky54j55I+IaD2KfMY6umqck9Z2IyHFtHbvGoKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ythsped5BD9HxS0AqDW11Z827GlSPDME9Z8N0UFFxMk9bTBMPEJvmsUfFXoZQycI1
	 wTQ9azW0ZNKrj+Q0pJwB63styGVl+eiWDP03ipLyPM7Gyl0zQE7uS0xcjLwPWi5BwE
	 3RLOtmeBK8n4+1Exr8wpBCErJ0mvGiyqhLQrE6G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2098/2151] apparmor: Fix namespace reference leak in __aa_find_or_create_ns()
Date: Wed, 18 Nov 2026 16:03:53 +0100
Message-ID: <20261118150238.122227897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0738e78f4d2f6..486b7d3f41f7e 100644
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



