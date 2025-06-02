Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4203C1465A1;
	Mon,  2 Jun 2025 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874802; cv=none; b=ckJTNi3AOScNVITLQV5aOAOm/AYKpSjJtCTlftVOwUOm0jKABMN1nP14HCN/jzatDum4wNhzLaSjHcJc5Yw0ylo8SSw9+rxHyCPN7MWMlg6nv8Yd+EgNR2pNGzpBahCAE1JATlxnlILhzv76IrLrDG/JTOubpxhpqK5jEH5WwP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874802; c=relaxed/simple;
	bh=aC9nfvJ1mOuRCClABbt9VBw6HcHUM3WFkK4h28RDxag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkoheNKFSVGdDitxcAvrD0USBSuwi9EGIu0qQPeuC8Aj1I+mZfe+vWDO4bq18edrZb50yxnq2Q5TFO9qOnfFUnNt/192BUe/cdJQEfcnjQkRKNTRWXUR+6WBssxT/xcg3jxC7LfcFdNuHH1DdLntm6i8WHYX8/Jm9ldZyHC93IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgN+qENf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgN+qENf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3302C4CEEB;
	Mon,  2 Jun 2025 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874802;
	bh=aC9nfvJ1mOuRCClABbt9VBw6HcHUM3WFkK4h28RDxag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgN+qENfzUN3hC2KkxW5Cc7Knnz0ra+cONvct+NgG4F4yrvUvpR5k0pacuUbyiI3Q
	 sEblIzrtkL7sUMWbxUiHzMfXkjv8ZYevk3X03dAyufmSheOvGSdCFQAX4dMe0AeO/Z
	 UzRi1R2p6uw3Uie9zOY7UleNUlJ88jmw/Gkd1rTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/204] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  2 Jun 2025 15:47:22 +0200
Message-ID: <20250602134259.946113222@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a56d03eefb83c..7002846afb308 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -742,6 +742,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	tgt->type = dm_get_target_type(type);
 	if (!tgt->type) {
-- 
2.39.5



