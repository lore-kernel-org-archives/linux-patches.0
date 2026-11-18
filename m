Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041014;
	b=BAn+dcEffRDwvIBgblreaDmvuFIYjgk2FbwxHdgM8l9M1bvOnm4gWydmPSfTCecGelH7
	 dVUbvVN+j3OtKH+LbcJ0nCrW99U/zBGWGtNceiF2jH+goxwJiGNweCo8csMSIhlqXb07T
	 fs8+46o1b8KT3TnL1ct8uso4UFPxb+bic/NgMCXAilUcqDHPeX6QDkPubnAVlkXzQLAXr
	 rIwURruZ5bBAjNmm4g8kJiHPIQw9sEXowoVM65wVl7q21AbQnN2Flyan5D0+TfBY0cYaX
	 1/eME8pNvm6m8hTqYvFalDZtznUIWPI8BIT67Vu1LA0aYQ1T9D6kDtguWvQdfWk6wcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oWIydfdAds1+G46tG0OQ4D3zZ/pWSDBT/XuMLKyluTg=;
	b=N2kwcSDf0a5Q+go12Pfx5Hm4si26jSBPQ1BQhfl9r1dWt9v+sVOFuSWwWftT6Ue5JKf+
	 VWE1Blj7bs9JXzpZ2oF5noVn6KOK3C/r0PqEUNLup2P6VDcYAPrA0kCWCAMlWAzugCBTV
	 BfCfkHleeIZYiUxa4d9N7HRGIrrLx9UszzS6t4/tsTKUkGEZLJ1IBK8VDVXmXxesO7o+/
	 YqZfMqZ2t+vaAmIcAZkEH7yQQwghv9EOqbkvvgYZ8C6+zrcmZwuHOZzMHyLY+RUsQA+YS
	 R7Qq7qapGpeZP6GllagwHdWEj2B27pbcIrtQAcmedkZHm4f4qlBGW1X//q+5Yb+TQVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOiX8Ccb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E99606A32F;
	Wed, 18 Nov 2026 22:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOiX8Ccb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80F21F000C4;
	Wed, 18 Nov 2026 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041014;
	bh=oWIydfdAds1+G46tG0OQ4D3zZ/pWSDBT/XuMLKyluTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOiX8CcbbRvrjduJ4Snv0bZ6VX/VsCOkGhHVxzuT5ZuzM0uYotNHO6L0GRH30fS0y
	 oFEartk19GlIvF7Q5lL1oJuNHoozAh3luDQwkyhUoXDxkHE90JRlzUwlNp7cmUkuMm
	 1GdepsBQJZ4rfY0cqSerVuavrunNcmrTMssq29PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2661/3318] wifi: mt76: mt7915: guard firmware memory dump write on disabled memdump
Date: Wed, 18 Nov 2026 15:54:43 +0100
Message-ID: <20261118150440.857791400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit decf5142c2d4c295684da8644d4cb93dcf956c5d ]

mt7915_coredump_build()/mt7996_coredump_build() wrote dump_mem->len
unconditionally, but the allocation only reserves room for the memory
dump header when coredump_memdump is enabled and memdump_buf_len is
non-zero. In the default configuration the allocation ends right after
the fixed header, so the write landed one struct past the buffer. Only
populate the memory-dump section when it was actually allocated.

Fixes: 4dbcb9125cc3 ("wifi: mt76: mt7915: enable coredump support")
Fixes: 878161d5d4a4 ("wifi: mt76: mt7996: enable coredump support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/coredump.c | 7 ++++---
 drivers/net/wireless/mediatek/mt76/mt7996/coredump.c | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/coredump.c b/drivers/net/wireless/mediatek/mt76/mt7915/coredump.c
index 5daf2258dfe6f..56d9b64ec6b06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/coredump.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/coredump.c
@@ -345,11 +345,12 @@ static struct mt7915_coredump *mt7915_coredump_build(struct mt7915_dev *dev)
 	mt7915_coredump_fw_stack(dev, dump, exception);
 
 	/* gather memory content */
-	dump_mem = (struct mt7915_coredump_mem *)(buf + sofar);
-	dump_mem->len = crash_data->memdump_buf_len;
-	if (coredump_memdump && crash_data->memdump_buf_len)
+	if (coredump_memdump && crash_data->memdump_buf_len) {
+		dump_mem = (struct mt7915_coredump_mem *)(buf + sofar);
+		dump_mem->len = crash_data->memdump_buf_len;
 		memcpy(dump_mem->data, crash_data->memdump_buf,
 		       crash_data->memdump_buf_len);
+	}
 
 	mutex_unlock(&dev->dump_mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/coredump.c b/drivers/net/wireless/mediatek/mt76/mt7996/coredump.c
index ccab0d7b9be47..d5ecac6b742a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/coredump.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/coredump.c
@@ -202,11 +202,12 @@ static struct mt7996_coredump *mt7996_coredump_build(struct mt7996_dev *dev)
 	mt7996_coredump_fw_stack(dev, dump, exception);
 
 	/* gather memory content */
-	dump_mem = (struct mt7996_coredump_mem *)(buf + sofar);
-	dump_mem->len = crash_data->memdump_buf_len;
-	if (coredump_memdump && crash_data->memdump_buf_len)
+	if (coredump_memdump && crash_data->memdump_buf_len) {
+		dump_mem = (struct mt7996_coredump_mem *)(buf + sofar);
+		dump_mem->len = crash_data->memdump_buf_len;
 		memcpy(dump_mem->data, crash_data->memdump_buf,
 		       crash_data->memdump_buf_len);
+	}
 
 	mutex_unlock(&dev->dump_mutex);
 
-- 
2.53.0



