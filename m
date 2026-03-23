Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13CF3AEF28;
	Mon, 23 Mar 2026 14:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276978; cv=none; b=kUGzGpIFE0uCy3V2ClmjQeOBZ5ynqk6q8tmASGRJYJ53hThzRM9z8U0XDxMah0DtNUyIamCxG/yLFL/wwV5vB3D8DW0mSCjylUsrXgZ6jIn7ykeys0gUgJz309nC5Mcl0xxVnG6bKCagHbINjzZWprsI6FW4Oa374k1SPLThIms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276978; c=relaxed/simple;
	bh=9rFUBfO9GqmjGsqVTWXEmLC1CzThm3uF9ljypg2tjMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDfA1MIzt8jRuQKQ+F2YC99u6Pe5M96q08yD4nHtLeDj7GXHbyzWrxP+iQeytjz15abSf1pCfgV2WSN29UYXwZoDewEsGXjJsoPiTBq6Ckb015a5jgbxUW69dBc/pYH62L6905o9ddATSKogXZK9PEimYztDvykqMpoRlCxFSk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CT5FnPIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CT5FnPIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C207C4CEF7;
	Mon, 23 Mar 2026 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276978;
	bh=9rFUBfO9GqmjGsqVTWXEmLC1CzThm3uF9ljypg2tjMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CT5FnPIxe4kv6H0uutQvOj8oVyu+gPhcz3U7YnrGiVwpbsIUehdDZaK0tSf+qvx6A
	 ZYswwre8/wDgr0UnYs5fSYEZ4xv3fcjnCUgEBVMFjkZQsK/s164eysZHjjTis3nOd4
	 VEoplks14AHiTuNeD8XGz3WUw80rwieVGfXxEabs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Guangwu Zhang <guazhang@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.12 275/460] dm-verity: disable recursive forward error correction
Date: Mon, 23 Mar 2026 14:44:31 +0100
Message-ID: <20260323134533.236806765@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
in v6.18 which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    4 +---
 drivers/md/dm-verity-fec.h |    3 ---
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -424,10 +424,8 @@ int verity_fec_decode(struct dm_verity *
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


