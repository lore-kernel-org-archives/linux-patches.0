Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156543783D4;
	Tue, 21 Jul 2026 19:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662720; cv=none; b=k6699XTxWir2uDUhik2mc7Z5+ZrTcRXTyAMGk0tKLPkhPnFAj9wgczeOiuqYXTO+9PDEvdo1np5+Kys9u5mCBgJuuaFtXqbb5lPvlUJ6oP0Z4uRlOzCjLxmUkN9qI23NdLw5667d/ACfQcI5W2FErloQJP7HilvZ/Le77RiHM/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662720; c=relaxed/simple;
	bh=hHIYV7OZj7xT7IvvDXqA3qyjgBfBreoqTJRjcD3YMAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGJASCJQ1MDRhaa8IWkpeWb+O5ASAEZYC0kprTvjj9rjuyir/c3JmdTjeD0hicBA+Xr9ADKtZLfodImg3IgpmQJZ/m51Bjx/tjyOis3purvfDaoQO5SZajgFMuEVCiCrSe7iznTYdtvlILHaqrSp+YdmMN/bMhnVB6R2yufjRRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8BMUGkd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8BMUGkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768DE1F000E9;
	Tue, 21 Jul 2026 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662719;
	bh=fClHvS8QFxc9PCDCOEjYt1/Njyif4nJZv8qHQ1adJCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8BMUGkde+Iuy0I7A8Z3w49ffVHd9/xQcibp+SxI4JIjKI1mE/c9XQ/DZwlWRLbeF
	 nsdpgPK6TdpzDnCposeJ9mCuJEd38z2t1knEzDRDW7V8LWBpASd++QrdMiQP8GdFLF
	 +ZIe1w0CocMn/umZT/b+dJ9L1IgAP1W/o6qaocps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0549/1276] apparmor: fix label can not be immediately before a declaration
Date: Tue, 21 Jul 2026 17:16:32 +0200
Message-ID: <20260721152458.408377026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 5e359cddd109e7..da39bd937c2a4d 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1342,9 +1342,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



