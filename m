Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC6F4FDA59;
	Tue, 13 Oct 2026 12:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894832; cv=none; b=r0KAzWStTnpwiHFgRYpQqcDFuwEoGU2dHjRmOAX4SF2SRxOU306N6y81G1O1/8iZNVZORlsJahBgZ3v4mtfBmdGVYyBVZDhlUXoBeBa+CqXFPbM/Jdl0FCGbFx/HKbosOa2cc/cwsz+q2FYxe127rLrKANU8J6AuqKCWKqBRQJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894832; c=relaxed/simple;
	bh=I/uUvKBTFrLP/HzkOhRTB1RcVCJ5yfWG70ax0ndJ5Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pB7QmZjNUm5DuRId6WwT9lbNJlBp4Xa/ArI3VBm8end/01Fw7a/3PozUMcZQnxQrDEdWFdqUv8xLlYxEE7MiBgrhXs6rGmhl6/peBIz5P8QCdh5p1Gr0rp60xrGfqaM0V7SBev8Y3uzoNvs+d7T+BxpgJmK71aKpOLQlRSWgfmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwHGgrJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwHGgrJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370F81F000FF;
	Tue, 13 Oct 2026 12:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894830;
	bh=1ZdkbcuBEEWcTYso4wOlyDBHa3fyg9UtU86mjUxrq7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwHGgrJMQNtqCd3cWUahEz5Ht2hTgnsBknJcdFkJjpR6xo4vdmt+vB327SRhk2KYj
	 uogesI96R9D0tSibcH1r9LfZsVcqCnVelt1+AFZgnkIcl6CLD7/vsGr1MZgWkhU4wY
	 +az1rIv7zB0Kj9/5PeqndzQch4JE5NAR4ZN8pTi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/497] Bluetooth: btintel: validate DDC record lengths
Date: Tue, 13 Oct 2026 13:33:57 +0200
Message-ID: <20261013112909.546673375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>

[ Upstream commit c9c15d4d8956df8c564f7c210e4dc5b9b820d97a ]

Parse DDC record lengths in unsigned storage so 0xFF does not wrap.
Reject records smaller than the mandatory three-byte header, records
exceeding U8_MAX, and records exceeding remaining firmware bytes before
issuing Intel_Write_DDC.

This issue was reported by Claude Mythos.

Fixes: 145f2368c5fd ("Bluetooth: btintel: Add Device Configuration support")
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index daec8a65c4915..d60756a6968c7 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -387,8 +387,16 @@ int btintel_load_ddc_config(struct hci_dev *hdev, const char *ddc_name)
 	/* DDC file contains one or more DDC structure which has
 	 * Length (1 byte), DDC ID (2 bytes), and DDC value (Length - 2).
 	 */
-	while (fw->size > fw_ptr - fw->data) {
-		u8 cmd_plen = fw_ptr[0] + sizeof(u8);
+	while (fw->size > (size_t)(fw_ptr - fw->data)) {
+		size_t remaining = fw->size - (fw_ptr - fw->data);
+		unsigned int cmd_plen = fw_ptr[0] + 1U;
+
+		if (cmd_plen < 3 || cmd_plen > U8_MAX || cmd_plen > remaining) {
+			bt_dev_err(hdev, "Malformed DDC record (plen=%u, remaining=%zu)",
+				   cmd_plen, remaining);
+			release_firmware(fw);
+			return -EINVAL;
+		}
 
 		skb = __hci_cmd_sync(hdev, 0xfc8b, cmd_plen, fw_ptr,
 				     HCI_INIT_TIMEOUT);
-- 
2.53.0



