Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA60357D20E;
	Wed,  9 Sep 2026 14:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963366; cv=none; b=Y9D+1bkwTUu2wyaWxRdsqvCXWhLlXCLOojrVwGu/kqxTJkiygUA2giMR0+sU5b9aI7QOQLN4Qvd1RxFW8MeshQw04YhPNS8FprvbhbyiRwcoe0ZItrnAuyeDrqPi5NtWcjsEvd+9HHmG9zfYjx/spI93Wv+NHI0pcC5B+98BUkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963366; c=relaxed/simple;
	bh=DsZ0lfjduZGxYIbXnP/bjL///VHgaj78Zky4UhkRRjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVXpynliSlciCb7IROZ2bt/GCDEvggLcKAkDrLU45esuAc1oYkAZuEaBmTX4RpNGMpM6EOa/iyK4LA5ode129d9+5/MSlAbal+IzJ4ZJBKGEGXKdHOT3ir/0eaxr2FL/Rv+dnZQADKSJZxwoHTR5Ac9TgMLONiZCHVXiPPJ3zj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmdjimBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmdjimBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34F01F00A3A;
	Wed,  9 Sep 2026 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963365;
	bh=mrMn7wdpCteQ09EtDQ8mDTL7swoyDEhkot6DWsjHPzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmdjimBnfyixD4InPCdhjSLSiacEtczmkI2RBmo3V/Mm7vPS9fN+xV1CQ5OdIouQk
	 WM51SQ1DV4HJuxdVMSH9fAq/P5mY/+MgPEGzG88wibLu5l+8Ju9x90KnAbLoszDjiV
	 SV8x3DbHHIVrTX6TKEhcIqZq73dkwCFRNSv+Shks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 054/583] mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
Date: Wed,  9 Sep 2026 15:35:39 +0200
Message-ID: <20260909134239.856367993@linuxfoundation.org>
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

commit 286380c78bc51e6c578621b9ae660bf9e5ad2563 upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme action destination directories by adding
kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-8-sj@kernel.org
Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1762,8 +1762,10 @@ static void damos_sysfs_dests_rm_dirs(
 	struct damos_sysfs_dest **dests_arr = dests->dests_arr;
 	int i;
 
-	for (i = 0; i < dests->nr; i++)
+	for (i = 0; i < dests->nr; i++) {
+		kobject_del(&dests_arr[i]->kobj);
 		kobject_put(&dests_arr[i]->kobj);
+	}
 	dests->nr = 0;
 	kfree(dests_arr);
 	dests->dests_arr = NULL;


