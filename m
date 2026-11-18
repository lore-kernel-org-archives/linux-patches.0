Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057000;
	b=YxwNMtEA+lqIbh2XRfp7hfyHQWf6fr3P6TNXqguW3H7KADm+X4vqeCXIt1eDEEvllB26
	 Qndab69x5HWUgd49HuhBiKs2gMRWl37vAE4GE2W3JOZZqjDA3p4m/WVfiVBo4x07GA1hu
	 iq1sxhvQzGs++uBF52Qe3uzjPXuV92XjkY5HPcG808cSS5oR72DjRQjlAVRFAlCX04XvO
	 hY0TtC7NjWLdXUqy+w9h6fhbo8iN2Ncq0bOa7Et+PeqS03VpwL1GsH6K9d6on1x9TzU6P
	 zE3qFEmiXuu22Zun9ExxcZTDWT8f/qj/VqiNLS9rrB1V6+AJXMXaV1dSYAL8JZPwTBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4hCoRZfw2jZ5J58YTIyLjbAA96kg6crHUuYkXuyuC5w=;
	b=MgKoPfpnkWAegBE0Jev4SJEfsudABhSGLHUaSacFhw4TBN0Zd2Qu3eM6YOWAWXlAdcPX
	 6s0rMVr3mZp5MuKCGIxyBeLztBt2Ozk/0ZTWyzuR5YmGBAOJyy7gwCHjLPnRqnF2hTDkM
	 GUVtWeGVQ2jPWl2C4DAz69bBWrs4bLy+v2ubyPsCBYLuIVQm3nEpPkwRtf+FRuVwQG830
	 jhuHLDC6NRFHtOu6xU2aDvyPJifTEM+uoKMhuZIeCEAKxag/DMuiEaquAxy8GsorK4tBZ
	 +0FkrkS5NGIsbaURvhZ2QY2P/xbQ2grfa4lAUeb318iDSZwXHWz1fWmP9FnDaBkDeEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JFJZdgH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC52606A31C;
	Thu, 19 Nov 2026 02:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFJZdgH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DFF1F000C4;
	Thu, 19 Nov 2026 02:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057000;
	bh=4hCoRZfw2jZ5J58YTIyLjbAA96kg6crHUuYkXuyuC5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFJZdgH/bcrN50WZpXMnbCuIFWg8eN6v5//2Kpz8ChEQLYLklmYZ1vCH+7Y5PFBvM
	 n0V/Mm5MKawClG1jLXIFNxr9knBkzm34YUxP+ZcftFlRe1GsG0fYiYC2Ix2DqWNBRS
	 EUj7qRxljbD2SgUfOjGom/dY2W/nYRuS7UqgSnSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2188/2214] apparmor: Fix namespace reference leak in __aa_find_or_create_ns()
Date: Wed, 18 Nov 2026 16:04:24 +0100
Message-ID: <20261118150137.863786884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bb952451205e1..c32e008dc5b83 100644
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -291,10 +291,12 @@ struct aa_ns *__aa_find_or_create_ns(struct aa_ns *parent, const char *name,
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



