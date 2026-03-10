Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E77C248F73;
	Tue, 10 Mar 2026 11:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141056; cv=none; b=ZV8AYlWZhAKnqOByGtOM0K1DQjdj95RqiD0/W3ttzVVdoMuidqbQbCgjoeJXL7LoytNYvctib1aS5WFHKUOg4/Juy4bY8WSTW1CroTJnzdl5BUdVDg6Jb/B8EFmTFGQTe53Q3CffeGf565mRqAvBu56bxLEpWSOjJpDY8OgEFog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141056; c=relaxed/simple;
	bh=cWW9eFof961L9aB0guzCzhLkPs5ubIyNdwZ3bHGZUxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XILpm1sP6r8DjZswJ11ykLxaqrMyCmQPwYzyvXKgAUybqlcSflZLWnTukcWIF5auCygPvJk/grekCi0F77YqHKf65CvJEX++8mRE4dKPAoeMuHetQWqoxBnqw6aaPtiEHdN/zqzAzSMMu1MI031j2phke7cxi6CzAus5h/muFjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3CYy+cJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3CYy+cJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955CDC2BC86;
	Tue, 10 Mar 2026 11:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141056;
	bh=cWW9eFof961L9aB0guzCzhLkPs5ubIyNdwZ3bHGZUxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3CYy+cJGFZ7mxVBAy1mzlB79xOPhlgx/csDrxa8Eg5G8sLdYrwo511LnEO0bI+td
	 JeYsdR/431DrNdGaXbnWKERp3mJRo8ntNhzC50Bh8yJ/ChO2xD3e5c76489FMOAKfN
	 vRk6w23LCTMW3IQPVsNM2WDs9uNG4L9VrUPzgNWTkAFptgvZtZiWqwM21fW608Juug
	 t/aQ53zbQ8PlHFHnkYWEjKpVxbAirI1kH89XKYhKBC+kRT4GxGVEwQVYhz9n2xUj/2
	 BGfyULM4MXEszXgUegWuD/APwfkeeI5u4OaYXS62aQQw+x4aZm5QBqCpKxhpbLSj/w
	 cL1anlteUyqig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 055/311] zloop: check for spurious options passed to remove
Date: Tue, 10 Mar 2026 07:01:42 -0400
Message-ID: <dff55384c7890ca8f8392b528f767f2d48d4ffcf.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3c4617117a2b7682cf037be5e5533e379707f050 ]

Zloop uses a command option parser for all control commands,
but most options are only valid for adding a new device.  Check
for incorrectly specified options in the remove handler.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index ae9bf2a85c21c..9e3bb538d5fcf 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1174,7 +1174,12 @@ static int zloop_ctl_remove(struct zloop_options *opts)
 	int ret;
 
 	if (!(opts->mask & ZLOOP_OPT_ID)) {
-		pr_err("No ID specified\n");
+		pr_err("No ID specified for remove\n");
+		return -EINVAL;
+	}
+
+	if (opts->mask & ~ZLOOP_OPT_ID) {
+		pr_err("Invalid option specified for remove\n");
 		return -EINVAL;
 	}
 
-- 
2.51.0

