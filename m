Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CAA401A2E;
	Thu, 12 Mar 2026 20:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345935; cv=none; b=mqtMDq7k4xikqIovRIfrCmLpQJCKTGUewN+spKYEAryoXx5THAgNlbJFWgmne5pnYYQYDxEp7Sg5Eu7dhIKuv+XZsigxY2gfhwsd4g++GXB6ygRBWhVpdFse4ijHwEoFCfdPeEBI+UN2LnnJ9t6gpIumzEiwmivp3z/aFIEVawE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345935; c=relaxed/simple;
	bh=Re2iPV+mD8QZeuwS7plxLOm1wDmskt0u/KEknBDDrkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek2Ghn6hbPrD/MCCs+4fzPs0Hn/Q2o7NpLFMCtgFAjzl3gQENt0EIANbzI8T+LbuZg7OZZ9alhi99KG5zthlZXm4of9sFk588T8ao5BJRQ+m/0F2IpcEgjHgHnOFmKb1f9uq8DrjPjtDBkbnAV0Y2lQ2Ff/EuwnPvQe9t6RCpbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNhReN0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNhReN0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B711EC2BC87;
	Thu, 12 Mar 2026 20:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345935;
	bh=Re2iPV+mD8QZeuwS7plxLOm1wDmskt0u/KEknBDDrkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNhReN0ZEblXdf38hdKdwsxnXxFhLVPHTOkRKSjJm/NR5LeT3/IWjo/XhWs8uFzy8
	 LNh0ynUxUJEoCZ4ipYna7lKWJrX9OWyYqT+YBLKvJ3q7fYCI7xgB5oi99bCC2BFwhu
	 LUMcEzypm7Bnssa4jrTA0GRnva6wVthC0EnkL5kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.18 06/13] apparmor: fix: limit the number of levels of policy namespaces
Date: Thu, 12 Mar 2026 21:03:47 +0100
Message-ID: <20260312200326.479881563@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
References: <20260312200326.246396673@linuxfoundation.org>
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
@@ -223,6 +223,8 @@ static struct aa_ns *__aa_create_ns(stru
 	AA_BUG(!name);
 	AA_BUG(!mutex_is_locked(&parent->lock));
 
+	if (parent->level > MAX_NS_DEPTH)
+		return ERR_PTR(-ENOSPC);
 	ns = alloc_ns(parent->base.hname, name);
 	if (!ns)
 		return ERR_PTR(-ENOMEM);


