Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5622E4E01F8;
	Thu, 17 Sep 2026 15:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660693; cv=none; b=r8N4/tw5PLsEnKm1R7dycOzLe/o1txGNWKMW1o5Dz7aLgx995Kxs0ZLOFHoCPaq6BVQC2TofyqIULQvwdkedUJZ9oQFIv7sCvXw2g3hZ3hpiV9GahGFLK/7J43hEL87OFd9vRv2DJ5cSYXs7nx5gHPAwJXjTrazi8wBFaK2eFDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660693; c=relaxed/simple;
	bh=kD/6pbldUmbM8F6nj7UnB51g9xZogemWq6o93QhZcOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hg7bmmX0WQ6yRq6GxTsxNYtnFqGtMXh6EPnq1ci4ZXUwRZ/0CvwkZk6Ozpbd8rSg7ddYBHWKNGWHZzdHDCrs0hoLDtHTwKxbQgSwl+vqkgSQnoStDQ0Z4fDYv4C5t2/XncmYO4jACGaFnMGPVPWkW1EbY45QztfZFkbbaf/AgDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A80Wxwgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A80Wxwgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476581F000FF;
	Thu, 17 Sep 2026 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660691;
	bh=ds9z/2jqRwOBXKV+/WNcTzla2B+PB0XmNCHti11AViI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A80WxwgxfIN+LkbpOLw2hJVc2GKfs7ZqLM4hjdgIovRXmwYkOS6qNiAJfGMVdQYhj
	 cEwmc2rAyjWRwKeLdXRbEATj4j8FWBzgzynSskx5/TfJuuDkf7RInNh7t9IS0rsC7L
	 wAXjc7WmsTbIRbJEh6QUBVKHJ9Xtek/il35gJQlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 677/733] xfs: dont leak dqacct if rhashtable insertion fails
Date: Thu, 17 Sep 2026 16:16:25 +0100
Message-ID: <20260917151409.624936270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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


