Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE0C3B52FF;
	Tue, 21 Jul 2026 22:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671937; cv=none; b=jvu4hxhxLn1rIxkcLroJrqTQow3uuyLqye2AWN/10Vrhkoo9bg7nhGJj/FoQPX2X92RlR5fDTxGbVZ9blxPHzEkfbOOUKrgZxLKSaaTAn61TkWPqWi0I/qVGrGOxF2e1xWRAecBxyO9m9XnND4pAsOGJ42UnE4DJ5efrUvNcahY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671937; c=relaxed/simple;
	bh=O9LGcjtyzJegzQhlbGhOatJDmVzEf9No817w+TE199E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2idcJzMIpo5gD0WPbEGduv4KFGItcvhcaVxTp37czKjBaBl/qZQyCf20Rrla5Wl67iR71AEm6bALXSfT9ieuEnr9rY0I2Ob1zV27y6JLbtH9aPKpxrme6BysZREWHA6FadMV0QcwJ7l79JfUy4TH55SGhbLuRSeaoPoX/1Gttw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwqFa4m6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwqFa4m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CE31F000E9;
	Tue, 21 Jul 2026 22:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671936;
	bh=+o9BZFPen9o9nyqdN/KsO2Ew8v8xIsMpuScakRHn0qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwqFa4m6GcP2q52896wXcUkU2ZnUw+QymDyFEXT72MLyi36w7NYxCxB0+mdkyU0Pt
	 nVcSnlvEFsNpuJvkdZ+e3PiXXLhdNRLsdN/RK6mijEdovo+Nm27T9z//AVLbcwS+u+
	 9UBfTwEMcNAka0ai9+UJ5wu3KePjXP0tSA+hdoiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 434/843] apparmor: fix label can not be immediately before a declaration
Date: Tue, 21 Jul 2026 17:21:09 +0200
Message-ID: <20260721152415.796492206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


