Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63E497396;
	Thu, 17 Sep 2026 18:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671252; cv=none; b=rZTpGNwyXKA4d3KAt3NhfGLQJFw1pk04sns/3ksw+IMGw5WLch3HNfMB3NyYXvSmPzKyOrSkgPQTq9+SUyeLiY+57t+RKgNuqdPr+4Z+0uFpfXZ5xWZmQiUv5zGqrgNJQfdBmy9MM0iN7gHR4RuOrzrYpumJtmqsjmwtT+rW8RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671252; c=relaxed/simple;
	bh=XLFtD9JCZTz5r5Gts1Q2Dnw7MGGE9TakjAQD6C17BNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQD28AjKfVXslNF7htzB8zi7EW9R5zyycdwxu0xHmH7q8a5eK0tXdrDi9+OUvHGBLFMW2qwPoVg7qqVir+U9mzVM+kL5JqT+s4XbzOctq5o+bvFUfYY8F33SOrjdd7reNaXUr3K4NasVxZGofYS/20Zr9JpvzfJ25o+o5LcgVbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZ954Tmf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZ954Tmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2379C1F000FF;
	Thu, 17 Sep 2026 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671250;
	bh=zh6RNarzP938xFKtYIaa1j/YUdbkK3SzGrVWVPMf9oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZ954Tmfm7hgcJnoJ0xmZVPzNIQdbDDDmbulT7ATXzVAjCsBC79Oyc0fogcD3Fp74
	 e3pieLBVlG8/SHfTyLKkwio9njngiRJVI+7ykpOPNTB2hO58xOW0RSYoOZijwyMRKq
	 6hX/9trz1uGXQb/EiybDJWutIWgoPab6Qr17naTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0914/1102] xfs: dont leak dqacct if rhashtable insertion fails
Date: Thu, 17 Sep 2026 16:14:17 +0100
Message-ID: <20260917151603.564854050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 2eac8d01d2c776fc26b0ac74aebdf91bc4490891 upstream.

LOLLM observes that xqcheck_mod_live_ino_dqtrx doesn't free the newly
allocated dqa object if rhashtable insertion fails.  Fix this leak.

Cc: stable@vger.kernel.org # v6.9
Fixes: 200491875ce144 ("xfs: track quota updates during live quotacheck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quotacheck.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -263,8 +263,10 @@ xqcheck_mod_live_ino_dqtrx(
 		dqa->tx_id = p->tx_id;
 		error = rhashtable_insert_fast(&xqc->shadow_dquot_acct,
 				&dqa->hash, xqcheck_dqacct_hash_params);
-		if (error)
+		if (error) {
+			kfree(dqa);
 			goto out_abort;
+		}
 	}
 
 	/* Find the shadow dqtrx (or an empty slot) here. */


