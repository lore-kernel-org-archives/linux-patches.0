Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B81442E8D6;
	Tue, 21 Jul 2026 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667627; cv=none; b=Z1sKINIdrUFiTpUWpxImgzPWhNaQ7p58Jno6RmnkBP8CIOxy1G3npUGPtXDnseHL2gSSdwI3XCaTO4ZmDjQ9fmbmP02+bZGX2wAwz1viqtBuFLzu7mbYsD7J0UDEAC1lEGQzM0QhzPdum4J9yXDAdZLbK8FubLzcHPZrjpyvGvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667627; c=relaxed/simple;
	bh=dHeqByWGxc2d38mnR5rJZVjqL1ftCrfWCf5TUM9f7K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hirree9VDvB6B8CubhlY6qDmysyPeL7fkHXyd6T2GpEu+ryaiAXTWnTsovQk8aHV9XLK2Agzenmtr0+igMrr2DYEJYDpXi41W5I5w0zEGysGrt9ssQ0wc8atGA+Kd0HdGRy48Lk7CHBxv+q5RWCOu9T2Sz7/021Q/8a4L5XbYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb/1Jaqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb/1Jaqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718B31F000E9;
	Tue, 21 Jul 2026 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667625;
	bh=ipzq6v8raXvP/7JaOG57JqSEqa2LnW4f//3n/jX8NLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cb/1JaqfqnMcPYGMU2m4Vkvmyaz90Tc7wL8ORUizLsyAs5Wr6u0ct80LhTf6wxmSu
	 x7oLczqS0L6uXj9yPx4Xtm9rwoaNMgVgTKBYVlwR0v9yZioM0cUtk+jg2Ju8qrHNYW
	 m/lZjCmh9Pe3hHqvYeEtCVMeRqHuKuTqPk5OFdR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1132/1266] Bluetooth: btrtl: validate firmware patch bounds
Date: Tue, 21 Jul 2026 17:26:09 +0200
Message-ID: <20260721152507.127355972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -763,8 +763,9 @@ static int rtlbt_parse_firmware(struct h
 	}
 
 	BT_DBG("length=%x offset=%x index %d", patch_length, patch_offset, i);
-	min_size = patch_offset + patch_length;
-	if (btrtl_dev->fw_len < min_size)
+	if (patch_length < sizeof(epatch_info->fw_version) ||
+	    patch_offset > btrtl_dev->fw_len ||
+	    patch_length > btrtl_dev->fw_len - patch_offset)
 		return -EINVAL;
 
 	/* Copy the firmware into a new buffer and write the version at


