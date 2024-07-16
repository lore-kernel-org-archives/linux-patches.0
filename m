Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDABA1DDCE;
	Tue, 16 Jul 2024 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146180; cv=none; b=H/zcnj3/1aGNczxEiPZOe+arIXuCVjp4Pw6r7CybuPhY0xdXS168Ns/4X5S7s9iSMJieYmAbApdSH6VU4mOfjLEQ8Mv0FRjDybwrA2qrXFwn0tWmbVjxMeSCxYBwGpPZVOliq4jDJ3qdj7OLSqYcGAu0WHqSqH/A0Ca1uyv9ePs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146180; c=relaxed/simple;
	bh=q1l2mygJUX/m0zRZj7LTc+3t/5Qo9JoHyNAJn24lbLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDDMLypveBmd+RDF3VjkwX3StZnQdHVC0XlMEckcNB0AveeERtHzjjZttawTuWSiesPrxU+eXgn/wQTIWcJBkONFf+lcJ6Yu5K61tDrzqc3ecC1f3mkbjh1s004OQ3szniMGip9YM3caFx9l3ehQq9wi3M0y9/rjd2X/NFReXM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiYtzr1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiYtzr1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FED1C4AF0B;
	Tue, 16 Jul 2024 16:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146179;
	bh=q1l2mygJUX/m0zRZj7LTc+3t/5Qo9JoHyNAJn24lbLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kiYtzr1B9sDCoPZW/VsJq6HTTAQ6h2PY86rmQK1idV1J1VkJ66SxmVuhl9Sbf6WHm
	 tOGRhkkyDLof2kOiI4SRYK+xsBz2cRZ/XPI9c01GkLVieZSXHwL4j0DuopAEiTtRAd
	 NHskJqEo1w0/5gnIxibGj2t5BiJ9755xczwaLW3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/144] fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading
Date: Tue, 16 Jul 2024 17:32:30 +0200
Message-ID: <20240716152755.656905013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: linke li <lilinke99@qq.com>

[ Upstream commit 8bfb40be31ddea0cb4664b352e1797cfe6c91976 ]

Currently, the __d_clear_type_and_inode() writes the value flags to
dentry->d_flags, then immediately re-reads it in order to use it in a if
statement. This re-read is useless because no other update to
dentry->d_flags can occur at this point.

This commit therefore re-use flags in the if statement instead of
re-reading dentry->d_flags.

Signed-off-by: linke li <lilinke99@qq.com>
Link: https://lore.kernel.org/r/tencent_5E187BD0A61BA28605E85405F15228254D0A@qq.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: aabfe57ebaa7 ("vfs: don't mod negative dentry count when on shrinker list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 422c440b492a5..f2ff73fe2b619 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -331,7 +331,7 @@ static inline void __d_clear_type_and_inode(struct dentry *dentry)
 	flags &= ~(DCACHE_ENTRY_TYPE | DCACHE_FALLTHRU);
 	WRITE_ONCE(dentry->d_flags, flags);
 	dentry->d_inode = NULL;
-	if (dentry->d_flags & DCACHE_LRU_LIST)
+	if (flags & DCACHE_LRU_LIST)
 		this_cpu_inc(nr_dentry_negative);
 }
 
-- 
2.43.0



