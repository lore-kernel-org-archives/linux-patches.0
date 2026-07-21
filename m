Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4418A47125D;
	Tue, 21 Jul 2026 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657440; cv=none; b=X/pnM52IyQGLs4CPGdhurPFkbMFyd5fCKKOT3BHX5q25IQ5ezzVJWtX3ayzqMlqqAiFSu4iIUoe1DgaDNQ8NFfyu45yw1aVZCLo/rFROd+tKBiE8pZw/SgGKlms68wdpahYh3q9HU8QKx95oUsyzsTKyupPkdNW/2WVQMCBnS0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657440; c=relaxed/simple;
	bh=iHmQy3XHmAtbjSu3dWnkEjka7YA/XRiYwlWr0KOVXu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlWNrxNjUCPYxY5DPAKM1iIitDCESPbrd+VIbfCbVmB+MwoX0u2d6Bk2DYK0JZIgob/jZ/XXpmT23cOBQfRchHs0NBF3dTZwpT1SfyCFAIKvhXbqPopkJd5uFaUMpeJ9zhSH3VVeoFdjxWiudXHpZjLEmLzgIk2CuFbdGsDTLmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9XRrvFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9XRrvFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645361F000E9;
	Tue, 21 Jul 2026 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657438;
	bh=j774egyWZRPiuKEg67BJSfnIbnV5QLv0WKUxFe7oHWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9XRrvFOJ3nrAL2DKSi2pf9TQkGUyF8xg/MTfOAeD6jTtYehSESU4Q8N9ZH4DccDr
	 TG7sP7EN2PLw8BSdhtfzugoqJog3olpO/bcccgCPLs1uP+GZwGA9GJ+F+hjkdXpyt7
	 j0kAk/cniItpvFgSeFb4bExjmx+yghN/DVec43hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0765/1611] apparmor: fix label can not be immediately before a declaration
Date: Tue, 21 Jul 2026 17:14:41 +0200
Message-ID: <20260721152532.587583333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index f44cd6ac9b7b46..b0203b30db6069 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1373,9 +1373,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



