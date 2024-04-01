Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341E2383BA;
	Mon,  1 Apr 2024 16:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987220; cv=none; b=ngS0CRWc+HkXZMKwBlRN+hw7EWBXVcMFmO8peJmR6yO8qLNnxu+FFmn/jyEQq/SieCDoKwGd95n182qfkkPPqVoLNX7HIoagZfHwJt/2raQmmZUeYkin/EGLIq0aI+qSLVPwkzusw67RYNaxP85Anlvrzldtczvv+hEKJ6Bic/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987220; c=relaxed/simple;
	bh=jDYijN9C078F5KUa3ivzLgO/xz47GIRgcYhw6l12m8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZMt+/AQhNy9TPTL4MXueOlWQbPM3CKqKdi41tCObE9J6Dd6DhSYpkF8KIDzSsMaUjBEhnMPUPmu2OBdACvDNJmAY8NdXjp+IfPiDnQHdkLXFUNamUkNxwS9vjXs5omNuVMemQzidbFCIhRgf/g0gUgUrnGPYE/kaDWZd9PTfMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g87HjDFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g87HjDFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97C6C43390;
	Mon,  1 Apr 2024 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987220;
	bh=jDYijN9C078F5KUa3ivzLgO/xz47GIRgcYhw6l12m8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g87HjDFxMU/I7IHs86yIh0X+Ze6wvzd2BPUh7hY3TV9iB5ODsFANm1c+t/yCvkS2Y
	 QLWbaRGoCEx8iTh8CoXyZJ7MI0iyKRATmFvVUZcnKU/r53iHqGzgBCuU6KGStnBaJ1
	 suz4bSGNtJWCLen06ZWeCiWXnUweoHhd3eoTRnV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Pittman <jpittman@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 220/399] dm snapshot: fix lockup in dm_exception_table_exit
Date: Mon,  1 Apr 2024 17:43:06 +0200
Message-ID: <20240401152555.749047829@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6e7132ed3c07bd8a6ce3db4bb307ef2852b322dc ]

There was reported lockup when we exit a snapshot with many exceptions.
Fix this by adding "cond_resched" to the loop that frees the exceptions.

Reported-by: John Pittman <jpittman@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index bf7a574499a34..0ace06d1bee38 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -684,8 +684,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	kvfree(et->table);
-- 
2.43.0



