Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E3223708;
	Tue, 21 Jul 2026 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654842; cv=none; b=qk6OMKJ4ZGri2T0I0HPSc9eablMaRgKb2A8OVn3sk28gwTf7wr0qFqCFVVP2ioYbXvgIPGF5+0L0d10MQ9XhXtoQ8FabifQdbhEl9wMt7xcDBHWhvLmC51K208HgSQ7zVBlEShskt6pNsIisR58Dl7gC1OHNrM7+QLBXb2QTwTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654842; c=relaxed/simple;
	bh=9hy3XDSlnu801GXRa9o1nIFWYUvVa6LIf00VYhIz9nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uD2scVETboX1P92E+PCrhY2JAWqkzAGHsbhC5aC9hiZ72lHCwk7uLpfDEwsA9VNA9nbMxmD1A03h5uLsV0eWkCOM/dN+E7AHNJ9pw8jPOrBTcOqrRrwvZrXOt8xqwGddSMsZQmg5XFwut1xDPNxs1B05yMD/qwsc8Xd88E2ybO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnkI9Zdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnkI9Zdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081741F000E9;
	Tue, 21 Jul 2026 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654841;
	bh=Vj3bzX1jG3wCJzSqQB6hgfB8Urkzbx4sTLUAMhjbBJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnkI9ZdnyJemFcaVyoPuKV9314Ga4KpCBt5ylNh/nwmGdy2PTj7vxLKDFrmJyc8gF
	 yq4bP7SHzbfa8T09arzDvUgfr9g4qiYvD2/VifSFH3xjZvEBYZ1cuJC/1SYmSZRmfk
	 ARfXINUwo0DF+NHERfcFgt4DU8rph4aC/UI8w4yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1859/2077] dm-verity: fix a possible NULL pointer dereference
Date: Tue, 21 Jul 2026 17:25:32 +0200
Message-ID: <20260721152636.582637952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


