Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B86121CFF0;
	Thu, 12 Dec 2024 16:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022765; cv=none; b=D0dGCyZ8vqnDojUXcGLT3uhl6DAklSnhZPT1EYy5rtQJKOi/B+z5Hc2GWIQeeQsMY/EpKthS2Ydk8V2TmhQMco9VWGayNDJC9zalidrxGBkNu86/U0KIXNsvotdLtobM75CRHAw0nIFsIebOiM10IvZ4uwZbEVGP14k493NBOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022765; c=relaxed/simple;
	bh=xS1TVTCvUxtaCmVA5/6wrxNqnsNVkPv/o+/Iv3s45Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReWiY5JpScGKw8O6NtAL60gOQj8aigEm/TZuWLKVj8fPrvQO9uMMghER1EryJZO+yCfivHpf9cIzYsnOvhLYTztg/g+BYLKNxOehUjz/2IuDSMy7NAxb5uhGxE9CIXaF0w2WEvqZU+Ro0/xWKEAemCh0wqc3gPM6UYXfw2LuNz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2S035AQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2S035AQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D52C4CECE;
	Thu, 12 Dec 2024 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022765;
	bh=xS1TVTCvUxtaCmVA5/6wrxNqnsNVkPv/o+/Iv3s45Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2S035AQVBKj93WVzguGo0qOubhJvOR//8WSqT36ehl0BHRYfum4oNsuFNIVUwxcFd
	 Q2RqLNF0y1l79HUQX2SB0xdEVfWFlmp2vbR1JN91pvWsb9r6t0LB5ArRVPKE4xjEXT
	 N4V6MsPSGaPS2Diwpa2WT9wme0qIJdbtwIWW/cXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 331/565] ubi: wl: Put source PEB into correct list if trying locking LEB failed
Date: Thu, 12 Dec 2024 15:58:46 +0100
Message-ID: <20241212144324.680431776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -830,7 +830,14 @@ static int wear_leveling_worker(struct u
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


