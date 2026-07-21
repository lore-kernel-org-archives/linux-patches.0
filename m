Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A751943B6E1;
	Tue, 21 Jul 2026 21:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670217; cv=none; b=nsaMrNHcE7C7ypODQtA5Fj5uur1iNGu5fOhqYvFBl3quKNAvQizZBjb1o3kivXmryJ/zMO09izLaSKwBL5vi7JI1AFvhSienlYJ26AayKvbEeJLrhBbS3+frRd4FTz2u0kzvmBRUN8wboLG07dEnWblZ02PguuGr4lZymdA31zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670217; c=relaxed/simple;
	bh=KNMdSGXvOECOgQddNcWQjgT2fEI43um5rhgb4NbFStg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRsOLenpFmgqUczDKbRj9Gokcg2WDCeobTTtlZuJTV3BnzevywyQXrYds8omYidT2ORoDAFnsBKAwRMLzw28p5s9F8pWmxVD2byIM5/k+TrmB4UgOPfhmAUsRs6AqgGZeRj2xTtATiTDrGnw8fIEWWp0E2ge1++LpMpUWVJ10Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC/4u8Jg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC/4u8Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EA61F000E9;
	Tue, 21 Jul 2026 21:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670216;
	bh=fpDCOY+pN8N7T7/MIi3h0RBCrtViIsV5ESaqUmfsMSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PC/4u8Jg4TLeWvqnTsYWu2AMGCq4Ci1Tv2s9h1VdIqwm2RX2qxdRZuhGj5R1sDAxA
	 +sfq0fnPJcNCxSp7SQNrOv+II5NiXjxaoi3mcngY0r4cCaqjZOM1USv+JCq/PPPxGl
	 K82aUy+Ru0pC+XiMq7Nb6EfxGoDl1z8LRVF3hhK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0850/1067] dm-verity: fix a possible NULL pointer dereference
Date: Tue, 21 Jul 2026 17:24:11 +0200
Message-ID: <20260721152443.559053249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit e72b793ae440f6900fb17a4b8518c707b5cd3e17 upstream.

Fix a possible NULL pointer dereference dm_verity_loadpin_is_bdev_trusted
if the device has no table.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-loadpin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
index 0666699b6858..9a64f575ae5f 100644
--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -70,7 +70,7 @@ bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
 
 	table = dm_get_live_table(md, &srcu_idx);
 
-	if (table->num_targets != 1)
+	if (!table || table->num_targets != 1)
 		goto out;
 
 	ti = dm_table_get_target(table, 0);
-- 
2.55.0



