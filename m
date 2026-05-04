Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBD03A7F4C;
	Mon,  4 May 2026 14:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903943; cv=none; b=h1cGGOYkTp0zlUfCnFmjn4+hjKmQCrrxNqF+36/pnIjTXhn4AgSFlqZcqO82vnJUdgsQxYmIoRafIsQ9ETLAHzIUbrcCZX7PFbaiPQ3QfDGxTFlcwVT+dEOhTP82PMXY4/wFxZVPyFLuwRNn4kPxEKJSkvJRQ/iE7mYJpyA5irs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903943; c=relaxed/simple;
	bh=tFWG3aFZkwG1kkH7YEok9cW4tyVw1ITsb9Qp7Q5PkTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmVVHRuG37NWW0dtFPobpk/AsyR/q+TOOu2jSsF6/sjGd9FIz9eMCsCjmNV4wSlnwSHn/NiJLxe3weZn2+TAHwq2HTC679oWzFzf1kTXfK9C0TyNG2Hm7ZKgS6lPddxbcKKTkBS+Uwux+eE7QGFT0UorTgHDC+DY0CjssfGUTiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcdLnUHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcdLnUHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D05AC2BCB8;
	Mon,  4 May 2026 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903943;
	bh=tFWG3aFZkwG1kkH7YEok9cW4tyVw1ITsb9Qp7Q5PkTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcdLnUHr5SqiiQ2OQQR7Ibcfji/QQwVXrbDhY/z+0uHjhA86xIt9IY1nuBeEeNvKj
	 31UWlRx3F5TF7PA7HhGrJus10pgNnsyNn/UxannVbeAycqCCMDbfHrQU9pKpNZ42O/
	 fsJ57jvlKeUGy7i1bYzxJ3+p5HtI9M3mfoDQRSu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 121/275] net: txgbe: fix firmware version check
Date: Mon,  4 May 2026 15:51:01 +0200
Message-ID: <20260504135147.399458188@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit c263f644add3d6ad81f9d62a99284fde408f0caa upstream.

For the device SP, the firmware version is a 32-bit value where the
lower 20 bits represent the base version number. And the customized
firmware version populates the upper 12 bits with a specific
identification number.

For other devices AML 25G and 40G, the upper 12 bits of the firmware
version is always non-zero, and they have other naming conventions.

Only SP devices need to check this to tell if XPCS will work properly.
So the judgement of MAC type is added here.

And the original logic compared the entire 32-bit value against 0x20010,
which caused the outdated base firmwares bypass the version check
without a warning. Apply a mask 0xfffff to isolate the lower 20 bits for
an accurate base version comparison.

Fixes: ab928c24e6cd ("net: txgbe: add FW version warning")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/C787AA5C07598B13+20260422071837.372731-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -867,7 +867,8 @@ static int txgbe_probe(struct pci_dev *p
 			 "0x%08x", etrack_id);
 	}
 
-	if (etrack_id < 0x20010)
+	if (wx->mac.type == wx_mac_sp &&
+	    ((etrack_id & 0xfffff) < 0x20010))
 		dev_warn(&pdev->dev, "Please upgrade the firmware to 0x20010 or above.\n");
 
 	err = txgbe_test_hostif(wx);


