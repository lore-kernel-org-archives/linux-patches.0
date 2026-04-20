Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08203382CD;
	Mon, 20 Apr 2026 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699885; cv=none; b=epsuDmCc44C2J+q3Zx2ZfPkDWKnES7jLAt/2lFmotT2woqzmeyJrse7ei3F4sh/nSblYa7zsGyuLGQDBm3HyKvQybOEGkE+CEsdX7qTybviVAPY+ma89nX6ancz511pXM9xd38AaRVZqDF+7z18Gsy77Fs+VuJ2vkyfU03dFZEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699885; c=relaxed/simple;
	bh=ZzD0kl+NLWMETVZi3wfi0PvIxvWEpWAWpcWYA8uRky8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRi1Ob+Uhk92wgiUaRNx7JQx9HWMrNT2MEI/AHhfJzuvUgwoqS+acj6K+Q80p1r2JPUkixwKFMUYuVqIUxTp07MvAQhYXcyZs+LBdOTXjrEF3fs7QNewKXa73E1OoLAD0OAuX2yIPjtutet4Etdvl6LQ7iNfEokWPvjUVmyAy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1E0ZT3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1E0ZT3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66773C19425;
	Mon, 20 Apr 2026 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699885;
	bh=ZzD0kl+NLWMETVZi3wfi0PvIxvWEpWAWpcWYA8uRky8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1E0ZT3OuGzQhwn1Tr1OYMHJxcQ1s3thxqLVkBjrEAys2J1Xv3mb8pUZp6i0bikjN
	 7uY+5CyNbM3y8oA+YB6dxzYb1bzTWLEdp/sd3lHKDy9lGv3r5ByLhHlU/7dkTJYf9b
	 oRPTzCL/GdqfxydL4W1WJZoSqsX2fhvNo+Aq/JGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.0 07/76] HID: core: clamp report_size in s32ton() to avoid undefined shift
Date: Mon, 20 Apr 2026 17:41:18 +0200
Message-ID: <20260420153911.085588561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


