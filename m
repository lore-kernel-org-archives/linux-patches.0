Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F71C8DF;
	Tue, 10 Sep 2024 10:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965246; cv=none; b=bzWmxms2qp2EmoGjxMw5lCrevsI6D1sKttN57p4+UxXNDepqFby26rIzT+DVpTpLzNTbIZJpM6/14kfVbVyiR35OR40t9lQzU3Ni2NQBGKg4Yo7/o2zRP2vZung3ucMmarQUSvzpYZxIHfwRjyaaWYhTSSMEzln1kpINV6IEhGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965246; c=relaxed/simple;
	bh=tS+YvTVGb5P0KzSKKUgGVd+DnrFATzKWEL71Fd9JN/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiPZ4x7eYcELp+m1yWoZAF3cYiVO4GpwGssS3+PM98X1vuQ/AAI2I9LSGEZgrgrp9hJn1Nw0CG534R7BnGxvV3CDImpqk5grJhA25XmaXj+vbyjs6ShoHvoRnZ0QYwiVrAma28Dc/zAjMeFvcFuA7jM3q+Q+4wAt5NFgu81j3Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvyEx9AI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvyEx9AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0063C4CEC3;
	Tue, 10 Sep 2024 10:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965246;
	bh=tS+YvTVGb5P0KzSKKUgGVd+DnrFATzKWEL71Fd9JN/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvyEx9AI/0W8ZL7EJjz4Vz8deaSddE/GyXOikEw3qifHXhMpki3xDRmDw55xWzYZo
	 mpEekYfKR1hIT1bpqPeDhVlACs5PUWoyyomvrjxKOpGkvMMIH6s8yXuhB6mJ56KBIs
	 UGftqbnoKcn6ehYYWljg8dVNFFyFT/mbtVoCuaeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+24c0361074799d02c452@syzkaller.appspotmail.com,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/186] HID: cougar: fix slab-out-of-bounds Read in cougar_report_fixup
Date: Tue, 10 Sep 2024 11:34:04 +0200
Message-ID: <20240910092600.731700703@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 28d671c5e0ca..d173b13ff198 100644
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



