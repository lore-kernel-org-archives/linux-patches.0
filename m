Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A067B1C5793;
	Tue, 27 Aug 2024 15:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772267; cv=none; b=CPo40Z7KmP2zko/Yg0lJDusa3i2KMv2zYoqUJkY1CoXmgXTKiGbOJKNPu9J3sDfxGgRLDyglJu5EN2lBIjoPrc4l2eaYdP57m9VFMam8d///tsL6vmD2kFoNxzUo7N2HbWKehaatm7bEIIWH+I95eUkk4yhYOHRTQp7g7YfsMLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772267; c=relaxed/simple;
	bh=UFe/IWM+WJq38ghUb7UBkHDzf1BoEfuJsa1f+iNAudo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNCSbm9CyTTCDew2S+bunlp4HMP7THkGZ6oMpgjqRKRX6Ep6YVDlxEEYrREkxqblXxQZ4M/nqeONPUsG9+PgMgfwfiHop579HyDl9j73et7RQqwi/6s7CNxSU5iAABq/3Znr6jjB0KLUzVYxO2oduKMj9MnnhU5cTIWR60NU+Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeC8nL68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeC8nL68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BA5C61071;
	Tue, 27 Aug 2024 15:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772267;
	bh=UFe/IWM+WJq38ghUb7UBkHDzf1BoEfuJsa1f+iNAudo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeC8nL689Yh7R769m3anLFPErjTqKifBYSlbQ4TpPLI/2U+z4i3c4k9NsLx4GCdyz
	 miVjG/4eLLjmF/eT9hRBls2rjcgY7C/Tk06psXFd2qchlfCig287dhTFK+wCXmtn79
	 WJGRypuGu2+tddHD1JRO6UaanAv0EW/rKKVvQ794=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/321] quota: Remove BUG_ON from dqget()
Date: Tue, 27 Aug 2024 16:37:50 +0200
Message-ID: <20240827143844.397140404@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 249f374eb9b6b969c64212dd860cc1439674c4a8 ]

dqget() checks whether dquot->dq_sb is set when returning it using
BUG_ON. Firstly this doesn't work as an invalidation check for quite
some time (we release dquot with dq_sb set these days), secondly using
BUG_ON is quite harsh. Use WARN_ON_ONCE and check whether dquot is still
hashed instead.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index b67557647d61f..f7ab6b44011b5 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -995,9 +995,8 @@ struct dquot *dqget(struct super_block *sb, struct kqid qid)
 	 * smp_mb__before_atomic() in dquot_acquire().
 	 */
 	smp_rmb();
-#ifdef CONFIG_QUOTA_DEBUG
-	BUG_ON(!dquot->dq_sb);	/* Has somebody invalidated entry under us? */
-#endif
+	/* Has somebody invalidated entry under us? */
+	WARN_ON_ONCE(hlist_unhashed(&dquot->dq_hash));
 out:
 	if (empty)
 		do_destroy_dquot(empty);
-- 
2.43.0



