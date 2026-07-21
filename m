Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843243AA4F9;
	Tue, 21 Jul 2026 22:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673886; cv=none; b=RsU6YvjxLIus64S14LT4yX2npe95MlcC9OMRaEpKtiMQQye30ZsvQGRCmIE1ZB6INZ3krCRGQagFEGbMtYKzwHKsdb7LP9or1OPSWJiMBDd2BczOuSrJM9QYkCi1eG8/2+BRcLejAmEWi+kdVlaG70oWW4QYkCoIU8LAPp0RHZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673886; c=relaxed/simple;
	bh=5YCM3sgnso3UhA+GhwioAi+7+TtNnI64GZFM6MI7Hqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPnpGomrcP5M5M4pivcvm4sBK1IIJpc5yv9rXrcEEdFZ7uMhe7h5dR7Alok29UxpIxEQaqLqBgAowI53iLC7XA0G3U8LfhBKrn+ONAbMUSGvtEvfvains3xH2LlKT/oU9EBRE3XplS7TKs9DbL8XI3TaEt9qdDzvKjBlvdxIJqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWTjqILx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWTjqILx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7B01F000E9;
	Tue, 21 Jul 2026 22:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673885;
	bh=P5bFx6b9yp4nMpj3fuLWHHsQ6cgLZGXSoZyGfMWrWfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWTjqILxs+MWV14DqAsBL1+V8R5SnoUjXgu6CUdA9+N3YO3Nl7UYzv27xZN8mTEFN
	 5N7dPd4EM/4fEj5TkyNO/KrzUqC5cR6ki73oxblkzC9TTPCV1Ps/oW6ajUfRhACZ5Q
	 kMzQDZZ0K+W0lkqpU6zqEBSeyWZ29FzDvb2X907w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/699] apparmor: fix label can not be immediately before a declaration
Date: Tue, 21 Jul 2026 17:21:31 +0200
Message-ID: <20260721152403.181400240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 security/apparmor/policy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1107,9 +1107,10 @@ ssize_t aa_replace_profiles(struct aa_ns
 	mutex_unlock(&ns->lock);
 
 out:
+	aa_put_ns(ns);
+
 	udata_sz = udata->size;
 
-	aa_put_ns(ns);
 	aa_put_profile_loaddata(udata);
 	kfree(ns_name);
 


