Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCB8518128;
	Wed, 30 Sep 2026 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787974; cv=none; b=rJDOg95ks9ZdHvUrswKFZ169jAcvqwFBg3YztVFqv7aNliIltK1Xy0ObpztjdNCqSpNcB2ZhgcoTzcSiM39GtNCvgqhuB4GY+BFNHN7SeNrbA2VwDfz71i7JwwnxZwjYgU9i01lA4DlYH52nj1Xj93rqPevxW/PaujnMy7Sw+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787974; c=relaxed/simple;
	bh=htkhOJ0L7VkDrR4/xxObnEUP+jVLjsOPKySpjepbFKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAiSurUUmrR+J2ZLKZorAyG0wWFJ7eb6tI3AdsOlrtVlJmgn4LchooYmntM4Fr6pNJC27cDCTHKa4sgGAyDR4RnRYpLdWewTcikU//N6QQK8j+T/eCh5ucICJYh8C/lbxd8oOOd48HCdJHs1PNeoeb0dvnnrBGL9pQDvMi1LiTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZ3V0iyw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZ3V0iyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF7A1F000FF;
	Wed, 30 Sep 2026 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787973;
	bh=4V4FeZtjfjuYNG09pjcrZrm5GhOyhHG2lQe8K6uFWnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZ3V0iywVe9d4QvrtwQ0Igf2aBO0Mzah15mwguk6UHnUiI0mhrAtPCIsCfHoLhcCd
	 BAtAqIWfD7LC2cVxJMLetVjhIteHRVbDoQunhnRyewJfs8fH+GqQ+z1wU9+v1j5CMo
	 /UIm8kjCp8ZhR7bFgoKdTrIFBGeA5aE6sI7xmzO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 419/457] xfs: use correct jiffies comparison function in xchk_maybe_relax
Date: Wed, 30 Sep 2026 17:28:44 +0200
Message-ID: <20260930152355.029613491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 984aab2d905a8557fafb27cd9e8713d6d12b3437 upstream.

LOLLM points out that we're supposed to use time_after_eq, not a raw >=
operation here, or else jiffies wraps can go unnoticed.  Fix this.

Cc: stable@vger.kernel.org # v6.10
Fixes: 271557de7cbfde ("xfs: reduce the rate of cond_resched calls inside scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/scrub.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -40,7 +40,7 @@ static inline int xchk_maybe_relax(struc
 		return 0;
 	widget->resched_nr = 0;
 
-	if (unlikely(widget->next_resched <= jiffies)) {
+	if (unlikely(time_after_eq(jiffies, widget->next_resched))) {
 		cond_resched();
 		widget->next_resched = XCHK_RELAX_NEXT;
 	}


