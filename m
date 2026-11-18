Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032596;
	b=Y7BeiiCfK9IuZyPCIDudSpbmCkskDGNbeyKSNZpGJpWRyiEPJHX4JcBwuUvmJb2QL6Oe
	 5lgfrLqB/ERRT3AvJUKklA279GmmhgVLj6z5e+nsCniXbRan+Hp6AG0TyehpjdYOGQYkn
	 dVCGukq0+m0d6nPCEbMb3OXqo3czvEntQY6J2i1YlRjkgFBzbMw13SoJe7K2Cx0v+kROv
	 zhM7LeIhjpwbAk16IKXi9TxN5rcSog3jJVtiBJul9zU87KoBW8+aUmrGncPHNhSR9vy+R
	 sU+QVEDr3vPjKwdNlzggPpSkn3WgXDohFBudDbBf6Vy/WNLrZPDeuxdkkchP0xMEuEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=21enTsgaYP8toFS/YzaMnNULAFeH45sVeMX0WQji1PM=;
	b=10rwDcY+0cKwetwqcoMHJwTSYkuSgcv1Y28z8/LVBv3zh0mKjpZXWjzUdnQfv/yKLQiD
	 NRh66R7bFHJOGFyurabvBxvijszy92DdPcWxb2mhTcZHRF1/fZNgAndOWjsCQeYOLwShl
	 +VH7ORd5uF/naFKiErVWs1iOwi+6sBDCCoWa8avZ6MDS2KptWMZDdqRG91UOUZGXRa3C6
	 53NKCnPyhlo/8uS4NemldDLr0/NDItWi2OtdqK857l8pcRdQzxgzsyyHAmhmomKhO9+wF
	 qzX0DTO3N0Q5yExmyniGplc63VYZLK7nGxrSj++yaqZFCtnQgNuqT2k2MwCXUg9Eatw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXWKUm5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096A2606A31C;
	Wed, 18 Nov 2026 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXWKUm5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A05F1F000C6;
	Wed, 18 Nov 2026 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032595;
	bh=21enTsgaYP8toFS/YzaMnNULAFeH45sVeMX0WQji1PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXWKUm5pLOf8Ey95mMuq7GbADzryLmKFMYKDGCZaxAA6Arpq1+TUSbBq0CPIS7f2+
	 sHV5Hn3jm64qd1rGwP5hLE6Wo0NdaQrevamlHO3BirEBtMjpHAdnJOrcJhIcS/EwXF
	 HWPoayBe+hZNmYIOud/5oCNrb78oiSI+NWqJbTvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1422/1756] ipe: fix enforcement audit
Date: Wed, 18 Nov 2026 15:59:09 +0100
Message-ID: <20261118150105.778076002@linuxfoundation.org>
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

From: Fan Wu <wufan@kernel.org>

[ Upstream commit 0e5f66bf052223aa5c8caeb8554a7577b54c302f ]

ipe_audit_enforce() starts an audit buffer but writes the state change
with audit_log(), which logs its own record. Ending the unused buffer
then emits an extra empty AUDIT_MAC_STATUS record.

Remove the unused buffer and log the state change with audit_log()
alone.

Fixes: a68916eaedcd ("ipe: add permissive toggle")
Assisted-by: LLM
Signed-off-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/ipe/audit.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index f05f0caa4850f..74089a7988eb0 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -275,18 +275,10 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
  */
 void ipe_audit_enforce(bool new_enforce, bool old_enforce)
 {
-	struct audit_buffer *ab;
-
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS);
-	if (!ab)
-		return;
-
 	audit_log(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS,
 		  "enforcing=%d old_enforcing=%d auid=%u ses=%u"
 		  " enabled=1 old-enabled=1 lsm=ipe res=1",
 		  new_enforce, old_enforce,
 		  from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		  audit_get_sessionid(current));
-
-	audit_log_end(ab);
 }
-- 
2.53.0



