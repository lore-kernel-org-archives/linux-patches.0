Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC50932D43C;
	Sat, 12 Sep 2026 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221511; cv=none; b=rR5tURofEetsoncqCTu3QGMfFlj1TzIEctd0qocTAE67hXouAEG7l+gMe/ifMpafo9Izdu2z6FFDbWcT7oxnblPiPvmXQU4FdHj5DwFJ8poHo6msYQictZjROqwRoLunZVmgiWfAi+IvLkO98Ahe8AFWTL+hEvVW1ESyOfciAUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221511; c=relaxed/simple;
	bh=Zy0rENGOc6aOe3MC8GVIWCEc6YBEVB2ipsrBplU65rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY7i9wD/1H9hfOij8xdKNiqZKlZK5ZEIz/vBVVlDo67vgiEzixArcBozvPWFUBZerY+4cHxqB56Oe7Ti9v/IAtw+DWrRlq/IVH2yL4zMtLESZv7YcjvzSDwvS2x1T5lANrmhJCpDZ6gUo45VMJA6Rg6ZPllNlrDtAmhtgmkGB48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJJ88A3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJJ88A3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962351F000FF;
	Sat, 12 Sep 2026 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221509;
	bh=KWh7WDJuRHKo1Lruqh6yg/Gtv8UL8wPGZU0bYl3i3eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJJ88A3t7U+SeW76XXw++8Edc15iRRrpRuIEoiu8D34UV6eFtd+L1Y7xe62KKQ6Wl
	 IWuLiqxCO/dbxyGsJVWu/aBX5Ldu08luBL/ndDUFqKNQoNIVNnMi0swWpIVmkPTNlb
	 Waz3Fodr6ROzIYI+Z92eTHNXKhTrgYg8kUiwTmK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0344/1424] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Sat, 12 Sep 2026 08:46:16 +0200
Message-ID: <20260912065614.990559727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 05fb6ac98c49be870c5f9ccdfdf95f0107e564ae upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme directories by adding kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-4-sj@kernel.org
Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1402,6 +1402,7 @@ void damon_sysfs_schemes_rm_dirs(struct
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
@@ -1439,13 +1440,15 @@ static int damon_sysfs_schemes_add_dirs(
 			goto out;
 		err = damon_sysfs_scheme_add_dirs(scheme);
 		if (err)
-			goto out;
+			goto del_out;
 
 		schemes_arr[i] = scheme;
 		schemes->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&scheme->kobj);
 out:
 	damon_sysfs_schemes_rm_dirs(schemes);
 	kobject_put(&scheme->kobj);


