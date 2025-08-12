Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE1E305E13;
	Tue, 12 Aug 2025 18:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024806; cv=none; b=PhKmY1aRMeq8UUJqSaLm4nJ4TG7DNGTuCuWsqgv+TQeoCjn26cOTeizAVD4Pi9hAawjvRBtePJNiErqwb7tasnfLIiKG4434KKItMJ/HlXkXZIBe0CipdE7mBl1ZQqCFcEQZl5Q61pHBc+jyH42/Dygg1WvrgGO3laQ0GYhCwGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024806; c=relaxed/simple;
	bh=Si5eeOWI8/babYodwWttdSmi4NKi3CXPXD+fbcCTB0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAyMYyKoxHN5R7rzo7MH6P+ey3YcnjZ16wfED+sgTIndq1FLBUniseIbX/r2p5pCvHiEmpJCSl64Bpow+coX93FEtW2FO9sR6PFH7D0c8foQdz1yLcPOXPpfm+vFo0c/cg1TDNdVD1897EMNXWiAUuMOjYKq55EZ4C2GmdIjqtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBYNjUYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBYNjUYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F3FC4CEF0;
	Tue, 12 Aug 2025 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024805;
	bh=Si5eeOWI8/babYodwWttdSmi4NKi3CXPXD+fbcCTB0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBYNjUYermeb82tq0VbCaZIj+hZS0HZzSARmUjneZS4lnTqq+RLi/0VMCSYaKO5RF
	 rFslQlMYrXNKiBAvP9p0MwApwUhcNzeE71jmVeWs5NtYNqIg9QYV+STTcfFImFnku9
	 DIa1PP6W72dwv0BtaIGplLMhF3SscutdQdZZIdEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 455/627] dm-flakey: Fix corrupt_bio_byte setup checks
Date: Tue, 12 Aug 2025 19:32:30 +0200
Message-ID: <20250812173438.041883323@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit 75227ed6812cb869380c8fb6d41a845ae571781e ]

Fix the error_reads mode - it's incompatible with corrupt_bio_byte, but
that's only enabled if corrupt_bio_byte is nonzero.

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Fixes: 19da6b2c9e8e ("dm-flakey: Clean up parsing messages")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-flakey.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index c711db6f8f5c..cf17fd46e255 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -215,16 +215,19 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	}
 
 	if (test_bit(DROP_WRITES, &fc->flags) &&
-	    (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
+	    ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) ||
+	     fc->random_write_corrupt)) {
 		ti->error = "drop_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
 		return -EINVAL;
 
 	} else if (test_bit(ERROR_WRITES, &fc->flags) &&
-		   (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
+		   ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) ||
+		    fc->random_write_corrupt)) {
 		ti->error = "error_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
 		return -EINVAL;
 	} else if (test_bit(ERROR_READS, &fc->flags) &&
-		   (fc->corrupt_bio_rw == READ || fc->random_read_corrupt)) {
+		   ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == READ) ||
+		    fc->random_read_corrupt)) {
 		ti->error = "error_reads is incompatible with random_read_corrupt or corrupt_bio_byte with the READ flag set";
 		return -EINVAL;
 	}
-- 
2.39.5



