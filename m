Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A3F2500DA;
	Tue,  3 Dec 2024 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239838; cv=none; b=uaSoZTbKJBIHXcf81+Ia1QpdaAH87dHCcb37xdRqoKrqU+WDFz3MgUqrspL68RsGaJsRcV1kfGBah+IMLi7hpJAu3bYdHQngMowbf1HbxOUikbHh/DUO2GJvkTr6VkIwfdQlLz7met1qwXZYR9KhSyEznppTYvQwmm5kMdIB/wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239838; c=relaxed/simple;
	bh=h8tmbYW+rF8X0CdzVSDSUrlqF2cxIx2Wdo6ebVWgza8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISWnqhryZf1tg44OWM0V26UtNjKMUIzHzshXIFm98UHP1m2FJJQcELBJl38jBd+ttFBFX2DSSaYlqu0uxcdomIeJ5Izm6AOk/68Xq/t+qFy077HMiGoWeecRu3mbbgm41ZU7maWXg7FCQLvuD+1Zd17VDyZ7feSm+MwVsF7Z/DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzGO3fNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzGO3fNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F73C4CECF;
	Tue,  3 Dec 2024 15:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239838;
	bh=h8tmbYW+rF8X0CdzVSDSUrlqF2cxIx2Wdo6ebVWgza8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzGO3fNfaiMDleYiuXhyWRWvJRvj2i1kWNyYfKLryEo30odzswB2bnX9YLJRRGR9j
	 wGV62O9NIC/3kUZ2Vnh60biNKA5sFV38mrYrstTXV59md/+Dphb/x7Dpd2wP5jQq3j
	 qAeOu49JSvjicH34ueg40pTygc5lCZyieb3jezt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.11 710/817] ubi: wl: Put source PEB into correct list if trying locking LEB failed
Date: Tue,  3 Dec 2024 15:44:42 +0100
Message-ID: <20241203144023.705139591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit d610020f030bec819f42de327c2bd5437d2766b3 upstream.

During wear-leveing work, the source PEB will be moved into scrub list
when source LEB cannot be locked in ubi_eba_copy_leb(), which is wrong
for non-scrub type source PEB. The problem could bring extra and
ineffective wear-leveing jobs, which makes more or less negative effects
for the life time of flash. Specifically, the process is divided 2 steps:
1. wear_leveling_worker // generate false scrub type PEB
     ubi_eba_copy_leb // MOVE_RETRY is returned
       leb_write_trylock // trylock failed
     scrubbing = 1;
     e1 is put into ubi->scrub
2. wear_leveling_worker // schedule false scrub type PEB for wl
     scrubbing = 1
     e1 = rb_entry(rb_first(&ubi->scrub))

The problem can be reproduced easily by running fsstress on a small
UBIFS partition(<64M, simulated by nandsim) for 5~10mins
(CONFIG_MTD_UBI_FASTMAP=y,CONFIG_MTD_UBI_WL_THRESHOLD=50). Following
message is shown:
 ubi0: scrubbed PEB 66 (LEB 0:10), data moved to PEB 165

Since scrub type source PEB has set variable scrubbing as '1', and
variable scrubbing is checked before variable keep, so the problem can
be fixed by setting keep variable as 1 directly if the source LEB cannot
be locked.

Fixes: e801e128b220 ("UBI: fix missing scrub when there is a bit-flip")
CC: stable@vger.kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/wl.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -846,7 +846,14 @@ static int wear_leveling_worker(struct u
 			goto out_not_moved;
 		}
 		if (err == MOVE_RETRY) {
-			scrubbing = 1;
+			/*
+			 * For source PEB:
+			 * 1. The scrubbing is set for scrub type PEB, it will
+			 *    be put back into ubi->scrub list.
+			 * 2. Non-scrub type PEB will be put back into ubi->used
+			 *    list.
+			 */
+			keep = 1;
 			dst_leb_clean = 1;
 			goto out_not_moved;
 		}


