Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA36643F4AF;
	Tue, 21 Jul 2026 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672677; cv=none; b=nwkTr9FNrA4E79cUqb3am1I5h23iRpyeaQ5oD6daTXNetXObTd6JaVAl69ziFJH0yTLKK6knyNY//z3MPvG4XjsZkxjKOU5RhmKxl5h7nrws0DjZD4KDgWFIeNWVwDofV0nq6arhMguWpQRYVDpzeBm5hUlYlQRb5/aDnqUgfCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672677; c=relaxed/simple;
	bh=vQjWMsCt+QopG77ybgCdGuDDNVEYgq1X6OUhorsBFAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mk4EsOuz8P8Ao5GsaSX2nzMsPkGn6t/KJjCyU3L87ufl75DgOBRcBRDFnnlh1AmVfeMaX69s3F6Z3n/+yNCUuhfUjxeS0LHyRWy5w3N3968uuFCW4lbVi/mtEqOX9LpyVO0frXy8152h9E9hNYq3268csI70O+H9NZ2dHXUkTqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZocxV/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZocxV/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE31F000E9;
	Tue, 21 Jul 2026 22:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672676;
	bh=WYg0kiTOy73eMJ6z86fyYvfJDQw5HMyBVGeCr9GHy9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZocxV/kW2nm+XBKJgQHWhJdqVOj3s3vGVSTULRUs0j03YaKWr/kBGsMnC2tSVQyx
	 wFoMwIbsYsJ099WmP0W6EYLpbZ1hkvx7UgUUZ4HfoxcVNbydOjd5PDTpscDYCMNypQ
	 4sKRQQkV/2my+7gXjG7+dgaRpp/PgpuB14SKebE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 714/843] Bluetooth: btrtl: validate firmware patch bounds
Date: Tue, 21 Jul 2026 17:25:49 +0200
Message-ID: <20260721152422.111156351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -389,8 +389,9 @@ static int rtlbt_parse_firmware(struct h
 	}
 
 	BT_DBG("length=%x offset=%x index %d", patch_length, patch_offset, i);
-	min_size = patch_offset + patch_length;
-	if (btrtl_dev->fw_len < min_size)
+	if (patch_length < sizeof(epatch_info->fw_version) ||
+	    patch_offset > btrtl_dev->fw_len ||
+	    patch_length > btrtl_dev->fw_len - patch_offset)
 		return -EINVAL;
 
 	/* Copy the firmware into a new buffer and write the version at


