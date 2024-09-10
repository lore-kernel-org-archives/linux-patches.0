Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E023188A0C;
	Tue, 10 Sep 2024 10:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963053; cv=none; b=QaP1u+Ra7RhBEfaSmUENeAVt1t4v8f+qJsYm/fnZmUebYLpavAn6ZP46A342HNbiDQugcKvX4pzjoeEDrDYnUv4dr7RpIL8jMpYGfCqqlpIps3hYyr3defKUkDgSsXYQMulTQfKeKpPXsKsV8/bMtG9TSE6BDCIprP0TD/ky7o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963053; c=relaxed/simple;
	bh=r8VMAx29Z7r0V/Uil5+hA0s9pWTHTxXp6WE2Ak6mFtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3Y2zIBYqy9u/NnCKUH8Dg/GsMFlM37sRNIQjm4cvvVfpYjK03YOrZVPgVU5jpeoo07MFLIijybjrblEpoOKf+9VKJXkI6T4h7Mg3JNfbGy9wWJXZQb6xfxUYcynY61LzFU88DKqf1NnO8YZjXoQ+FUvpdIKdDuX2WxLwcErsI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DckubVez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DckubVez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09102C4CEC6;
	Tue, 10 Sep 2024 10:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963053;
	bh=r8VMAx29Z7r0V/Uil5+hA0s9pWTHTxXp6WE2Ak6mFtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DckubVezNwEvi4Fkiwe1ia0fHg9ZDzgv1TwR3K4S4zgViem75FNTTS2b3eG1LehRU
	 sycXfM3t6Uti6ZOPY1cObYHyxQTkM7u5tmWjeF25ZRgdGkHIFsBCjJEiwqz98axyT9
	 SodHY0CyaynV5icXIZk4qn8of2iD2ZocJ4L6qz00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+24c0361074799d02c452@syzkaller.appspotmail.com,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/192] HID: cougar: fix slab-out-of-bounds Read in cougar_report_fixup
Date: Tue, 10 Sep 2024 11:32:24 +0200
Message-ID: <20240910092602.957832855@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Camila Alvarez <cam.alvarez.i@gmail.com>

[ Upstream commit a6e9c391d45b5865b61e569146304cff72821a5d ]

report_fixup for the Cougar 500k Gaming Keyboard was not verifying
that the report descriptor size was correct before accessing it

Reported-by: syzbot+24c0361074799d02c452@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=24c0361074799d02c452
Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cougar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-cougar.c b/drivers/hid/hid-cougar.c
index cb8bd8aae15b..0fa785f52707 100644
--- a/drivers/hid/hid-cougar.c
+++ b/drivers/hid/hid-cougar.c
@@ -106,7 +106,7 @@ static void cougar_fix_g6_mapping(void)
 static __u8 *cougar_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 				 unsigned int *rsize)
 {
-	if (rdesc[2] == 0x09 && rdesc[3] == 0x02 &&
+	if (*rsize >= 117 && rdesc[2] == 0x09 && rdesc[3] == 0x02 &&
 	    (rdesc[115] | rdesc[116] << 8) >= HID_MAX_USAGES) {
 		hid_info(hdev,
 			"usage count exceeds max: fixing up report descriptor\n");
-- 
2.43.0



