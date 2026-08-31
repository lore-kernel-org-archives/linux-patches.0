Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67D054B1D2;
	Mon, 31 Aug 2026 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184000; cv=none; b=DyNYXEdi2tjb7GAi9blmka3IPJQAMuiLb7UkTmzvR5coBEz9yMn5V2loyYuVKPNVENfcwfMfH/0gpUui3XnoYxCrL1pPVoMOuFb0szj5o5UAESQUrbQWTbQHhPmcX9pv3Ks0tAvAQqBXnWt83UMfHmOrdSi6XyEd/N/u3nZ8ESI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184000; c=relaxed/simple;
	bh=39wyUUn/71iTAQ993dsULwGOmsTKmqb+34/ouCushf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgVnNO9Bcp+hWJ52yCMeJVE16yOdT+fhtR+SRedBTREoh6drw/n9d1m4lZfusdxFLtBCti3OoaKCmWEesfGgrxA2ZNTKcLfStfZ7ESXUZWXUhM7Td+0yUEuwuKwOoRO3UmtaKUaZKRVCyaGhsGhFamep7AYWfVhR6ZAcbPg8y2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lM7l0k34; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lM7l0k34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2131F01559;
	Mon, 31 Aug 2026 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183996;
	bh=qRtoZOeOVHBiXBIeFwLJ1UQnCKM2HO0caOvQ6IxBs34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lM7l0k34iv37w2HsVrF3PRgHXOEA00XKaA4uPpxDvcYS3yOjIEmO+HXJuqTmXptTM
	 Tf9KlWWkNDIt1fq07ExiXFzsYLhkA72Ne0lQif9/NYkNZ9siBEAiMa5lusrgj5AGMq
	 Jj2OPVmqX5juU8+kD4kmpGBM8fo0BkeQTf/uQzJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 08/83] Revert "selinux: reject a permission value exceeding the class permission count"
Date: Mon, 31 Aug 2026 15:33:44 +0200
Message-ID: <20260831133359.606006020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

This reverts commit 9b46fba7528f58ca09eac67ec7d474ff1e9af066.

The stable pick applied the nprim bound after symtab_insert() because
the upstream context (the SEL_VEC_MAX check from commit 18fa21f10d00
"selinux: more strict policy parsing") does not exist in this tree.
On that error path perm_destroy() frees a key/datum pair that is
already linked into the symtab, leading to a double free when the
failed policydb is torn down.

Drop it here; it is re-applied later in this series in its upstream
form, after its strict-parsing prerequisite.

Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/policydb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index fdb8a62da04ad..69c19ef4b8817 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1168,9 +1168,6 @@ static int perm_read(struct policydb *p, struct symtab *s, struct policy_file *f
 	rc = symtab_insert(s, key, perdatum);
 	if (rc)
 		goto bad;
-	/* indexes an nprim-sized array in security_get_permissions() */
-	if (perdatum->value > s->nprim)
-		goto bad;
 
 	return 0;
 bad:
-- 
2.53.0



