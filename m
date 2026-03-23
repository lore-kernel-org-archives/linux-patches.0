Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F263B6370;
	Mon, 23 Mar 2026 15:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278204; cv=none; b=r1l3/oH/9HRBnbSVwkn6ZqnvGK/gzU4NfqAv3KZciKIZXprGi7Q8uO+EQYENDE5NFRoOFRBMywW23expu9BEWSg7ocqcUwlAUADdc9ZmxfREdoa9bpQPFDvTv37WhBNaH6CNk+ChomfQZH1EXbJoRfsEWc4H6dMpdnZdbBSKmY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278204; c=relaxed/simple;
	bh=+/Bdhsfnc2p5m0vzli10FdOgVxChApS/Si+THwUm8pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNPYoZ6Zo2zg1oYocOBCo+fnww1bdtIeWwl0fBS9nDy/JeZXTxpgfnYB8FpKSiDgzuQhrtnlMqxiCuFlDqZqblEDJUVyZa1tmDxDBdoAhCI99V+/mlILq0uaLVhH3j4FUCnQKk2BNmw0wawGtQcNbr/D+0tbsDq7LAIJE0/ytWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Wp0k6gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Wp0k6gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1F1C4CEF7;
	Mon, 23 Mar 2026 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278203;
	bh=+/Bdhsfnc2p5m0vzli10FdOgVxChApS/Si+THwUm8pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Wp0k6gs5RSwgOTnUHXHecJoUltHN1f7+ByG3c9mX1j22oy8lcG6f3yHCPxJ7NApF
	 Al19MZhI8ZZ+WvJurNQxXQ9K++gQl92pc9xhnPWD9n/y66e4FLBH2XU/mafbo0pH8Q
	 gCFLhRC6SjR/I2u3/vgXG86NczjZf53oPhoNNiJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.6 190/567] apparmor: fix: limit the number of levels of policy namespaces
Date: Mon, 23 Mar 2026 14:41:50 +0100
Message-ID: <20260323134538.554189184@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

commit 306039414932c80f8420695a24d4fe10c84ccfb2 upstream.

Currently the number of policy namespaces is not bounded relying on
the user namespace limit. However policy namespaces aren't strictly
tied to user namespaces and it is possible to create them and nest
them arbitrarily deep which can be used to exhaust system resource.

Hard cap policy namespaces to the same depth as user namespaces.

Fixes: c88d4c7b049e8 ("AppArmor: core policy routines")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/include/policy_ns.h |    2 ++
 security/apparmor/policy_ns.c         |    2 ++
 2 files changed, 4 insertions(+)

--- a/security/apparmor/include/policy_ns.h
+++ b/security/apparmor/include/policy_ns.h
@@ -18,6 +18,8 @@
 #include "label.h"
 #include "policy.h"
 
+/* Match max depth of user namespaces */
+#define MAX_NS_DEPTH 32
 
 /* struct aa_ns_acct - accounting of profiles in namespace
  * @max_size: maximum space allowed for all profiles in namespace
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -260,6 +260,8 @@ static struct aa_ns *__aa_create_ns(stru
 	AA_BUG(!name);
 	AA_BUG(!mutex_is_locked(&parent->lock));
 
+	if (parent->level > MAX_NS_DEPTH)
+		return ERR_PTR(-ENOSPC);
 	ns = alloc_ns(parent->base.hname, name);
 	if (!ns)
 		return ERR_PTR(-ENOMEM);


