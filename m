Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536C118D630;
	Thu, 15 Aug 2024 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729348; cv=none; b=HdB5Ar8rYduBScd3xDenxLdoGXj2ynVAqOsCJLfEHtkc/CUj3bb9HdVQLt3FaYuo1hprgiXDUzwlTVyBKErWxyrHicFhfXmsTwsTqcDwQGanCUOmoAqMbHToyIvNjnFQgHY+EnCxPBP75uQfj5xenRf/e5sepxTF3GAKVnLDwyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729348; c=relaxed/simple;
	bh=jQLiF9G/ONdZ//XjAwUGmUXGwqRKEL3J6Yql9nIDFuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6XkRYiymt84o2oXcfUWSuyMqY6f/gH3HDB/NTtSbA7S3jo6txu3hmrg7eoZZiivsGD7p0RkAdhuUD+Dv6fjWS/lB6w4LuMMwHAat+AqtM91DazQr6vJaWZ7oMysUWZgfCF8Vni3c1PwRCbvEVt7Et/ZWavh83ppuQSyRhZMOHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abtpcTRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abtpcTRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4871C32786;
	Thu, 15 Aug 2024 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729348;
	bh=jQLiF9G/ONdZ//XjAwUGmUXGwqRKEL3J6Yql9nIDFuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abtpcTRci1HwPaivx9+RNpQ+nABSxPmeG/3mvYo5Dygp5a0RKJUS87IyJuFfIOvw7
	 68Jz32tzJ55i86sRM0mSFPAQsteHuPNwouT98yLFuy2czvsThQobbmIutbB7T0po2s
	 45iAkpS9S0pL8UEtNQZ+/R5Z1SI8nNijw5s6aQUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/484] perf: Fix default aux_watermark calculation
Date: Thu, 15 Aug 2024 15:18:48 +0200
Message-ID: <20240815131943.989965217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 43deb76b19663a96ec2189d8f4eb9a9dc2d7623f ]

The default aux_watermark is half the AUX area buffer size. In general,
on a 64-bit architecture, the AUX area buffer size could be a bigger than
fits in a 32-bit type, but the calculation does not allow for that
possibility.

However the aux_watermark value is recorded in a u32, so should not be
more than U32_MAX either.

Fix by doing the calculation in a correctly sized type, and limiting the
result to U32_MAX.

Fixes: d68e6799a5c8 ("perf: Cap allocation order at aux_watermark")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240624201101.60186-7-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/ring_buffer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 45965f13757e4..f3a3c294ff2b3 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -683,7 +683,9 @@ int rb_alloc_aux(struct perf_buffer *rb, struct perf_event *event,
 		 * max_order, to aid PMU drivers in double buffering.
 		 */
 		if (!watermark)
-			watermark = nr_pages << (PAGE_SHIFT - 1);
+			watermark = min_t(unsigned long,
+					  U32_MAX,
+					  (unsigned long)nr_pages << (PAGE_SHIFT - 1));
 
 		/*
 		 * Use aux_watermark as the basis for chunking to
-- 
2.43.0



