Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74F0253359;
	Mon, 23 Jun 2025 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684712; cv=none; b=dE0s6eTW8nIxdo45gZuQsHWleQe7931wfjXtwBdOKRp13hkiJEgrsJrUMJ5iv1gDctM0cDQhpJknvkogrrcG5luDloTddoFRQmkaUYl3A7Z6zqbLBe01my9AEKgTrKzNQ315SkAB5rfzExPYOeBvens0iypn6jEDCVLMj++c6+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684712; c=relaxed/simple;
	bh=z816RUjwpWza+i4tMAkBFlQZv2ZBMigTUTjrlEyIhH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T09LG8lMkzlCxvR4C47Sd+/gUyTz/shWF/oCpBMwBT2VOvenDiDaD4E0T7NQQYjrokEBAdyrw2ZYH/BAQdvQjJhG5EI4Pfp8cLzBI3lGK+dksZNEfrpGsd4RpSTRkRGityyVYHPqaVWE42eXoZM5X24PYpzI6RUQ2htDtXWInZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ts7Pi9TP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ts7Pi9TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE8BC4CEEA;
	Mon, 23 Jun 2025 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684712;
	bh=z816RUjwpWza+i4tMAkBFlQZv2ZBMigTUTjrlEyIhH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ts7Pi9TP9yUf76tvwtBtKPJ4KK/R7L3HV5qKSvBPywSuf5y73gcSAMYuL7dJg8mzX
	 DpMboXBtGTwThLAxBgraszRh4RxfuCp+ZludfPs+p331nh0GZi9ep2DL6WsvoOZXSm
	 UowKyiUi6zMWH+aKCMnRUYCeJLPaFcmRCHCzix4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.15 158/592] dm-table: Set BLK_FEAT_ATOMIC_WRITES for target queue limits
Date: Mon, 23 Jun 2025 15:01:56 +0200
Message-ID: <20250623130704.036613877@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

commit b7c18b17a173087ce97e809cefd55e581121f19e upstream.

Feature flag BLK_FEAT_ATOMIC_WRITES is not being properly set for the
target queue limits, and this means that atomic writes are not being
enabled for any dm personalities.

When calling dm_set_device_limits() -> blk_stack_limits() ->
... -> blk_stack_atomic_writes_limits(), the bottom device limits
(which corresponds to intermediate target queue limits) does not have
BLK_FEAT_ATOMIC_WRITES set, and so atomic writes can never be enabled.

Typically such a flag would be inherited from the stacked device in
dm_set_device_limits() -> blk_stack_limits() via BLK_FEAT_INHERIT_MASK,
but BLK_FEAT_ATOMIC_WRITES is not inherited as it's preferred to manually
enable on a per-personality basis.

Set BLK_FEAT_ATOMIC_WRITES manually for the intermediate target queue
limits from the stacked device to get atomic writes working.

Fixes: 3194e36488e2 ("dm-table: atomic writes support")
Cc: stable@vger.kernel.org	# v6.14
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -431,6 +431,12 @@ static int dm_set_device_limits(struct d
 		return 0;
 	}
 
+	/*
+	 * BLK_FEAT_ATOMIC_WRITES is not inherited from the bottom device in
+	 * blk_stack_limits(), so do it manually.
+	 */
+	limits->features |= (q->limits.features & BLK_FEAT_ATOMIC_WRITES);
+
 	mutex_lock(&q->limits_lock);
 	if (blk_stack_limits(limits, &q->limits,
 			get_start_sect(bdev) + start) < 0)


