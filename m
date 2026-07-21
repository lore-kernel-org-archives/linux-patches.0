Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C389471246;
	Tue, 21 Jul 2026 19:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660622; cv=none; b=LZisXLzQTzye5DU0Y9AuT1hL9jHO3hKDfgE9C2o1NdU+iH4uf+ION0e1U6jenL90mWzj0fEHC3ucNhEEhQVZkC2Sqyovro4Ak1g+rhtDlsrG38I5r7fupFCLXAJnsN2fOZyms6+UHpi0VTFoj1iV3ItwctezIUauYCh8ZwFndJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660622; c=relaxed/simple;
	bh=BqU9C+ptD71KNfKn67gbDm0j8A2vKPXxNW3ut+B3sZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIxGhRi2HhkqPnVBlocECjAtThTio76SHExcKjDbiwjGl7QIRsjYtKZ1V3x7OR8WO5UfuvZLhySp/zf48D0/gToJyCdiaSbLkZTDIk4pKfLS5aTlm2g86mXQysl4x9WfbrNFbHmUJHkutZa+ID0I84n+1zEkT3o0elhEUFEVpQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNvGCshr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNvGCshr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E356B1F000E9;
	Tue, 21 Jul 2026 19:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660621;
	bh=G2/I8RaTeycPTD+TRJSofzKfXa9KSI0h3s6DK0Uzn9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNvGCshrjC2GTkWZrLtdTXUApNnBLbMW2TNLHlaA+pMUTOoggo2W1Fw4nTXW69j87
	 8ALYMsGi3hNekNfw41/Ew3JfBgniwrcuuqscA4GmkpZQwTP/PbKPjpVYwIAtImjEzc
	 bUrqihPNAjxckZb8mHBX4mqPYWMdxxDVLpJDeD1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1048/2077] apparmor: fail policy unpack on accept2 allocation failure
Date: Tue, 21 Jul 2026 17:12:01 +0200
Message-ID: <20260721152617.532164377@linuxfoundation.org>
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

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit 45cf568241048e560a81aa2053f06a62069f5640 ]

unpack_pdb() may need to allocate a missing ACCEPT2 table for older policy
data. If that allocation failed, it set an error message but jumped to the
success path, returning a policydb with the required table missing.

Return -ENOMEM through the normal failure path when the ACCEPT2 allocation
fails. Remove the now-unused out label.

Fixes: 2e12c5f06017 ("apparmor: add additional flags to extended permission.")
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 3643c058d6f892..d9dcff167c4801 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1054,7 +1054,8 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 		pdb->dfa->tables[YYTD_ID_ACCEPT2] = kvzalloc(tsize, GFP_KERNEL);
 		if (!pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
 			*info = "failed to alloc dfa flags table";
-			goto out;
+			error = -ENOMEM;
+			goto fail;
 		}
 		pdb->dfa->tables[YYTD_ID_ACCEPT2]->td_lolen = noents;
 		pdb->dfa->tables[YYTD_ID_ACCEPT2]->td_flags = tdflags;
@@ -1079,7 +1080,6 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 	 * - move free of unneeded trans table here, has to be done
 	 *   after perm mapping.
 	 */
-out:
 	*policy = pdb;
 	return 0;
 
-- 
2.53.0



