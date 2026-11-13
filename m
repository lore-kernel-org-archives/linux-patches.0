Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585418;
	b=ToYoUOv0AWcTMVlViBkQ50CantRGTccVULaW7YEZEPN4T7taTdWIMHKZIGL7fuKavCpr
	 q3yfpXtYN5Fscq2oZwOuR69Sc7wJXswcbUwFBu3y2CqvlFFFn/RBZq3Ecr3iCwrZnFYGq
	 eWuXY5lWL3tYdZT5ag7TDJ5FglMvJOhi8tJqbooEL7bL5KRXkGbHarQDAI5yvYgm8FOhS
	 2E7nJx9JIq9etZhXdiyTU4Dlfxr/ZWj25mfNIr+UodJJnKgTPONkj3K+g+JvWAASir2L+
	 4gwb42Kggs8BG3qNl07CjuCpYtFlU+d229LTFjZr0v16sDnjC1mbWPXIFKm4KlPC2Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WDhunDChdlzPVf1EnDYMe39TWovfxFlAcN6Y1asylwg=;
	b=HL059C+aMSQLzqshrNQKsjwsQQipdC1wUcikcVaMqdVpXhXG1uYTMcM0c8Zw4MBPIfon
	 bUbIHBNSV5GdTyFfQ9gl0mdkxSanYi+NRYc3cgHY4kLC3rQD7gUk6EwMjKjRi3snfWY5j
	 yBKKVwJn18LWFUWcS6AWkgrdyg8j1QVLOqG1giHHpAM+d/RnFDFzKnV7nmsxsbpDCWYVN
	 teoRvF8ZaxvhtgSbaMDLYRKv+6QW4G+A+yBIsw5jqDlsnzxEDE63Ciw1wezqWp0BtGaKP
	 rVteUfbpdXnEm9e38zJLTrmj3/iNI70vMyeQWonS0E/xWRfU7f0QYnwzeYwu3Stlatg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFo64ZgW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD866070FFD;
	Fri, 13 Nov 2026 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFo64ZgW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761131F000C6;
	Fri, 13 Nov 2026 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585418;
	bh=WDhunDChdlzPVf1EnDYMe39TWovfxFlAcN6Y1asylwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFo64ZgW8GTAoyF9TEm4rnPNgIm3+VfmRJg1wP4A2GPaVwQTpXik0cBjGImtK8W2k
	 zK6YdlJR2hNKu6TN0HiZEZ7YV2r9Pk9qeMC0iFrd+QYS2jw7wu7i37Uj2aV6lX9y96
	 3cbLaX1F4oqaV2uNENTVugXmExJ6YRpHJ67BuAJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 083/507] batman-adv: tpmeter: fix u32 truncation of reported bytes
Date: Fri, 13 Nov 2026 10:46:27 -0500
Message-ID: <20261113153756.621322366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 1025b76d13288a311e8259a0eefde0854fa63c41 ]

When more than 4 GB are transferred by the throughput meter,
batadv_tp_batctl_notify() will cut of the upper 32 bit of the u64 counter
and thus under-report the actual transferred bytes.

The data type of the temporary storage variable must therefore still
continue to use u64.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-08bb3be4-6c6a-452d-b4e4-606940c6cfa5
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 022eb13e8ec47..56feb02d2b7ef 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -221,7 +221,7 @@ static void batadv_tp_batctl_notify(enum batadv_tp_meter_reason reason,
 				    unsigned long start_time, u64 total_sent,
 				    u32 cookie)
 {
-	u32 total_bytes;
+	u64 total_bytes;
 	u32 test_time;
 	u8 result;
 
-- 
2.53.0



