Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312A119B3FF;
	Tue, 15 Oct 2024 11:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993507; cv=none; b=Gs3YOBivoyEYLmElJF2mPtj0ip1Xp8kQcv1PzL9IXJLUnj4nEkMGcxH8JXJ5fOCBEiDDX4iRmEquF1isd3YMINBZIaJ9JUI+0vTiXvlLU4cxwyMM33k/3J24WZUX3qFzABFa6UUf4vZQ++xyeI5oaDLmmIc+16lcWQNhzlwY2Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993507; c=relaxed/simple;
	bh=446qFUrizXwT+qdZurilIssI/zpm30N0CRkjETrv6ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbCXY8cCVz0MZntmxpl4tKbJoBnHP+ROFSxbZLcPCj24qwD1ITZ3KojSWnmfwqZypryx3+5/93A5lf3RQk+F1J/5TLg11b4US46VlVPt/kHdUvRTJTmYShp4iXdLk/HeWdvqcQTFKAI9Zkh3VamlScvKzvletsTreM/tQ+Kc9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJpIorXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJpIorXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD58C4CEC6;
	Tue, 15 Oct 2024 11:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993507;
	bh=446qFUrizXwT+qdZurilIssI/zpm30N0CRkjETrv6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJpIorXntX92rmHTUZq1qSnrbWsaV62Gmq1iChF4/+acrnu2HUcIeIm1FHdzSELZF
	 qwlM+nHvmYmC0Y19tbYL5NoWJSsx3+MDGSzIvH3VMpt7wDQE3DFudOuYngZb/11Lf7
	 l1ev/zxnoG1jRxJUE0j0DvhcNmmKCteYo5+zBFiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 433/691] wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_cmd_802_11_scan_ext()
Date: Tue, 15 Oct 2024 13:26:21 +0200
Message-ID: <20241015112457.528137630@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 498365e52bebcbc36a93279fe7e9d6aec8479cee ]

Replace one-element array with a flexible-array member in
`struct host_cmd_ds_802_11_scan_ext`.

With this, fix the following warning:

elo 16 17:51:58 surfacebook kernel: ------------[ cut here ]------------
elo 16 17:51:58 surfacebook kernel: memcpy: detected field-spanning write (size 243) of single field "ext_scan->tlv_buffer" at drivers/net/wireless/marvell/mwifiex/scan.c:2239 (size 1)
elo 16 17:51:58 surfacebook kernel: WARNING: CPU: 0 PID: 498 at drivers/net/wireless/marvell/mwifiex/scan.c:2239 mwifiex_cmd_802_11_scan_ext+0x83/0x90 [mwifiex]

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/linux-hardening/ZsZNgfnEwOcPdCly@black.fi.intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/ZsZa5xRcsLq9D+RX@elsanto
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h   | 2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 29140949c01ca..7779a3a139446 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1598,7 +1598,7 @@ struct host_cmd_ds_802_11_scan_rsp {
 
 struct host_cmd_ds_802_11_scan_ext {
 	u32   reserved;
-	u8    tlv_buffer[1];
+	u8    tlv_buffer[];
 } __packed;
 
 struct mwifiex_ie_types_bss_mode {
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 5ec8a42e7150a..293ad1e68cff7 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2560,8 +2560,7 @@ int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
 	ext_scan_resp = &resp->params.ext_scan;
 
 	tlv = (void *)ext_scan_resp->tlv_buffer;
-	buf_left = le16_to_cpu(resp->size) - (sizeof(*ext_scan_resp) + S_DS_GEN
-					      - 1);
+	buf_left = le16_to_cpu(resp->size) - (sizeof(*ext_scan_resp) + S_DS_GEN);
 
 	while (buf_left >= sizeof(struct mwifiex_ie_types_header)) {
 		type = le16_to_cpu(tlv->type);
-- 
2.43.0



