Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825BA57D20E;
	Wed,  9 Sep 2026 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963369; cv=none; b=ZWttzXjpy/sMIR6+1rXmKTG0X45Ps7gpgYCCcvoYzIRiCRZZYTwqp/cO7WjtvfoJevJCgullFv2m9JnpbCtxD4bEnu9fQvLP8ol7YaKuaL8qHCuTDyoMUOYb2owhYYDZbtLew0At9xZM2SpSiEWhOBljgmn3D2y2Bt20l161J0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963369; c=relaxed/simple;
	bh=xgkkzlYKrDi2+lAqCUe5zDirwtX0C8X2vuPwRP6ql5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouRRUeEWmqd/+KNh3idDhi8rwrISVlGtEWVLspcxSYbWOGjXCxPx5eC0hQWEPpqRaZcWSA6WJZWNia5+yH1KXSet5KAqLioge8SzfUuhxtWqk/sbltzbuQOqFBym3f9Ji4EGWmdwJgCBt4dYbdbyGLLj+T5tA24Z2bHFIYkaJDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rx8il+1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rx8il+1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95211F00A3A;
	Wed,  9 Sep 2026 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963368;
	bh=4lO0z0+0FlsQ8D8yQdEdS3qyL1jLe3a2f44yalVFr3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rx8il+1Ya5Qjsi5sBzYFRjp3w4r5+3HcldBscIOMKMFLC/eRys2R/iKz75AUOL+RX
	 9vZbf9Y0eaqBfkMJ7DwfcCAV3HUuN0aw/tmUC+VNCsjpRodkIQvUBFbab91A2j2tR4
	 a9GsJuV/JY2z+L6Vd6ulUetyY8D52Y99hSUI5Vzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 055/583] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Wed,  9 Sep 2026 15:35:40 +0200
Message-ID: <20260909134239.896447741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -2305,6 +2305,7 @@ void damon_sysfs_schemes_rm_dirs(struct
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
@@ -2346,13 +2347,15 @@ static int damon_sysfs_schemes_add_dirs(
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


