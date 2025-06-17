Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F15B2F2346;
	Tue, 17 Jun 2025 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175775; cv=none; b=G4T1udt9iOHrRRmTdXXip3Lhsg6MIBPqhJQTcuos+Wqyns6E0cd4msPeqdrmsh4HC5opZSkmF1LgvnsWXMm3/OCugq7eIwMliJWZd0eGwFPXqWBTP6iEX/Idv70kcuttPwBsCxO785plwDw6zQhOoX+dIv1wT++sjgXxQrXknIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175775; c=relaxed/simple;
	bh=0iZ9+bkJrryiwzQygRYG08S2v9i/LjAVZuWHc3jYelk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln36A+MZr/mFJRfBzfBl5an6c25tvPwsIZkksU6PorlWeCWe5lOk0a/6b5gtkAHGKcvyN3L/5at4hZ9Cqac1Tfb0mDfCjsmnKcoy44B5qLAplH89RUtezSicueNmdk+2v2AR/Jw8glPCCu638klTbPYP6W1CeKecs5C4pliOnGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irLQTzEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irLQTzEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95411C4CEE3;
	Tue, 17 Jun 2025 15:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175775;
	bh=0iZ9+bkJrryiwzQygRYG08S2v9i/LjAVZuWHc3jYelk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irLQTzEcyWTnLEgQ6cSGYzpmUTR7KKLH+AfGXIGMkU7lK6Blt30a6lrNhGH2rcdv6
	 luKvWjY+OjF03TZCqmGTbsuWtl1ucSnEvAQBFtS7RG8V05ej4wEcbaj0maBkF7sfKv
	 Dmz9pvrsJ9Ai6thoH97xoxfpmC4wTLGMeCZgxAXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 205/356] dm-flakey: error all IOs when num_features is absent
Date: Tue, 17 Jun 2025 17:25:20 +0200
Message-ID: <20250617152346.463253368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dc491dc771d71..aeb9ecaf9a207 100644
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



