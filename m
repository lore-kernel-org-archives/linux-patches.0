Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4168C46D088;
	Tue, 21 Jul 2026 18:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659007; cv=none; b=fe5MpKm/FXMn4VhIAQj6nodCBz/+va25OueOrVQ2cZfHcyL7Pw4ujmwrjjsasK+fQNAQ7MjvwK+FSuNSQ0JEfwjeMAldzrogmNDHU3iPq/Yh9JBZ1a3llVyBxyP1BS6qL4wX1lqKgj76KX0t5ilaSJaDJK6Od3W3gtpUdzOfT14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659007; c=relaxed/simple;
	bh=5Cpl+uBS2Zk4a4KuMsnMNkZ8gbvQBwi8dnQPXlhL7V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKk1XGn88rg6PHwXFuuD9EpssNY6j0gfX5FHwhvJrJnf6ssXOMPF9ABvkjF8nhkmwBZBDEUvVCpSLeBw2SMXw8axubx7c7GU226k/01yLBiyNUzfL8uUwhmU5v5wFm85AhuFZtY8mAlaPi2v3zp0xFBmucPPUeeEy1XXNXL9oXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSEDNllb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSEDNllb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAB01F000E9;
	Tue, 21 Jul 2026 18:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659006;
	bh=SnYlwHvsxspQW1/8oJimTLrqbxwSdKytP/S/lARIauw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSEDNllb0D7FAG2N90/CtkQEEuaUYl/HTOvljUpObhfiwR9AAoDQjBvhhmBYnnsPx
	 tb6cpUB5NbHx+wnWbaOHPycyyxygvUI3JAf+r9Kf6mphzriP3elkpZuX1UhGzzH3fl
	 Sb93un059gDhgU9UahAKxW14Fo4wXuJ5FglJfFYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1359/1611] dm-verity: fix a possible NULL pointer dereference
Date: Tue, 21 Jul 2026 17:24:35 +0200
Message-ID: <20260721152546.022212764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


