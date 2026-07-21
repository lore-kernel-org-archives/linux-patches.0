Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A64414A27;
	Tue, 21 Jul 2026 20:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664319; cv=none; b=N4sN1TnzmYmeI6R/7kMDkIaU5NfuG53kpVTz0tjxubxhwl8DHejqmc3WV5H5cIAeoDdlOX1KrJ2E7VU4YRIZ78BM3fHjtY4ynpIH9zXt0zk7JBEl83eJqXkGI3MXqb3nUrHfl0YNNq6OaYKSM5CtZ9SR931S2nf/sQ7uDLG7dJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664319; c=relaxed/simple;
	bh=4g6HChs4X4poCKohgjEoGEgFGY31tdUu6eYkWf7VwjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEWm5HddqDipW4Md3K/o0Dv7xsCmnPhXirlUjPMhtrWZik/XBWMn+UiHy8w8gdqwik8RCkokY7eZ6XPZtzUKGKWnQ2q6LHeM9au37JaA2rZxxTRybsX+yuBKc0yYOujfsud/1k9+695vGwTONNCfaAqWsHG7vaSlziFSWJ8P4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDXdgxIt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDXdgxIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72D81F000E9;
	Tue, 21 Jul 2026 20:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664318;
	bh=lUUO/snfIinzuYrGWaaGneoh2ejgvIxic8bobl39VxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDXdgxIt/DotU3mRyp6ByppyZzD9gP5lZYlN1fvhhfqDjD1fD6DFkcgyh400rEY8j
	 1oNuqYj7dsI20qPpfyfCAZP4OQlBlA96zSrtcFtLZvSWwTttzLJu3cjz48VPXNHvvi
	 aY3O43ru1EJoiJFkfuNa3lWGpIXSB4dBfdxtmEKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 1112/1276] Bluetooth: btrtl: validate firmware patch bounds
Date: Tue, 21 Jul 2026 17:25:55 +0200
Message-ID: <20260721152510.879618800@linuxfoundation.org>
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
@@ -786,8 +786,9 @@ static int rtlbt_parse_firmware(struct h
 	}
 
 	BT_DBG("length=%x offset=%x index %d", patch_length, patch_offset, i);
-	min_size = patch_offset + patch_length;
-	if (btrtl_dev->fw_len < min_size)
+	if (patch_length < sizeof(epatch_info->fw_version) ||
+	    patch_offset > btrtl_dev->fw_len ||
+	    patch_length > btrtl_dev->fw_len - patch_offset)
 		return -EINVAL;
 
 	/* Copy the firmware into a new buffer and write the version at


