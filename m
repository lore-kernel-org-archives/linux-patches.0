Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA80F1CAA6D;
	Tue, 21 Jul 2026 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657458; cv=none; b=IymjwoCzQZkXijo+7vkIqb/AojfW+fWGfNEN6AqSi3CQnn6Cpq4a6PBxlJ86ds31xojFNCggVPuQIQJNM0NCclDIKEYOxt0xPZ9dqAAgbQNIqIy+YVpIsywfOTcnR7Wwk8tRMrW1KrYYVcxegIW8LQtFV6b22EM0zW0tMQ6DsrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657458; c=relaxed/simple;
	bh=HwK6Ar1zDEy0yBK2ISOCTvScXiRUyilB758m/0Z1cnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuzikqjHtZrznxntzf+uLSUEqjaBV46GCkpyDhWkxE2/vlLXkAwAWfi3CTDzr8BPFB+qQXTiwOdcnG61chdPWmBpIjnLIRPltoABAykeiC4E0hRDhPCgUgqqyz83nbjTqx9Z4aabzHGnP/NalM95tPW3CoBQp7ysgovVViegvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjtYbqtN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjtYbqtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7651F000E9;
	Tue, 21 Jul 2026 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657457;
	bh=dHeMx7WOMVC9CF/xFhmkkqEqD/gFW8bkrjQxMqbnU8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjtYbqtNw7aBoY63ZsfEFnZ7lW+Q8oVwjWG1OF1wxWGBcoPIwBLwrR56uphweW1jz
	 14vbzaxdRjfyEevwq/Fe4Ahiulg9B3tnJujW2/2UrmJcrxc6gtTdy67dSlxqHfIrEY
	 howRDuX+vaai8AspeTqUp2QRk4f4BU4hgGsAe2mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0745/1611] apparmor: fail policy unpack on accept2 allocation failure
Date: Tue, 21 Jul 2026 17:14:21 +0200
Message-ID: <20260721152532.131859359@linuxfoundation.org>
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
index 3ae58f476c0817..1e1792d3ff5a46 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -813,7 +813,8 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 		pdb->dfa->tables[YYTD_ID_ACCEPT2] = kvzalloc(tsize, GFP_KERNEL);
 		if (!pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
 			*info = "failed to alloc dfa flags table";
-			goto out;
+			error = -ENOMEM;
+			goto fail;
 		}
 		pdb->dfa->tables[YYTD_ID_ACCEPT2]->td_lolen = noents;
 		pdb->dfa->tables[YYTD_ID_ACCEPT2]->td_flags = tdflags;
@@ -837,7 +838,6 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 	 * - move free of unneeded trans table here, has to be done
 	 *   after perm mapping.
 	 */
-out:
 	*policy = pdb;
 	return 0;
 
-- 
2.53.0



