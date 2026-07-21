Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B28A2EBB8D;
	Tue, 21 Jul 2026 20:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666494; cv=none; b=WaAYxECSltpJwUVLEuQHjRtSlS9UuWhR+i9V4p1MVXEUq5MyCezmfRDnZ+sp/bP5cKKsgxUvINwySsYD6FfXigUEm1IaqpZxZK7u6EOreXlvEH+mK8Y4epD5coCy/ToqUQOGnsZBQXPX+qDzhVQTb98gYmB80wwmrxZuyd/V7Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666494; c=relaxed/simple;
	bh=CXCbWfxCQgxAucBVuWSlKDwBaaI3I/0fJvtYFe3hQOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7MR+OM0gRubrFgqidoqDGjYytCkPkPrvvfx2rY2g48UnmgLDdNaMWjrgk+F9s1SjcHD0wU5Xn1z+TJIbJelUCNLqhFBil69+ct2N5Hgr9Gqjo9yeXpKYwuh9KmyFV554GHhRXJfGiDjXGpitlDP5fuHtyYon2cu3+wOFb34gFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuTMrlAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuTMrlAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077521F000E9;
	Tue, 21 Jul 2026 20:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666493;
	bh=d2Sac2D6M48aVJH+bJx5cNd0AB1Cc8TEAP+nAwoi+qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuTMrlAmtFK1OEd5fgN/leXzAf8qkNiLGoVkl5Y3G/biEwcVfLEkwXn5qbw8Rq/3n
	 fUuFNCnMztgp2OumigsIMZzHVAbqX0zmFqN9QtQkUZh9Pnj0f45bdG+iLuA5AXymDC
	 1Fl33Acohcoa9xdI6dePAYzHtzTHOgpdvRkqwVlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0705/1266] apparmor: fix label can not be immediately before a declaration
Date: Tue, 21 Jul 2026 17:19:02 +0200
Message-ID: <20260721152457.637611016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 1ed40bd525c00d22af666016af9aef7167f8085f ]

Fix error reported by kernel test robot

security/apparmor/policy.c:1381:2: error: a label can only be part of
a statement and a declaration is not a statement

All errors (new ones prefixed by >>):

   security/apparmor/policy.c: In function 'aa_replace_profiles':
>> security/apparmor/policy.c:1381:2: error: a label can only be part
   of a statement and a declaration is not a statement
     ssize_t udata_sz = udata->size;
     ^~~~~

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606150525.npax8WiH-lkp@intel.com/
Fixes: 7b42f95813dc9 ("apparmor: fix potential UAF in aa_replace_profiles")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 14306cfb1ae48e..df76104e3b3382 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1324,9 +1324,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	mutex_unlock(&ns->lock);
 
 out:
+	aa_put_ns(ns);
+
 	ssize_t udata_sz = udata->size;
 
-	aa_put_ns(ns);
 	aa_put_profile_loaddata(udata);
 	kfree(ns_name);
 
-- 
2.53.0



