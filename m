Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7BE10A35;
	Mon,  4 Mar 2024 21:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588206; cv=none; b=D9+Z3u0q6Q6FRbOTtx3hhEj2Q8Fw5MRn+pg7gRLBWnN4sASF9gtThU1ope5iYnry80cPXO4TBB0cYC6QpWKkueP1LW0VaOhLwJr8rMUzFFQ+CXp9epYXBY3tEfvSnDK9bCpVM3lYsJjG7FK9ggPJouPeIuUhm48bSfOYDEJxyyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588206; c=relaxed/simple;
	bh=tJa10jaGz3oj8ZHfCg6mbbeRqCUZp18s8qwTogxWCww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzgBESR8f9I1aUQ1S7BjICm9Rtsg3mDRNeyuLfedN0yZgUJYSb15F/CnCuf/tWKgHyMxjmhR0FwXHSVyxLURTAVEaRRvnElioHhHiGAPvE9eNtgClaXK5frDp+nWpHt/KUT/Krl27MuzEGJ/v53+Qekm/48udnLSYsKFGeUHexs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPMADYMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPMADYMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AD0C433F1;
	Mon,  4 Mar 2024 21:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588206;
	bh=tJa10jaGz3oj8ZHfCg6mbbeRqCUZp18s8qwTogxWCww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPMADYMajHfN8Bz8TXh0+J/9VgeV8Cpboef7xIdfGONTZzHEVSwdYefX/iLgVxelJ
	 mMiW94vNcxZ6TTCcEOlnP7Foup781fHOZ4k1RKZnQHQQfWUNk9TuZgcfBdYtTfNd7X
	 sgUuxyFW/dRu35JBH6At00pVaoO9RchTXyUBFKac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Subject: [PATCH 6.6 002/143] ubifs: fix possible dereference after free
Date: Mon,  4 Mar 2024 21:22:02 +0000
Message-ID: <20240304211549.965375707@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit d81efd66106c03771ffc8637855a6ec24caa6350 ]

'old_idx' could be dereferenced after free via 'rb_link_node' function
call.

Fixes: b5fda08ef213 ("ubifs: Fix memleak when insert_old_idx() failed")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/tnc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 6b7d95b65f4b6..f4728e65d1bda 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -65,6 +65,7 @@ static void do_insert_old_idx(struct ubifs_info *c,
 		else {
 			ubifs_err(c, "old idx added twice!");
 			kfree(old_idx);
+			return;
 		}
 	}
 	rb_link_node(&old_idx->rb, parent, p);
-- 
2.43.0



