Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39593146586;
	Thu, 11 Apr 2024 10:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830830; cv=none; b=srHo5Y/8w7xrpn7xIedpcOBsPNqX04SLb6lBk8V+uLay3BeGOE2O9ghcJBTmN6Y3J3kK459BirVWw/6HgvWzylTY4bPKE9sILdhksXUmm4QC3d9dI1mESu0+0hpZIrDb+1JdKpeDJswPdfI3rD7fVSnq5tz5i69qzWQ6Ki6zm9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830830; c=relaxed/simple;
	bh=tjPoWvlI1Y4PHX3KhEVJSy2qaq8TA+BpIvYF8epeV24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvXq1IdDj7olzGypk6UV5D1lvn3Xo+8lrcQxzNgCOsdywNzPAkvBh8+fEStjtsveR3Sxfkc08WXgVRlTRS5QyNdF9L5aA6ZVln4sTkYimam805IB4EiAr2f3tHgykF4wVtge6Iwxd/LaSx/tz0suBePRcK/f5E6G3tZhrljr6EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6ArQAmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6ArQAmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E75C433F1;
	Thu, 11 Apr 2024 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830830;
	bh=tjPoWvlI1Y4PHX3KhEVJSy2qaq8TA+BpIvYF8epeV24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6ArQAmZwwuxXBYRid2RUrTBdR7NjgQRvNbvXPnxDHhDHywiqhNWUi5skjaP/7I9V
	 FFJWXva04z5zOAPUOfbFw2wo4Xeo/UtsYHaX6ANfCChj8do7wqw4z5pn96t4gnj9Ms
	 53AaIgEsorpYhVHDApSiaP9MAA8rQ7dlMvTsbsPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/215] dm integrity: fix out-of-range warning
Date: Thu, 11 Apr 2024 11:55:41 +0200
Message-ID: <20240411095428.863718949@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8e91c2342351e0f5ef6c0a704384a7f6fc70c3b2 ]

Depending on the value of CONFIG_HZ, clang complains about a pointless
comparison:

drivers/md/dm-integrity.c:4085:12: error: result of comparison of
                        constant 42949672950 with expression of type
                        'unsigned int' is always false
                        [-Werror,-Wtautological-constant-out-of-range-compare]
                        if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {

As the check remains useful for other configurations, shut up the
warning by adding a second type cast to uint64_t.

Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index f3246f7407d61..4b634633b4a5e 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3755,7 +3755,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		} else if (sscanf(opt_string, "sectors_per_bit:%llu%c", &llval, &dummy) == 1) {
 			log2_sectors_per_bitmap_bit = !llval ? 0 : __ilog2_u64(llval);
 		} else if (sscanf(opt_string, "bitmap_flush_interval:%u%c", &val, &dummy) == 1) {
-			if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {
+			if ((uint64_t)val >= (uint64_t)UINT_MAX * 1000 / HZ) {
 				r = -EINVAL;
 				ti->error = "Invalid bitmap_flush_interval argument";
 				goto bad;
-- 
2.43.0



