Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667171C3F19;
	Tue, 27 Aug 2024 15:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771135; cv=none; b=ob6UfDtTJB6IwGb/sNSileH8zSS9In+mYjFKn5mA/HEhUxQ2xd4vtPqIaNcykP3FU6TwcvBQiLPOX0G4FqW45Vkg3rDnFwBROTTs3v0NzyDxwAVIr8MJlt4u4Z1QtGi1ZXY+O1BDqMLfqdNYsFvwjGQISBlV01YJRaYtnF47VEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771135; c=relaxed/simple;
	bh=eFnK8jpqBxbWdJP0uM9fqI9vOa+HNcBMu8Ymr9odrQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCqG1zfMa7Bq/Nkc2aBU1TkbkYodyy5/XyTHmHc14+nMywO4TBo/irECeT5r71OJMDAIz4sXH2PWTlTjstunxayEmBCHHpDEh/lWx9v87eolsZpG/QNxkSTt8mzzWbdGm8uz8adFpymNYXxe2Q3v+BtWK8B4nH3HGPkSqKUv9wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogurIJ0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogurIJ0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF254C6106C;
	Tue, 27 Aug 2024 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771135;
	bh=eFnK8jpqBxbWdJP0uM9fqI9vOa+HNcBMu8Ymr9odrQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogurIJ0NS5JxBzCNcRjycTs73qA2EioImkg60zP9aKGUK0VTo8bunD4WHrE1qMKiA
	 dKZ5tbc322aNmTWDrIr46jrrkt0e3a1Cikxtyj4jDvzfYqd+Dx84zYcxDyu7tCExQE
	 mh+SpZ6/xzF926BB/ZDMMRkSTFboNVdOcDkeZgks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 066/273] btrfs: only enable extent map shrinker for DEBUG builds
Date: Tue, 27 Aug 2024 16:36:30 +0200
Message-ID: <20240827143835.925652700@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 534f7eff9239c1b0af852fc33f5af2b62c00eddf upstream.

Although there are several patches improving the extent map shrinker,
there are still reports of too frequent shrinker behavior, taking too
much CPU for the kswapd process.

So let's only enable extent shrinker for now, until we got more
comprehensive understanding and a better solution.

Link: https://lore.kernel.org/linux-btrfs/3df4acd616a07ef4d2dc6bad668701504b412ffc.camel@intelfx.name/
Link: https://lore.kernel.org/linux-btrfs/c30fd6b3-ca7a-4759-8a53-d42878bf84f7@gmail.com/
Fixes: 956a17d9d050 ("btrfs: add a shrinker for extent maps")
CC: stable@vger.kernel.org # 6.10+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2387,7 +2387,13 @@ static long btrfs_nr_cached_objects(stru
 
 	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
 
-	return nr;
+	/*
+	 * Only report the real number for DEBUG builds, as there are reports of
+	 * serious performance degradation caused by too frequent shrinks.
+	 */
+	if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
+		return nr;
+	return 0;
 }
 
 static long btrfs_free_cached_objects(struct super_block *sb, struct shrink_control *sc)


