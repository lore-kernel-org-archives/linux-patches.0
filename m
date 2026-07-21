Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDCF415F15;
	Tue, 21 Jul 2026 19:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663944; cv=none; b=mUGkrEFllAcwtmXiOR5qG4OvVWokbBT/bow0rDdPcul1xhQlQmkTxT6g4FbqmlS4QjS0cKcbpaQhT6WF72D+oXdB/xtmZPkkaEiZf4dGW5LAt3lLzwTAFCf043nUA7yrSB1uP2G0mv+MCeGeT8lNWplMTDSEz7ggRvOMqOjiAro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663944; c=relaxed/simple;
	bh=cRYWqbAFV/FecKj3yro4lQDLy1CD43DRHO9IZlOafio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrKHCSs/OsvpALAZcHBOYU44A5ZuBVaKgEYExOiyEFq9jqx0kW1OWm8CNDqzhtd+8zzQan3DxxbfjNyt3JVTuEbjytTWcxRMg+hbE58LKo4PL16r1ykp0X3OEJ97HlKl1EBXU1uiagB2HKBIBGKFq95jDmyi12Oh3R5FOi5d8To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEbXt0uA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEbXt0uA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B391F000E9;
	Tue, 21 Jul 2026 19:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663943;
	bh=RzgcTF699uudPOfetqvsgkpyYZgd8I9cDnx2/t2MRn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEbXt0uAsOoSG8GRrhyiEQDDjTSJUiDJorhv8PaRT4tkyb9Mxa51cFCHCl+ItEYS7
	 y8ycpJZitBVv1gvP4I725176QxoOj0SzQKcLUDoZCViTXvU/pxsfDM6c2lxJJxWhh1
	 +ONv17HdTNijRKvxV2WT+2I1EJuOMdA71O2x4kiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1012/1276] dm-verity: fix a possible NULL pointer dereference
Date: Tue, 21 Jul 2026 17:24:15 +0200
Message-ID: <20260721152508.651196093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
 drivers/md/dm-verity-loadpin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -70,7 +70,7 @@ bool dm_verity_loadpin_is_bdev_trusted(s
 
 	table = dm_get_live_table(md, &srcu_idx);
 
-	if (table->num_targets != 1)
+	if (!table || table->num_targets != 1)
 		goto out;
 
 	ti = dm_table_get_target(table, 0);


