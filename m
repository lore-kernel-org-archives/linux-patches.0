Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050731;
	b=c88UR+TBJ/dWe9LPUVbAfIsSdaTUJiK/ZxyDiuiwjHrwclKnxzdrRSMwmmsYnHjRMN61
	 l2+0QpdLNXsxJLvjw+7J5LpiPhreOY/+ISL0SWgK3oexslolxGwhDBnuq6UPisnbnjvyM
	 Oh2lPlx+BJ1hi7nnzyMxVTv349j8ujxrQ7A+tZu5QCXLdkaBrJKFukMrT1PINESPwKQnn
	 /zKSKhUPtRUQFUJK6vz5Rq5dJQYyvLKy0srYr3zhW74OTGK1OS/l3CMgTPxi7nPpHeBR5
	 o/3LXx2IY8OR+Sxz5Q0IGLY0mBLAmc1BkTaQ2+pC94nj2ONkHAuhof082HFi3ySdrEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zWUPbsLhrBmRYEFv0bI4oFZ6jVwLZ7w+QXBPfIx/2XI=;
	b=iXQ861rPMWHlTfcj2v2XHbz81WPNRRf0+BQAOIEFGKm32uPywfGQ5PDIfpO++lP42zK2
	 lCzAbQUbugEoNzu3hJ768ScGJ1MNlF6ASpmL66tk6q5D8JQA9x3Uaw/8QmeGfWUNKG66a
	 3OlWx0pX1dJtdV/DLfSa0uaSdvRRXPkDlfutBXNNvmrHNcu1QGU6122coa9E7uutwoBVZ
	 mSC7K7ZU894NTImsGmGUtTgvFr1UFHS+YTqKAl7Jq1Wi1FOyhRKGf5SzL/tX2Q0C6RljJ
	 1T2BlFpD8EUvGvJ7Um9q8mz6u2Vs6EUKJY0RZj4dE8VWGlNFxHjhc9CjsvA8Avy5UYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yvwr2px;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01807606A320;
	Thu, 19 Nov 2026 01:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yvwr2px
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BE51F000C4;
	Thu, 19 Nov 2026 01:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050730;
	bh=zWUPbsLhrBmRYEFv0bI4oFZ6jVwLZ7w+QXBPfIx/2XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yvwr2pxUnpWLrLWjIPJJ2ihy/yXmikMvv1SQeTh2azlvsJHR2J3pjSOAtQrBLks/
	 UYWwXstMWxqtAmVITSfhYz6qK29yOlu9bfYH0rdM0vlL1GOpWUZAv5+zDDnD+PEGzz
	 3XwqTA+7jhxSo2aYaM1iMG5wdVl7Te7cWdLmjqKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2813/2857] apparmor: Fix namespace reference leak in __aa_find_or_create_ns()
Date: Wed, 18 Nov 2026 16:04:07 +0100
Message-ID: <20261118150342.888124742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a306b08cd75d2..602dfa9845b91 100644
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -304,10 +304,12 @@ struct aa_ns *__aa_find_or_create_ns(struct aa_ns *parent, const char *name,
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



