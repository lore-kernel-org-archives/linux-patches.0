Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981AC296D28;
	Mon, 12 May 2025 17:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071730; cv=none; b=KJFIKUHiXqSkxZ1DheJ2ihOwUwYHXYAJLOMqKrv7gYtswzmpD2e3SCNVpb2LNN+5h+Up58eTuNnHg4jnycHaMh/N3p9dAbQj49fXwBNkWZcPtaKSQCLOzgU2LnI6ZO6GL1OE6ZGhQu++dpn3TQ7zmsGriEI65ct0ZVF8LVziGgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071730; c=relaxed/simple;
	bh=lPxB28wvxhbUyNysq6fw/77elCGJiflI9V0aLlhPFRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO25HMOkhe21hc8XZDgjNFEG9H9uYtzU6R5HecUhxj/vt/QJiHFtcor7APXy5+5zrjQ3Tizhj56ap7boHC5W9iBXg6MOclD4yb4UHz3GJw/IqXc1iGWRTzj6q7OOljwcWxi0uHoDCjwjn92R3YnT1104WrhCocVJS0Cj3ojksok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPosB66k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPosB66k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66CCC4CEE7;
	Mon, 12 May 2025 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071730;
	bh=lPxB28wvxhbUyNysq6fw/77elCGJiflI9V0aLlhPFRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPosB66kF3/xJQR0MHTAFNHjNoXGq382qa182XMWVu5Xgqhy3zCoz5/m1xZsxzq6x
	 IqFCIUhONou27867tqT5+vZOKYQkmYZc2yinDgi+/8PpTZF1PQ29RCh/UsecsZid5l
	 MOspQP+/04qXw3ohaT1Np6huuyM8jZ19/5Nk1Sis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.14 001/197] dm: add missing unlock on in dm_keyslot_evict()
Date: Mon, 12 May 2025 19:37:31 +0200
Message-ID: <20250512172044.399506123@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1178,7 +1178,7 @@ static int dm_keyslot_evict(struct blk_c
 
 	t = dm_get_live_table(md, &srcu_idx);
 	if (!t)
-		return 0;
+		goto put_live_table;
 
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
@@ -1189,6 +1189,7 @@ static int dm_keyslot_evict(struct blk_c
 					  (void *)key);
 	}
 
+put_live_table:
 	dm_put_live_table(md, srcu_idx);
 	return 0;
 }


