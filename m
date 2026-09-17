Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BCA4DDB5A;
	Thu, 17 Sep 2026 17:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666682; cv=none; b=VaknKx8kX2uKm8SqrcURkxABTh8sQVUhPp3QAwTo8RrS5vOy4qMrOVBcHYYpXGXYt0mj9MnElejqNXhJLJjVxXO5TlwBTmThw7v2QQen8FeZIOkDmRTPsrH6jtTW5QpvfWna/XH5e77ie6s69Blf1Ex8tT5aABQGXis9J7D1sVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666682; c=relaxed/simple;
	bh=z3yGZ+C9zbv+1JVUV3anVt0E9r54Hit3w6fcn/SKORA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vC4wS5xxEEJfXH5pMYeWqxVAtBKiZpZ72Ijz/k/zLyFkjHQgBtG9QWTZbvb3OymWhKQ0p0vscAmHT6GB3JID80nDQid5daOIVHCcpFC9Yd+6zt7EE0biMuqfgrGg1RL7w5olzCtSEfwRReIlTv/eVaSgnn6LIIXfk7g6sq/RGr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8V2yX8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8V2yX8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960831F000FF;
	Thu, 17 Sep 2026 17:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666681;
	bh=ZTYBog5fQkG1i2n+jfgWF/NrIXUqrB1FD/7VoMl6vTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E8V2yX8e92inDN8r82hF+rC7O6IFRVrgvX3Nzk/TiM4HwI2D4Lw/aRrYlnH5ZB2dM
	 BZDOlLldKvhzS0u8Zq/ZmEzIxug8oAD+hRwzVREZLUmh4vEt7zNKXYQrpSfTrdyJSY
	 aZwbgO7FSzHKxSpem2rZVVFB998EFqN7CyejydPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1119/1250] xfs: dont leak dqacct if rhashtable insertion fails
Date: Thu, 17 Sep 2026 16:15:14 +0100
Message-ID: <20260917151622.559061007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


