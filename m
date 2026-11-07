Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062772;
	b=a+el3Hx015BEnF/tOMex0MfzU4ra61LeZoM3J0oWktm6PddYAnI7Igrxz7aAWRgkoyz9
	 igGNX1jvjzkE2Vqr7figg6eT5nuihrcovxtPc4MJg/eUrQC2Xjk+LDAnW30ZNDq1mSaSZ
	 bFsgi37/GuNAfGNAB4dDtGp2LNerIm3EwRpBjxO54vXDr0nc1lhm1xyiSx7R49H9iiw/8
	 Xr8RCYsRjppP0Wum6tkMPZ4f4qqbTgS3ssBBgYhoi29P8Vus4KmHryXclcVe20hF8FXdL
	 hKFC5XPEnRXdyIpvvD59u8XVPDT6ljzj/qVgLL0zH3KQpBVoR9xEP6FwBfjtNRsgjfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=anh11rJJCCGiX6ThgOZvpr1RPh7QlkV2BLD3Z1gg8x8=;
	b=NGfaDzgrDBn1LOF8uTfEGciPThLLBSbaoUOyiM1EXYO3o6bdteTSvqqhmNdpbuN5gN7G
	 ykEuq4MZVPiS2xUQrG/SjnBkCcrWyNG5rCivoBXjDx+7ZNEE1k7fLCBnELuv+CKBJuhYR
	 iUNCz1Xqff7vWvjUWEufTIhvsUpKC4JfQYEOZt7lr+TEi1kLeGDTz9oTcG+aQdWqveT56
	 9iNDnY0t882KOsK9T855v9ysaRLFwRrHrHEgBapH//Wv2DI7HmsJGtZSkR/qRFWXQBx0w
	 AjilfYBmCvptXwopltwgNfrsUrjDRfyXAe8q2PSfOjIr9MPpWqcjfzyeOv0l4R0y4qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2JBz0CzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76BD606A32C;
	Sat,  7 Nov 2026 14:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2JBz0CzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC711F008A2;
	Sat,  7 Nov 2026 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062771;
	bh=anh11rJJCCGiX6ThgOZvpr1RPh7QlkV2BLD3Z1gg8x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2JBz0CzWY22vg8ojc+BnIY5EBkadHaU/UTWlzrWr2G4h+LVcET1ScUH2pI7HaA0La
	 TJcAnTQnvFp3zEX5g6MODioZppeDw16COgiO76QkwdacQBWJhCY1YuqwokiYh6Huds
	 CoP1PEDrI8e62F/nqGoRFHY5P1Yp5FzJcDrAHv6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/869] firewire: core: fix source bus ID detection for AT context in big-endian systems
Date: Sat,  7 Nov 2026 08:46:01 -0500
Message-ID: <20261107134855.405387149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 6393d75914a6ac95a05621db8d9d6a98eafe72f7 ]

The source bus ID bit in AT DMA context is not detected correctly on
big-endian systems because the little-endian data is not converted to
CPU endianness.

Fix the bug. The helper functions related to this are never used in
driver code, so extend the test to check the field instead.

Cc: stable@vger.kernel.org # v6.12
Fixes: 8db9d1557122 ("firewire: ohci: add static inline functions to serialize/deserialize data of AT DMA")
Link: https://lore.kernel.org/r/20260908122840.2886621-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/ohci-serdes-test.c | 4 ++--
 drivers/firewire/ohci.h             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/ohci-serdes-test.c b/drivers/firewire/ohci-serdes-test.c
index 258f668619ef1..87b136e041de3 100644
--- a/drivers/firewire/ohci-serdes-test.c
+++ b/drivers/firewire/ohci-serdes-test.c
@@ -43,7 +43,7 @@ static void test_self_id_receive_buffer_deserialization(struct kunit *test)
 static void test_at_data_serdes(struct kunit *test)
 {
 	static const __le32 expected[] = {
-		cpu_to_le32(0x00020e80),
+		cpu_to_le32(0x00820e80),
 		cpu_to_le32(0xffc2ffff),
 		cpu_to_le32(0xe0000000),
 	};
@@ -56,7 +56,7 @@ static void test_at_data_serdes(struct kunit *test)
 	unsigned int destination_id = ohci1394_at_data_get_destination_id(expected);
 	u64 destination_offset = ohci1394_at_data_get_destination_offset(expected);
 
-	KUNIT_EXPECT_FALSE(test, has_src_bus_id);
+	KUNIT_EXPECT_TRUE(test, has_src_bus_id);
 	KUNIT_EXPECT_EQ(test, 0x02, speed);
 	KUNIT_EXPECT_EQ(test, 0x03, tlabel);
 	KUNIT_EXPECT_EQ(test, 0x02, retry);
diff --git a/drivers/firewire/ohci.h b/drivers/firewire/ohci.h
index 218666cfe14a5..63ccf2f445045 100644
--- a/drivers/firewire/ohci.h
+++ b/drivers/firewire/ohci.h
@@ -178,7 +178,7 @@
 
 static inline bool ohci1394_at_data_get_src_bus_id(const __le32 *data)
 {
-	return !!((data[0] & OHCI1394_AT_DATA_Q0_srcBusID_MASK) >> OHCI1394_AT_DATA_Q0_srcBusID_SHIFT);
+	return !!((le32_to_cpu(data[0]) & OHCI1394_AT_DATA_Q0_srcBusID_MASK) >> OHCI1394_AT_DATA_Q0_srcBusID_SHIFT);
 }
 
 static inline void ohci1394_at_data_set_src_bus_id(__le32 *data, bool src_bus_id)
-- 
2.53.0



