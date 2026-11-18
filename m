Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018932;
	b=WKtDPYyL0LkZkd6C8qCZKF7Ids2gabqsKos9FJeWG2dRnVa9K6IH3P0WKhpUGmkmAKHk
	 M6oN4JjMWryCLiHFgOOlAalvf2G4HAcI4Qv7UD/JYOOnQoN3toZc+HIjGcX/sTy8wEUbd
	 UzfXoPau6cwFOlOu/xzmrmcuTutwk7VQiRMh822rjTaNgjMwCjXU0MavLYb+VnWmIHnKr
	 5ED4MI7qmQwKa1H1S6ikKtwZQdF53pbX4cPBbXK8TAUfDy5sKhTAPzxoSwkxtZ0FaUxM+
	 0FCZkdpvGiWe/SieYEcmkBSvXh+aku37UbNJO0D3fVF1rjAFyRWTftZ9sSPHew6ugbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6zd/ma9PBdMMsLnGXMOIhrl30+jz3gdZAm09sjGXhdg=;
	b=P34tMPWsOKdOvedFFtJyK6+tdmTv37yH+/fgIYMHf4InlmWkkl2NC1YJs8bynbOBt3yc
	 w0oX8hbVXHqaseHrSRRUuNdjrgCFpzZ5ikbLEW2l/eQbaqlsDSey9hbyoTFdkrtxTRark
	 9/B+GKn7tSsSu02h9OyA63SD35gTRiQRcNQMjGpR3w5DVQtrLZyCBTiY8gwkBabr+b03c
	 nYuQQn4o+v3CAgi33XLWZ7tWEFZPlIouBhb203wqA2ZPj2kdZLvtkvgUIsc1pR+HEsbHt
	 64/9un/Z5k1YHEC9YcNB35cyg+rO3JIvjZnWmzVLn7BFffaAdrFMf10SOtrY6OUZOzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoFXjd6o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A28606A325;
	Wed, 18 Nov 2026 16:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoFXjd6o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD01F000C4;
	Wed, 18 Nov 2026 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018932;
	bh=6zd/ma9PBdMMsLnGXMOIhrl30+jz3gdZAm09sjGXhdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoFXjd6o9SiQ32x5+w5z7y5twsXUaX/61LHqF+XOk2OXKNpJofxiX69N5puBlnGEd
	 7alypVq0tCpEgOlmN+cxZgaMdW66BdQ2+IJWGgWoMwjtw7Bj/JsBzT9lwTPr12PqnT
	 A3E9q3b3YKpgW52/lLvhWVoen238do24fN06qofY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1416/2651] wifi: mt76: mt7915: guard firmware memory dump write on disabled memdump
Date: Wed, 18 Nov 2026 15:44:16 +0100
Message-ID: <20261118150338.995278121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6c7273e5b0bc5..db079b274a935 100644
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
index 5c293ae965cd6..be4c882b3184d 100644
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



