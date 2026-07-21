Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576F0395D8E;
	Tue, 21 Jul 2026 19:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660778; cv=none; b=NM6I5+G5ip7ArJNsQDUsrpiSuqgjYXS9yqkAz+bwx/LOGp828BM/cB14Up7S0AbXnZeoCR8ZT5mkGNv/z0rHdz85KV2KDbdZfPOD1q8oOwoLqRsptH/SPiFWOSF4qigRcMHMZS7K/puMI+1xJVWjV08z0JS/mpzJm4oYOIHFr9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660778; c=relaxed/simple;
	bh=JRk/q2amDYFeix0ID9BnVGprnjzcRwe1qG40DkG17X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvZDNXnnD+0SELkjoowvAOfftOYv8W/nLGq11A67gjzj6r/MAzdu+n6UDVwrPKBQVqWB1n/ICoN31rMMrKJaiJK1vADHEnjdTxH9etmCgdIcU1mPf8focZR9lpUOpA2XwT5ajbC+57vFClRUkxLOR/7a6nArVk/N22emEqeFjNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+m7DqAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+m7DqAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DFB1F000E9;
	Tue, 21 Jul 2026 19:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660777;
	bh=djRjTo5yQ4wCBEYE8dmJ25D8CBkdNfqdCNF1tspfFKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+m7DqAn8QJuXJkm8WlprKzs3h9WghliClKUZTFulfaNwc2BFkitdCOP/h666YQVh
	 2LQRFBujl6tfbXxvl5CV5tXy9iOhaybJ0mY40lCDZMwViJdrzMzAhM6F+/S5sYE0S1
	 yGu/TCClGJR+cELzlcBADSVfmPLcTkqYji34qs1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1065/2077] apparmor: fix label can not be immediately before a declaration
Date: Tue, 21 Jul 2026 17:12:18 +0200
Message-ID: <20260721152617.939278659@linuxfoundation.org>
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
index 73101ddf0b8715..567f6a1c2d659d 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1390,9 +1390,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



