Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC3657AF75;
	Mon, 31 Aug 2026 13:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184166; cv=none; b=llOM82LPFrMlo5mBd4Uxl6havm65mNNQ19oQ+6NkS6y5ExXJ6phTSHUtEQPn5vFRhJVDcZD/zYFKsaHDuUYsv95K/txRzokY/J2KyLWRjdZ9IPeL1p09kKvB0PpPmBm64Fy4lq4J6Z+sNlwr2buW2F35yQmz3EZn2Cev1GgetZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184166; c=relaxed/simple;
	bh=S+HTG9e0iwevBJCeClYJ0i+PTauSpYlLEoKEPS5XFbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/2cULSimvW7AqZfPwlZBSOIId+Rga4gqrDOpu5vRCGnz2jkpkp5ehg8QnNGUCY6PhzBkKUlvWMb3nhOSpo+ZZwlUrLx+fvD+Nc20lLzHZdfA3hWLPRcLD4uBghJfDxaVOs4jfcENrrcglO9TRgyQ/peP6gANyCu0KM00ytRHt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb9LpcCd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb9LpcCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5971B1F00ACF;
	Mon, 31 Aug 2026 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184164;
	bh=3ilfF7iE5i4d1rNSjQRWf5dgQpLTyE2Cto53XFZWO7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xb9LpcCdmDGkHo663WQaYyAp7LJOAQOatUMkIfkVW6uiToNaRUsd54LCp22Zbyxf5
	 99ZBzVAMntX+uxaQoE/ywVx5fsiu/AhQiXuiI4vpKq7v1LPucdGV9Kk8tYAqEzhFOw
	 ikmcxQQ8rj6oC7OiXQZOZJpCwqsyuBZAXJ6sMTTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 13/99] selinux: reject a permission value exceeding the class permission count
Date: Mon, 31 Aug 2026 15:33:42 +0200
Message-ID: <20260831133400.495783091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit d14b5d0e97fccd27974fedc03b903408872907fd ]

perm_read() bounds a permission value by SEL_VEC_MAX but never by the
nprim of the owning class or common, which is taken verbatim from the
policy image.  security_get_permissions() then writes perms[value - 1]
into an nprim-sized kcalloc() array, so a class declaring fewer
permissions than its largest permission value drives an out-of-bounds
heap write.  The top-level symbol tables are validated this way; the
nested per-class permission table is not.

Reject a permission whose value exceeds nprim, which is already set when
perm_read() runs.  Well-formed policies are unaffected.

Cc: stable@vger.kernel.org
Fixes: 55fcf09b3fe4 ("selinux: add support for querying object classes and permissions from the running policy")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: tweak comment for line length]
Signed-off-by: Paul Moore <paul@paul-moore.com>
(cherry picked from commit d14b5d0e97fccd27974fedc03b903408872907fd)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/policydb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index f93b10ce19652..3dc6d3057a89a 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1148,6 +1148,9 @@ static int perm_read(struct policydb *p, struct symtab *s, struct policy_file *f
 	rc = -EINVAL;
 	if (perdatum->value < 1 || perdatum->value > SEL_VEC_MAX)
 		goto bad;
+	/* indexes an nprim-sized array in security_get_permissions() */
+	if (perdatum->value > s->nprim)
+		goto bad;
 
 	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
-- 
2.53.0



