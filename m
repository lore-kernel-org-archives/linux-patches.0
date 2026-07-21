Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A1B399015;
	Tue, 21 Jul 2026 22:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674494; cv=none; b=f0bb5LCrVyME9CFYDyiedviM6ILDQDkKRC9ghLS0nb7pDaPSxasjCWgVRwMztkBBPjtd+j1e8ZXNZRFfr7Px14aCkoldnWi3iBk0YsEuPWGI0gJ6y+9fRY9rHafh8m0CrccKWuZtoZp8eytxmvr0zQH5oZtTOLENXghIlxEXU9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674494; c=relaxed/simple;
	bh=sHM2KVebD4tSL8F1j3pvbH6Ufsw/KavypMH8UyY+ktg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGz0HFGI7isXDTwCN3x+EbA00O/KiQMhUiMvGo5Hdw1+nKjbc+SOraUCfKk6gA9mKAOnYsINQXUj4ZEiJrpxG/8dh/AEvtYsrESdAAN7c4xy9YLeCrjT4tWBYQWLM6E1zLukchOFLbqdJG3l8KRMjG/Hi2JYMk6u5Ykrmtz89Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hu58egXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hu58egXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657FD1F000E9;
	Tue, 21 Jul 2026 22:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674492;
	bh=b0feNeuVj3pSKiM0QomRFxZ58sR7Q1spSFrn3jBIB78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hu58egXA5fyvyeULeB8e5zdQ4KfZbogmxM6iOy8sxYVJvKAxpemXN+Rs4F6SSvGP0
	 3zRkq0E/RzXp+ol9M1m3ohjwhozcZzreVW2d3CNAbl6a2xo3/DcoTg+llsHCWoQ5by
	 kA4IxkavjIvQC14zk0ToMynKx8b20Cruq/WRqOr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 562/699] Bluetooth: btrtl: validate firmware patch bounds
Date: Tue, 21 Jul 2026 17:25:21 +0200
Message-ID: <20260721152408.387117313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit 609c5b04a28dc1b0f3af6a7bc93055135b2d2059 upstream.

rtlbt_parse_firmware() copies patch_length - 4 bytes before appending the
firmware version. A malformed firmware patch shorter than the version field
can make this subtraction underflow and turn the copy into an oversized
read and write during Bluetooth setup.

The existing patch_offset + patch_length check can also wrap on 32-bit
architectures. Validate the patch length and range without arithmetic
overflow before allocating or copying the patch.

Fixes: db33c77dddc2 ("Bluetooth: btrtl: Create separate module for Realtek BT driver")
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btrtl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -382,8 +382,9 @@ static int rtlbt_parse_firmware(struct h
 	}
 
 	BT_DBG("length=%x offset=%x index %d", patch_length, patch_offset, i);
-	min_size = patch_offset + patch_length;
-	if (btrtl_dev->fw_len < min_size)
+	if (patch_length < sizeof(epatch_info->fw_version) ||
+	    patch_offset > btrtl_dev->fw_len ||
+	    patch_length > btrtl_dev->fw_len - patch_offset)
 		return -EINVAL;
 
 	/* Copy the firmware into a new buffer and write the version at


