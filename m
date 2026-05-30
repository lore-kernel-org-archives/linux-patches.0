Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F4A34104B;
	Sat, 30 May 2026 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158548; cv=none; b=lfx81n0EiTI4spN69S0NM83VKcuX/6Yy9JPSg6LLrl9skWOvj0s8rrFQS1Dc6yCWGVSUAquyqAuIbgnPuILJebGEAB4T2f2HjvU82Nofr47Ir8GLvNG1YcHIVXhUGP9Gg2MslrE80un5w9QBQpj9CPDHfFgUd4W0zK0XoiiBvqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158548; c=relaxed/simple;
	bh=05Eya/EBDtoXIuSegbfIN2nFrZdn9VDYP+m+0PAgxtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoTYsh6XB4l2TTIZJS+1DUXjuvafIyCUoqY9EDZkhmM61q1mKh/eU+E0qtBSIQrJLt9NhBklUI0Rp788EqrCsCQqxyJVhFWQV1SOyoVRQsU8dmQp7TLP9DTEs0nv/x+rqhJTwxXSfMtSFR9KD5w1gE5A2IqDLrB/a7ChxW8OiPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InDEItsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InDEItsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564C11F00893;
	Sat, 30 May 2026 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158547;
	bh=CDC9TD84QTRA7BOZPoL6nk12qfsNcv+B12O2Es1BKxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InDEItsxmsLACBcW1XACVKCu0h8cB69hwa5Fwk4wH4V/vQIrzRXXJo/AxXOzOaXeE
	 kQjQcy2FeJtY11Y9IXLHrGdxOgXgKJfZ+y8ADrfghrWP45f0mvbkVqHHDi5yBaegCK
	 1IC6GrgJ/EhGuzAuHmlw3nqBnJnETTQCnlCDYd6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 061/969] HID: core: clamp report_size in s32ton() to avoid undefined shift
Date: Sat, 30 May 2026 17:53:05 +0200
Message-ID: <20260530160302.067582740@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1358,6 +1358,9 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
+	if (n > 32)
+		n = 32;
+
 	a = value >> (n - 1);
 
 	if (a && a != -1)


