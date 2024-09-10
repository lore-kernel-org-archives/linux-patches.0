Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BCA18A950;
	Tue, 10 Sep 2024 09:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961219; cv=none; b=BcmGJGWlS6PBZzzy5XSf9eOt6KsKkP5foEcLmf+KfInLwrpe3+Vf75XaZg09PHefB0DXORf9YSjf07BN8vGwEDhdgvli4EN3qnOCZKaLhabAQgVbBCU6wuKbXAhujdVj1FNCEe6fzQY377BnsLaxSjHIFv/S45PAsPyYXDuTpog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961219; c=relaxed/simple;
	bh=NHL/EpzapZC4pOMkH+O/EyH/LCNN30DpbBVqbOw+CcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZJL4r5FNlAgh1ct7B0+HnLKK9zuypLL5d/H3488qqCdZIefIYykzNnTsanAIqC1ZYJwD8dvcfn711Az0DLrWZFFZ9dLemSGcopY8VI0zYq8Oak6de1hJqTWyPzIwn3PFtQ01QPSfZvnZR9lUc3L/NyoecmKj7dLmdyU34iNMTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0sr3ygk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0sr3ygk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6E4C4CEC3;
	Tue, 10 Sep 2024 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961219;
	bh=NHL/EpzapZC4pOMkH+O/EyH/LCNN30DpbBVqbOw+CcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0sr3ygk/aWpMRMkeiLdqq9Ydnl+39NUAdNchENf+B7d4hdFmoRZBPmTDS4P6Y8aj
	 L2Ll10L69pe1DF7jhasPDzFnU0XAnm7Ed1EIhk6EqK09tl28A2YtCcV6qvjVHyn/Bt
	 xrGi3Pggf7EjhjScF+oiBedOv0uE85mpFVNzmhUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+24c0361074799d02c452@syzkaller.appspotmail.com,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 67/96] HID: cougar: fix slab-out-of-bounds Read in cougar_report_fixup
Date: Tue, 10 Sep 2024 11:32:09 +0200
Message-ID: <20240910092544.490193180@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ad2e87de7dc5..d58a108a96c0 100644
--- a/drivers/hid/hid-cougar.c
+++ b/drivers/hid/hid-cougar.c
@@ -104,7 +104,7 @@ static void cougar_fix_g6_mapping(struct hid_device *hdev)
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



