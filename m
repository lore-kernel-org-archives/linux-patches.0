Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DCB38398F;
	Sat, 12 Sep 2026 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231440; cv=none; b=Tob3ZYS5thwA7npXeO3opDGRnEcb2Y3Qghhga5evq+ZO4cWktUvoWDTpT4RinAjEOMURNx4Ahj1t8rOraxJPh5VYRX2fdqGxtHKNhJ1lWBQspOx8aXZev+zh01CeNf0gCfwHo2uPCN5XDbVJqu6P9iz/WaYVEA7jxuY902UMb1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231440; c=relaxed/simple;
	bh=2UtKFsmWlGtJIud3bz6VTElc0aUz8yJZj2x3yWaLKZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAi1cmSdrhL0QqOqKGrtTzSPCfMK71IQIDA51iWGBDymjjlAdU3W/gA76rQZPGgU19aHRqLP/pC3I65FTJNbhphLbFp74pitCT4pt/MdHgEgn9GKPVQj6wu9ESmjRugww4yaHDAoakGtEIIrV8GD+HMyXBUHFAEgiJheVfaDZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYUcyuVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYUcyuVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CCB1F000FF;
	Sat, 12 Sep 2026 16:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231439;
	bh=D0hdbNdEiCuVMpvT4MpO6EYC9Xt01LQZcEU3QkfznYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYUcyuVwK7QYAUtPMWPq7U5TAtR+aRrVzxh9mjcx1+ikt/tafpHh/sckd9DbRJ5zx
	 PabDp3H19W4vYU/TXkh/FnpepcX7oMfnczV2BEPPF/jak2h45HcO2QihruJKQOYT5X
	 8WuzQTF1JJspsKHk8RK/j7zgUTSJg0QvMWUI5N+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0998/1191] s390/debug: Fix deadlock during unregister
Date: Sat, 12 Sep 2026 09:02:06 +0200
Message-ID: <20260912065610.615037319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 445c31ac638fd1af203d79bdf25fc0cb3149fbbc ]

Unregistering an s390dbf debug area while one of the associated debugfs
files is being written to can cause a deadlock:

$ echo >.../vmur/level    $ rmmod vmur
===================================================
debugfs write
debugfs_file_get()
                          debug_unregister()
                          mutex_lock(debug_mutex)
                          debugfs_remove()
                          wait for debugfs_file_put()
debug_file_ops.write()
debug_input()
mutex_lock(debug_mutex) ==> DEADLOCK

Fix this by splitting debug_unregister() into an s390dbf and debugfs
part, and running only the s390dbf part with debug_mutex locked.

Fixes: 9372a82892c2 ("s390/debug: fix debug area life cycle")
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 65302aea77e85..8cc747b39c84d 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -747,8 +747,8 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
 	mutex_unlock(&debug_mutex);
 }
 
-/* Remove debugfs entries and remove from internal list. */
-static void _debug_unregister(debug_info_t *id)
+/* Remove debugfs entries. */
+static void _debug_unregister_debugfs(debug_info_t *id)
 {
 	int i;
 
@@ -758,6 +758,11 @@ static void _debug_unregister(debug_info_t *id)
 		debugfs_remove(id->debugfs_entries[i]);
 	}
 	debugfs_remove(id->debugfs_root_entry);
+}
+
+/* Remove from internal list. */
+static void _debug_unregister(debug_info_t *id)
+{
 	if (id == debug_area_first)
 		debug_area_first = id->next;
 	if (id == debug_area_last)
@@ -783,6 +788,7 @@ void debug_unregister(debug_info_t *id)
 	mutex_lock(&debug_mutex);
 	_debug_unregister(id);
 	mutex_unlock(&debug_mutex);
+	_debug_unregister_debugfs(id);
 
 	debug_info_put(id);
 }
-- 
2.53.0



