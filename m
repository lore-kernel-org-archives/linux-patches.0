Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B2633D6FC;
	Mon, 20 Apr 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700962; cv=none; b=fH01ILP+5/Oep8xPLDa9b2Wl/qhm90ndQGrgcB8aqW7/V1hZmZl6iNpxJaWsY7CHruwPOptiSxuNZt+5ZnwlS8K0SQaiqGrpd63zEwqBxErkVfJH2jkLvwSt+Mt9GiusQcEV8/+fAuVRdBr6I+VDG8a6UHFtnEboTnnChOmm/YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700962; c=relaxed/simple;
	bh=33hltaAmqTBacU1Um0UhRHFtuD5sAIb16SVeGRQCnNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNEWGslKjbmNFnSp4/qqXIrngI8tT+dvorSssj+G8rzoAMvAvR6esS/2mMcRA6QrCY1kGSqGJh8H8s98TySA5d9KdKxIrY7sD4gtNqyWn1oX2Vb55/zCnmDODaQlPRU8Hdie5ZBqjmrnlJ7JRKAREe4bb62TUgw7hTgZSayhkv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2B7LAl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2B7LAl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F8FC19425;
	Mon, 20 Apr 2026 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700962;
	bh=33hltaAmqTBacU1Um0UhRHFtuD5sAIb16SVeGRQCnNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2B7LAl6iqtkm++GqGELWY7bbDSofK/PhgF9hLxvnhORFAnY7H48tsRSht7lL4uHW
	 Fj1zl0hg6F4KnA2V9QFKEzMw/GJCCizwSorK1PpfwW6nYoq/lFDYKkorbJmCx4Y5pH
	 8xNHkE+t49gxaabFSZZjq///YE/FTkH7OFxzh56A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 127/198] HID: core: clamp report_size in s32ton() to avoid undefined shift
Date: Mon, 20 Apr 2026 17:41:46 +0200
Message-ID: <20260420153940.180273633@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 69c02ffde6ed4d535fa4e693a9e572729cad3d0d upstream.

s32ton() shifts by n-1 where n is the field's report_size, a value that
comes directly from a HID device.  The HID parser bounds report_size
only to <= 256, so a broken HID device can supply a report descriptor
with a wide field that triggers shift exponents up to 256 on a 32-bit
type when an output report is built via hid_output_field() or
hid_set_field().

Commit ec61b41918587 ("HID: core: fix shift-out-of-bounds in
hid_report_raw_event") added the same n > 32 clamp to the function
snto32(), but s32ton() was never given the same fix as I guess syzbot
hadn't figured out how to fuzz a device the same way.

Fix this up by just clamping the max value of n, just like snto32()
does.

Cc: stable <stable@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: linux-input@vger.kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -71,6 +71,9 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
+	if (n > 32)
+		n = 32;
+
 	a = value >> (n - 1);
 	if (a && a != -1)
 		return value < 0 ? 1 << (n - 1) : (1 << (n - 1)) - 1;


