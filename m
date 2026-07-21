Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7DA46D56F;
	Tue, 21 Jul 2026 18:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658727; cv=none; b=LBq5EzCRCpi6Cr5PltuqyuN7xMDQL6kZFCzVgr49nXGk9MYhnGqJAChUpUPC9Ox49gKTarahb5d5ecq0TghciUI5DBbVilLqeDOImAko45oaREgaCMU6+3AJEV8uTcs8D2nZNLYyd8TXXE19x8Dtm4ju9d2MUNP/v59iA+LbI/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658727; c=relaxed/simple;
	bh=0DLUp08GBYvHo6zxqlP+MWiBFdoVgVt9250q1hUbqLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAeKNfBl95PjheexJZjAdpTJcLuFgMu6buvW4vPzDncdoSKLMcVcmA3yp5eMFZWqVLdoEtIxIIXERoaqQMdBZlhOLXMRifxmioLVK/bF2cB+B6ZJbKt+X1VVfgEGlMT9tO49VEz/ZKOXBFwOKG5cZbCFjBwZXaul8uCBXdnNNUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItchQEUz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItchQEUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C858F1F000E9;
	Tue, 21 Jul 2026 18:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658726;
	bh=Y9C/RaHbE/X+ipUfbjKF34rbx5dDTWt5Is9MwaPPnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItchQEUzo/pdZoHFrUmPH7S+3/ERyZuwUUldrQYyqItWZedq1rLLI+ZrCLZcggrNR
	 Jt0SmLAHp4p/0lalzsAc/ERcJEolFzMSbo7CtecljzK62LnupcOL5uqRzu/u/RoGZp
	 ch1uYknjynwLLEEG/4kve05BITSGRRxSP8+PjLj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1250/1611] mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs()
Date: Tue, 21 Jul 2026 17:22:46 +0200
Message-ID: <20260721152543.560293708@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit d58fdbe37a829fd2e5803dd4e5a72992dd8c5368 upstream.

Patch series "mm/damon/sysfs-schemes: fix wrong directories put orders in
error paths".

Error paths of damon_sysfs_access_pattern_add_dirs() and
damon_sysfs_scheme_add_dirs() functions put references to directories in
wrong orders.  As a result, uninitialized memory dereference and/or
memory leak can happen.  Fix those.


This patch (of 2):

In access_pattern_add_dirs(), error handling path puts references starting
from setup failed directories.  If the failure happpened from the initial
allication in the setup functions, uninitialized memory dereference
happen.  The allocation failures will not commonly happen, but the
consequence is quite bad.  Fix the wrong reference put orders.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260618005650.83868-2-sj@kernel.org
Link: https://lore.kernel.org/20260617060005.86852-1-sj@kernel.org [1]
Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1615,22 +1615,19 @@ static int damon_sysfs_access_pattern_ad
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->sz, "sz");
 	if (err)
-		goto put_sz_out;
+		return err;
 
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->nr_accesses, "nr_accesses");
 	if (err)
-		goto put_nr_accesses_sz_out;
+		goto put_sz_out;
 
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->age, "age");
 	if (err)
-		goto put_age_nr_accesses_sz_out;
+		goto put_nr_accesses_sz_out;
 	return 0;
 
-put_age_nr_accesses_sz_out:
-	kobject_put(&access_pattern->age->kobj);
-	access_pattern->age = NULL;
 put_nr_accesses_sz_out:
 	kobject_put(&access_pattern->nr_accesses->kobj);
 	access_pattern->nr_accesses = NULL;


