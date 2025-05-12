Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED3D2980C9;
	Mon, 12 May 2025 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073225; cv=none; b=F2UGPhKNqsNXuIJ3/HESYU43RQUW/DzJOhZJhqLN/E+C+ZWpYDu0OZ8s2YndeaTIL494B1fC3jp0rHRVCKKtopH1zTogXQZ7aGC3fOnaGCx9XhrAgzwrei5SM2xLwOedZNVVy9ES7sVxHF41qwiH+DR6YsVtn5en7GrHc45iWK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073225; c=relaxed/simple;
	bh=A3IVMs7DpbJdD+J7VIWt/b8PsUkNMNzY8LfgI/g+D5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiaY/2oDl6nE/mMPlZO7zAz6lu6iiMoQoSU7+yLuv48WUysS3GRMtR0LVyQ36GDRtNgcB2JlA/xO03bxUvBxc+aC7z4eXmQe9xfKArr9BjfydzdI+yPAmYx87oq4DkeI+xuA31YGahdathgE7mSxh27ZQHyx4+mw1mM2ge/iTjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Msg6Pd6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Msg6Pd6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CC4C4CEF3;
	Mon, 12 May 2025 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073225;
	bh=A3IVMs7DpbJdD+J7VIWt/b8PsUkNMNzY8LfgI/g+D5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Msg6Pd6QLQ+qhsR1u1b5/epF2beYyN2NKzOmNrzCUsOA4PcVVdee9mbDRg03PwfPI
	 zatVlneLbSnlhD0AghsV2UEvyw6gsfmBrFnIx8fRA3POuOWUg7ELJlE9zacELg1GRn
	 tJfqH9RumBvDtS/jbZpWXIvoudBTDqa+lN/wftmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 001/113] dm: add missing unlock on in dm_keyslot_evict()
Date: Mon, 12 May 2025 19:44:50 +0200
Message-ID: <20250512172027.755420206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 650266ac4c7230c89bcd1307acf5c9c92cfa85e2 upstream.

We need to call dm_put_live_table() even if dm_get_live_table() returns
NULL.

Fixes: 9355a9eb21a5 ("dm: support key eviction from keyslot managers of underlying devices")
Cc: stable@vger.kernel.org	# v5.12+
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1242,7 +1242,7 @@ static int dm_keyslot_evict(struct blk_c
 
 	t = dm_get_live_table(md, &srcu_idx);
 	if (!t)
-		return 0;
+		goto put_live_table;
 
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
@@ -1253,6 +1253,7 @@ static int dm_keyslot_evict(struct blk_c
 					  (void *)key);
 	}
 
+put_live_table:
 	dm_put_live_table(md, srcu_idx);
 	return 0;
 }


