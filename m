Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5C023D7FC;
	Tue, 11 Nov 2025 01:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825371; cv=none; b=t8w1af6WSpR3/jt+m85ACGqYdYT4cRgZ11Qb47djnh7zNS3STrzpxDdcDQMUKgKrP6GQs5ibQF6Mbe/KBj4Yfdc4J+5mF1qAwEgief5Ian2MjWIXY47jTPhD7UAdwlFHGQ+YaFMgZsQ2YIfNAyjEhRxROH3bWPW81KP+gqJqy1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825371; c=relaxed/simple;
	bh=zELCRL1b3BaBKhTQvj6vn/eYTHhQHqdlo0L5OgOW2V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AohHSJC2PmFPJdIXw4ELfOfGRJ5RCY5AOTcAbEdZD7SCY8bJ8pDg36+qEEj56rWmdcytcTJpD72c+IIuhxwSYHpPv9R3FSCitYZMEdEs5cugpAkXBLJK5IEhFT1dNRtt/LP2LUzFP6ECmvYndhRdCZOPeRtI6lWypIvGuMklYyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlQ2CbId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlQ2CbId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7987FC19421;
	Tue, 11 Nov 2025 01:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825371;
	bh=zELCRL1b3BaBKhTQvj6vn/eYTHhQHqdlo0L5OgOW2V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlQ2CbIdXWwX2IAcxr0JOYL7+pGeqTeQVvWu3sU8mrFdp95fnuAb+5v97PJFfOLwK
	 VuCuoc7q2yw7u3HH4LrAs4TYxg53hAmlrLM+CahwVNhnj28qK4y37D0q8nONQTBTXB
	 lYeP9yChFFVlmrxQPjWN3dRbHRpYpDNOzIdrGKCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 757/849] Bluetooth: btrtl: Fix memory leak in rtlbt_parse_firmware_v2()
Date: Tue, 11 Nov 2025 09:45:27 +0900
Message-ID: <20251111004554.735778497@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 1c21cf89a66413eb04b2d22c955b7a50edc14dfa ]

The memory allocated for ptr using kvmalloc() is not freed on the last
error path. Fix that by freeing it on that error path.

Fixes: 9a24ce5e29b1 ("Bluetooth: btrtl: Firmware format v2 support")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 6abd962502e36..1d4a7887abccf 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -625,8 +625,10 @@ static int rtlbt_parse_firmware_v2(struct hci_dev *hdev,
 		len += entry->len;
 	}
 
-	if (!len)
+	if (!len) {
+		kvfree(ptr);
 		return -EPERM;
+	}
 
 	*_buf = ptr;
 	return len;
-- 
2.51.0



