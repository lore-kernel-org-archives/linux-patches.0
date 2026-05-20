Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CF63F54DB;
	Wed, 20 May 2026 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299814; cv=none; b=qBpg6s28XnHVs+L6wgBJRxaHP+7bDBY45sKJW/fO3QLXg1pjEbwtxRBf5q/eYrI4Hl36dbazpTdu174aVipWrzxl3Z8s5wXrczY6WoPb6GZrBC3u7qRp8J2fbKZzoXrRSpQuBCdz/ufE28819osZCsxW2NndgKbBpIZAeEMpKl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299814; c=relaxed/simple;
	bh=ZDgT7uBY/b3eCqeTZAME3vXkP8aKPH00m8+D++9BD6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzdNnmrueezgZz02b40GCaSFZ1iDIHNY7w76CUdxKZgsktLVXFOdAcmKSwTLe23zNVxTW+ZsTxzDqHy5ZxoMgRT50rqyXcDlmPuu72iTg1lJVRKL6rXn9DBJvWcMCjc/pnXGvbLuRA9K0jXQAcbFEV7Q1JGDWZnmUF+g6hjAXlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpuRaEjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpuRaEjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4654B1F000E9;
	Wed, 20 May 2026 17:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299812;
	bh=ykZuAAjyPcC10s+/z7u94flS2JuNSc0PprgpuzPyVq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpuRaEjUVds19Z+Xj5XX8PSU+cE3DmYHmWd1/OpraPQscKy6o6tOp/LW9LZxfa9MH
	 Y7Koo38yOwxUI2g4a1deZsVhoIFJwfJDyQdeTi8MtEyqEv7plWfLnjpyN4XIZ4xwqR
	 0hoERBxSyx/GzLfskAPM9w3LHHp6eoAM1bFQTmf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 897/957] HID: core: Fix size_t specifier in hid_report_raw_event()
Date: Wed, 20 May 2026 18:23:00 +0200
Message-ID: <20260520162154.026632366@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 4d3a2a466b8d68d852a1f3bbf11204b718428dc4 ]

When building for 32-bit platforms, for which 'size_t' is
'unsigned int', there are warnings around using the incorrect format
specifier to print bsize in hid_report_raw_event():

  drivers/hid/hid-core.c:2054:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
   2053 |                 hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
        |                                                                                         ~~~
        |                                                                                         %zu
   2054 |                                      report->id, csize, bsize);
        |                                                         ^~~~~
  drivers/hid/hid-core.c:2076:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
   2075 |                 hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %ld)\n",
        |                                                                                          ~~~
        |                                                                                          %zu
   2076 |                                      report->id, rsize, bsize);
        |                                                         ^~~~~

Use the proper 'size_t' format specifier, '%zu', to clear up the
warnings.

Cc: stable@vger.kernel.org
Fixes: 2c85c61d1332 ("HID: pass the buffer size to hid_report_raw_event")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/20260516020430.110135-1-ojeda@kernel.org/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index e67ea3a7d1395..6a1600af30e20 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2046,7 +2046,7 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 		return 0;
 
 	if (unlikely(bsize < csize)) {
-		hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
+		hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %zu)\n",
 				     report->id, csize, bsize);
 		return -EINVAL;
 	}
@@ -2068,7 +2068,7 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 		rsize = max_buffer_size;
 
 	if (bsize < rsize) {
-		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %ld)\n",
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %zu)\n",
 				     report->id, rsize, bsize);
 		return -EINVAL;
 	}
-- 
2.53.0



