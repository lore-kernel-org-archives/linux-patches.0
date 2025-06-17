Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AF920C001;
	Tue, 17 Jun 2025 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178298; cv=none; b=ezRXoGO0TdHNUUEA4CdFyJUtVNqEnstdZG65AdE83PcTEp3sG0AiicPTOVM/dhVIVYmM01S4oYbjp+45hZOqAMii2YW8iq6YchBIHj2983Ut0CAx3bpie1HDiE6nXvBLkvZwCAiAj5fOY6ItQKXUx2Vn8lc5wRAy31xfK9Hc71w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178298; c=relaxed/simple;
	bh=A11kq6AxO8vdFiu4anS5GGM7J5hDqyG2joSlczYaeuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6k+xhVPfdP0ajCYgQ4QHlPi6LA5buUKJGOVriG3fNv5A5bcbIpRoYjQsimWuoa9MMpQ5epbcoz19nItrTu1/PBPBJiZMvnPBDLXLJh2nz9yTT0JxlHUl6x7if/lZ32f1qEvkDWUW0gwZy7CBGUYX4PJ2FbbQodSVQuKpQQ1CIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0aN2Yl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0aN2Yl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB91EC4CEE3;
	Tue, 17 Jun 2025 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178298;
	bh=A11kq6AxO8vdFiu4anS5GGM7J5hDqyG2joSlczYaeuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0aN2Yl0iSmPc+9MaHKDp9tT8USrm2jjFjb9kQtVEpoMMIwjytzbZfXw060uU+9gw
	 3QXD5glN5X+j2oTjpyjJIoe2jNk9zVsvE7Yt6SWmk+G1tNhjH7XLG2tEg1zs0HVNgD
	 jFc1ZpiGYD0/ux6Bsn9wvXZz3LveXEzNyz/OEG58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 440/780] dm-flakey: error all IOs when num_features is absent
Date: Tue, 17 Jun 2025 17:22:28 +0200
Message-ID: <20250617152509.378069633@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 40ed054f39bc99eac09871c33198e501f4acdf24 ]

dm-flakey would error all IOs if num_features was 0, but if it was
absent, dm-flakey would never error any IO. Fix this so that no
num_features works the same as num_features set to 0.

Fixes: aa7d7bc99fed7 ("dm flakey: add an "error_reads" option")
Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-flakey.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b690905ab89ff..806a80dd3bd9b 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -53,8 +53,8 @@ struct per_bio_data {
 static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 			  struct dm_target *ti)
 {
-	int r;
-	unsigned int argc;
+	int r = 0;
+	unsigned int argc = 0;
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
@@ -65,14 +65,13 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		{0, PROBABILITY_BASE, "Invalid random corrupt argument"},
 	};
 
-	/* No feature arguments supplied. */
-	if (!as->argc)
-		return 0;
-
-	r = dm_read_arg_group(_args, as, &argc, &ti->error);
-	if (r)
+	if (as->argc && (r = dm_read_arg_group(_args, as, &argc, &ti->error)))
 		return r;
 
+	/* No feature arguments supplied. */
+	if (!argc)
+		goto error_all_io;
+
 	while (argc) {
 		arg_name = dm_shift_arg(as);
 		argc--;
@@ -217,6 +216,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	if (!fc->corrupt_bio_byte && !test_bit(ERROR_READS, &fc->flags) &&
 	    !test_bit(DROP_WRITES, &fc->flags) && !test_bit(ERROR_WRITES, &fc->flags) &&
 	    !fc->random_read_corrupt && !fc->random_write_corrupt) {
+error_all_io:
 		set_bit(ERROR_WRITES, &fc->flags);
 		set_bit(ERROR_READS, &fc->flags);
 	}
-- 
2.39.5



