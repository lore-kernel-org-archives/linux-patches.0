Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65FE2222BB;
	Mon,  2 Jun 2025 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873310; cv=none; b=Yj/+EQpBED/qV9KZQ6KFgvmN+caetY6Av0nVJD4PrWh1+yYOWhNefZnFZhgJiLgTilC+aSSYWyxKIAwlDNT/eHbc9KzyB/DonZW+kE8yJzTEYY7eJGaR5tPOoqia61qHZdfBQSKkb7F7EZh6Enhy4QI3R72D6z8bbOcpZeAo9aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873310; c=relaxed/simple;
	bh=MlR30A5vB0HQY6Cel8K0Lx161K4ToisKs1c8l05+7fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCfTDHzHAmLAtGod/MX3M+UgEF24whGhAYI1ojERlITgwbaDxEkn68MJBGFTWba8+mznOsy9TB579Rad+i46YCNSWzLr/6Y98EguI10hDh2lUKIF5ln6dZ8yiGOPM42L6IEjYi7mJKBSqk3DelnkHGfKWwrrb6Sou2/pQNVJIHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WucCqPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WucCqPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203D3C4CEEB;
	Mon,  2 Jun 2025 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873310;
	bh=MlR30A5vB0HQY6Cel8K0Lx161K4ToisKs1c8l05+7fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WucCqPVWYtssFmDT4YTu5ga6Mq2Drv04siqwpOA2rHJ8aOzZ89QZky+KdjxE7MPB
	 iX6yJXxEU4b1gESVlGWwD5cLqOpUN60mKbIvw2/SI6KBkDdfHpamlmF/9ZINcjuvxQ
	 k/jgXjEihaol2W6q12EHBsByDDe4+zUbIabFSV24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/444] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  2 Jun 2025 15:42:45 +0200
Message-ID: <20250602134345.000835448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 45fc728515c14f53f6205789de5bfd72a95af3b8 ]

The devices with size >= 2^63 bytes can't be used reliably by userspace
because the type off_t is a signed 64-bit integer.

Therefore, we limit the maximum size of a device mapper device to
2^63-512 bytes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 7a33da2dd64b1..bf2ade89c8c2d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -669,6 +669,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	ti->type = dm_get_target_type(type);
 	if (!ti->type) {
-- 
2.39.5



