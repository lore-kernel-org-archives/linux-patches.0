Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0924C399036;
	Tue, 21 Jul 2026 19:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660616; cv=none; b=sQhvfg1H41MQFvsRHm0xV/Hif/TYOg2Pe6+w+R90CzaBYXRq80kY9Pdb3lxUQ42RfztOm+2hY2XQ7S58He1SRupgFYOojsd30USBsDg2wcIQgEJO2zdxUe4Ps6wpiVBsUaHglEu/+N92KjNQtYM846nehiB2HVmgZmlxVGNjLRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660616; c=relaxed/simple;
	bh=3ad4KO6dwWSqkSUJsaAhANkPTPBApxI7ApSMNlMTcO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYSDDTVwnvdvkfISPqDqotSR14KUzD4bKiFt1nn1xK1k3GZu719t4jwI/tLCtaRUSpgBujzg3mJnppgwNOd++OJcILgW8zLyTyv75+DYPwfUuIHxPxesIuQnazf04h4JAAVbjQCw1GAj9HG9cAgce7lewwfW2GghKJ3XWgfH/fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml/8vX+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml/8vX+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6831F00A3A;
	Tue, 21 Jul 2026 19:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660613;
	bh=wujbkM1+PAm/P9LTrVt/HD1TmvXw2mK47J6Vyu1o35Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ml/8vX+bGQnBW5FMSjcyqBfoUUAyhqXN5zj1IHAq4ZwCA/2GgSNEDEZgPHO1i+Okk
	 j1FUfxkzZ0hlIV2aKZviUxw4xwimwQhwZ6NvUhphw+qxzYe7t6A3WRsbPhKalUP/Qw
	 pNqERSmMrqrAdOXHIBt380BiOTTzqMfAVWXKjprs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Manuel Diewald <manuel.diewald@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1045/2077] apparmor: fix NULL pointer dereference in unpack_pdb
Date: Tue, 21 Jul 2026 17:11:58 +0200
Message-ID: <20260721152617.459960804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit 7681ca43d2b1c776e62fe77e3167835fb1ab8319 ]

pdb->dfa could be NULL if unpack_dfa fails, causing a NULL pointer
dereference.

Fixes: 2e12c5f06017 ("apparmor: add additional flags to extended permission.")
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Manuel Diewald <manuel.diewald@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 9f45d5513d2ca4..3643c058d6f892 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1045,7 +1045,7 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 	}
 
 	/* accept2 is in some cases being allocated, even with perms */
-	if (pdb->perms && !pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
+	if (pdb->dfa && pdb->perms && !pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
 		/* add dfa flags table missing in v2 */
 		u32 noents = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_lolen;
 		u16 tdflags = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_flags;
-- 
2.53.0



