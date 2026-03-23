Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC303B8BCB;
	Mon, 23 Mar 2026 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278936; cv=none; b=IE+yT4sTEMzXJVrstiK2Vmj1nWi98Sl8SVGlMM/jmZLJIz0NyUIxv+VVc34tz24dHeVI8aV03xmzEQIHD5igTMC0EYU23i98AJY2ZFF+EUT9l9On2bwVZb7CrjkSjC2Q5GR7ctLlaZtVNHU8erbwGDbEpRNNtwWyX/WolFTQR6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278936; c=relaxed/simple;
	bh=eXVhKOtywXEPxojTjjgdLADL8uSKsdXMT1zGm8ekus8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgknSuuezmBUeVVw72WYkkcX9CZAlwj5pKmkcG8S1pRvg/jEZ0aOzUQzn7njFNuhmB8JGVJcNqBcQyCTqc3qh3XzWKoLd3kbbIR+gvZ1uxAZxmZeLU10l0mKk0TiDXE7qvzlgmtS0TW6FOUZBJ7lBfPTDd5XuklfXVtZKp/cR7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGc/y56D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGc/y56D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BD6C2BCB4;
	Mon, 23 Mar 2026 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278936;
	bh=eXVhKOtywXEPxojTjjgdLADL8uSKsdXMT1zGm8ekus8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGc/y56Dd3eRgayG7fWhyvy3qLpjQNtQ1VwZfgA5LXUzw30ga3zc0DlHxhHTUZ8Rg
	 4JrZcdBgLo3XfMbuZWkN1l9VNPrwp8+5+Qd1UMpZdjwqAyuOX0cRz4CsIQgOusFP7k
	 ej1bS5Au37E+8NGqHyGRNukjf/t6JxWOaimontvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Guangwu Zhang <guazhang@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.6 414/567] dm-verity: disable recursive forward error correction
Date: Mon, 23 Mar 2026 14:45:34 +0100
Message-ID: <20260323134544.132034761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit d9f3e47d3fae0c101d9094bc956ed24e7a0ee801 ]

There are two problems with the recursive correction:

1. It may cause denial-of-service. In fec_read_bufs, there is a loop that
has 253 iterations. For each iteration, we may call verity_hash_for_block
recursively. There is a limit of 4 nested recursions - that means that
there may be at most 253^4 (4 billion) iterations. Red Hat QE team
actually created an image that pushes dm-verity to this limit - and this
image just makes the udev-worker process get stuck in the 'D' state.

2. It doesn't work. In fec_read_bufs we store data into the variable
"fio->bufs", but fio bufs is shared between recursive invocations, if
"verity_hash_for_block" invoked correction recursively, it would
overwrite partially filled fio->bufs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
[ The context change is due to the commit bdf253d580d7
("dm-verity: remove support for asynchronous hashes")
in v6.18 and the commit 9356fcfe0ac4
("dm verity: set DM_TARGET_SINGLETON feature flag") in v6.9
which are irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    4 +---
 drivers/md/dm-verity-fec.h |    3 ---
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -439,10 +439,8 @@ int verity_fec_decode(struct dm_verity *
 	if (!verity_fec_is_enabled(v))
 		return -EOPNOTSUPP;
 
-	if (fio->level >= DM_VERITY_FEC_MAX_RECURSION) {
-		DMWARN_LIMIT("%s: FEC: recursion too deep", v->data_dev->name);
+	if (fio->level)
 		return -EIO;
-	}
 
 	fio->level++;
 
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -23,9 +23,6 @@
 #define DM_VERITY_FEC_BUF_MAX \
 	(1 << (PAGE_SHIFT - DM_VERITY_FEC_BUF_RS_BITS))
 
-/* maximum recursion level for verity_fec_decode */
-#define DM_VERITY_FEC_MAX_RECURSION	4
-
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
 #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
 #define DM_VERITY_OPT_FEC_START		"fec_start"


