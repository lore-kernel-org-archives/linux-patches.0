Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F3E6BB5B;
	Tue, 12 Aug 2025 18:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024040; cv=none; b=Km8wTg/MhIitNZ+BoP/JV598Hz8Ktweg1Ra+Uji0hYSuxwhTSPI72/kZNX7+3tUoPRrM8+OwP01jtoe7Cjt9fTMpHQKGobpn7IS0Y4rGg16PtvTvXkaVbkVgQR5Fx+MKRAkqSXztjrAnXT66mJNLCpNuxgqeTJGn8ZpjfcYlkeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024040; c=relaxed/simple;
	bh=6Zb6s1IkoAiY89HJxipSwT8qAwaqFBEIvmSp0iQgBZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZosAx3J4zwUzZ3b9asxZNzRtLqKMPgMjLxh9Ug3UUbwhteu+ljpeDp+FuRALQhioNyP+7TEtGm2EgcyIbKe7DUFspalTLR1IqrldHHIxXOf+kvP3vaFwzvyDxmuqxVMZpOyEj+qUmnJE3YEZfX51Y4py672PBCkfBbLh4eN/yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2/W0QLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2/W0QLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D9CC4CEF0;
	Tue, 12 Aug 2025 18:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024036;
	bh=6Zb6s1IkoAiY89HJxipSwT8qAwaqFBEIvmSp0iQgBZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2/W0QLAwn3GN/mDMHb9q9NrOfL6AR3fIR4LU980Mz5Y+8dwcSyu3BQduHiZppctZ
	 T6P5NkXnD4t8gC/dPRhi8lPn2fpuqBNsPi0MOAC3lhMeWvvHI5SMS/zPZdvvAAMLvd
	 4/l0ZwaK8vIy22T0+tjuy9H2yQoUcbXx2bJcssbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 255/627] Bluetooth: btusb: Fix potential NULL dereference on kmalloc failure
Date: Tue, 12 Aug 2025 19:29:10 +0200
Message-ID: <20250812173429.020280991@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit b505902c66a282dcb01bcdc015aa1fdfaaa075db ]

Avoid potential NULL pointer dereference by checking the return value of
kmalloc and handling allocation failure properly.

Fixes: 7d70989fcea7 ("Bluetooth: btusb: Add HCI Drv commands for configuring altsetting")
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f9eeec0aed57..db27d28e8a7e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3802,6 +3802,8 @@ static int btusb_hci_drv_supported_altsettings(struct hci_dev *hdev, void *data,
 
 	/* There are at most 7 alt (0 - 6) */
 	rp = kmalloc(sizeof(*rp) + 7, GFP_KERNEL);
+	if (!rp)
+		return -ENOMEM;
 
 	rp->num = 0;
 	if (!drvdata->isoc)
-- 
2.39.5



