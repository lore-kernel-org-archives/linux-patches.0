Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA72282F03;
	Sat, 12 Sep 2026 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232329; cv=none; b=t6wOKjJNBr4AI3iZE0adE78X4b4xoe8Xvy+h5DUfZrf4Jn8dloc6AId3iIQPfzw03gXvLvTzr3qvaChjYSfoxu4IGEaUe/nIBqUs/B04EzlCC/dxjZwfOuokC3qIvifgkr3mKxZfzq0BJnhcNaAhrkAHzoaG+4HYURUqxrl2ors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232329; c=relaxed/simple;
	bh=KNAIntuKgaO6stNiSPwAaaAyRrspDSDpSAJeKiASmOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGgw5QoZ2spOrBmbCeCQaFiJIjVXpClp8DESCjz/k0TAlc4q5VlnwUGwby5ecxSE0D5Tn202Xe20lq1zYY3LAdOF/2iyHJbizYoH5bVGgDsqr3IU6UXmQ1IqbLu/ykIGnzX9XfxWH1X79xVX7kzIoYoG+wJeyCyFx3ATSWtzhOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=081lOH+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="081lOH+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537961F000FF;
	Sat, 12 Sep 2026 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232328;
	bh=knB2m7KdRjU8hMKByxpifnbJrnXBavQNT/ozOHTHmKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=081lOH+HQWnQpuCExdoLLo259FK+mYUOMkzj+Og4hJwJDlNhUAtjALR12vF2Dnml2
	 7sdKGEonzksY9c4S3JPwazyBVwZIxYxAkej5fSpUhy4lDZdb1AoWhp4lTAk7y5s8RF
	 wGrQFFajvXNp1uBRwNp+0JZm85H3xHbCMD+vuTRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1179/1191] Bluetooth: hci_event: Fix connection regression between LE and non-LE adapters
Date: Sat, 12 Sep 2026 09:05:07 +0200
Message-ID: <20260912065614.620226896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>

[ Upstream commit f6685a96c8c8a07e260e39bac86d4163cfb38a4d ]

Due to a typo during defining HCI errors it is not possible to connect
LE-capable device with BR/EDR only adapter. The connection is terminated
by the LE adapter because the invalid LL params error code is treated
as unsupported remote feature.

Fixes: 79c0868ad65a ("Bluetooth: hci_event: Use HCI error defines instead of magic values")
Signed-off-by: Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 403988938ea1f..fcab978894b12 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -632,7 +632,7 @@ enum {
 #define HCI_ERROR_REMOTE_POWER_OFF	0x15
 #define HCI_ERROR_LOCAL_HOST_TERM	0x16
 #define HCI_ERROR_PAIRING_NOT_ALLOWED	0x18
-#define HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE	0x1e
+#define HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE	0x1a
 #define HCI_ERROR_INVALID_LL_PARAMS	0x1e
 #define HCI_ERROR_UNSPECIFIED		0x1f
 #define HCI_ERROR_ADVERTISING_TIMEOUT	0x3c
-- 
2.53.0



