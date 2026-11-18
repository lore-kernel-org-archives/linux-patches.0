Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062285;
	b=Ue4IXoYMWiix/o6zt2XAMJOAAxYBOxRVyBNec8knqKA9OMqkDg/Fv7taYLPN3nvNOiMB
	 6Eaka2XD/LEbqQVm3/5FZ6PRXw7QknVPDWcR4cAtK1R24gSVVQ/JU0kBDAgEo0709A0KF
	 eP8Ma6fVlgkCXGXT2fLzUinP65w4RV6p0Kr9sFPj+V3ugN8SnxnBkTx97QjA7+2TTFTDh
	 og4GoqbGc5Tw8hivXGGd/NMo1PSl0XD2iLiXV4j9Mdj15/uAh5yvQEDjYDcQDlnWHD8yO
	 KZYYf05Wt9sYm2DpfOAFtWJxwIXXYP9QSTaYb0yelONKjvwcp/9Fmjhm8TMSSWNfnQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gUKqJFgVhFibLoyM0+uwD02unrSdCKOWXrij1LX3wpU=;
	b=nhuHA8oyK5QtlWV2KxEiMzyUkMkeobcBrrPt3EBmOTljkKOE/tY+e+Fhy9ejTiVmh0PF
	 tTA7QGUWxUw7PyAtIayIbkx8mT9CN+a4qooSGowCRUacPNYIf+LUrNnlFAJp3Bq5cmXrO
	 9/KCubOIrJ4gKra0UQTh+rC2gI9CoaoYP4o/Cmtx1/SSiIdxzeIt4+QNhS7Jlq9HddyT2
	 JxnR/6U1DzrlOzVSgnDgmGfyR3qaZLXcJ+aVgdR/Sbj8hQtiZpT59bzAnPvZdMSwin66H
	 ma/UmSZiyS9vvCrW3hoFgcBX2Y/JT/uU872nq8hS/nJ15eA+M/YI+a+RtuzBL+dkDHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBF2P0f2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A1B606A32A;
	Thu, 19 Nov 2026 04:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBF2P0f2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1586E1F000C4;
	Thu, 19 Nov 2026 04:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062285;
	bh=gUKqJFgVhFibLoyM0+uwD02unrSdCKOWXrij1LX3wpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBF2P0f2JsUdQ2UN0VvaOKBB6vwad/MWB95HLTxjbHN2PYLQW0HmCzSYW9O5LJ1hJ
	 1+KYHmJMl2/dqoFtASfdw9dCEDZuqTCpkhhu/vEQXgNRRtN9SCSprhu3vB9iBk1+oc
	 LqXqr+2o78h+/GaiYrF3h2rI82VwuanofyqxPrMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1817/1848] apparmor: Fix namespace reference leak in __aa_find_or_create_ns()
Date: Wed, 18 Nov 2026 16:04:15 +0100
Message-ID: <20261118150035.587326939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



