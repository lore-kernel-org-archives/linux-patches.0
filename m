Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEC946DFE9;
	Tue, 21 Jul 2026 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655247; cv=none; b=u5lc6LJSYExpvS1JklksAfS6sR2ovK/shBTuisKgAYuSWdC5v5A4WNYGYSHqHerotjbZBsY/H2ewslUXPiVWcN6Hx5nmtLpBPjHs9pqKCqfzARVuhPOHo04zQBIQLsRrUaJhOwoPavw6BYIvfaeLuTWrigXB3n9gNkGNVpAxdHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655247; c=relaxed/simple;
	bh=PotYU0UvXw7ew+bJGbrFKKs2T/emw6LsdNaw6x+K0js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQqbx0ky+VLP6t1kA1p+B0sBMv1h/y4yN24Ds/5n8XDbtt6sKvVIRNQKn+zJVYDF1TJS2cz6O1p8bcEdD6JKr2NO5S4COmiyXct/VJu/mTCWaOKI373/a1N0C8Ud30z78vOIYKk9BEK4oeY8hkxLySK8Xl7XsaD3MOn35Ea/GE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeNrF7a+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeNrF7a+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE621F00A3A;
	Tue, 21 Jul 2026 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655245;
	bh=zwQ0pNen/USVpPOzc/lOLO2mm89q1j6Kep7fvkAAFps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeNrF7a+ZdDQQhH+6j5YyDUZnLEIWc6IUntyJgl9ZJ3E5u5yETQzUq3upf4stqd3h
	 K0uLf8cX8X5XmzdBsbvbb4yAq8OJgiVo/VTRYmxhdYY6lnqqu6cyw7U+g3N06pQrTq
	 8czv1QAnBvhCPMP8OSubWMz6+l7QQlETlbkGyfUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 2011/2077] Bluetooth: btrtl: validate firmware patch bounds
Date: Tue, 21 Jul 2026 17:28:04 +0200
Message-ID: <20260721152640.138647435@linuxfoundation.org>
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
@@ -797,8 +797,9 @@ static int rtlbt_parse_firmware(struct h
 	}
 
 	BT_DBG("length=%x offset=%x index %d", patch_length, patch_offset, i);
-	min_size = patch_offset + patch_length;
-	if (btrtl_dev->fw_len < min_size)
+	if (patch_length < sizeof(epatch_info->fw_version) ||
+	    patch_offset > btrtl_dev->fw_len ||
+	    patch_length > btrtl_dev->fw_len - patch_offset)
 		return -EINVAL;
 
 	/* Copy the firmware into a new buffer and write the version at


