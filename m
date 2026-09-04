Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CF63B14B4;
	Fri,  4 Sep 2026 05:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498977; cv=none; b=ZeJET5TV4MW2IwUOVp8i3921cDSBaLEXHFjs8DONXY7IAF2iHl2M2g90j1oJYgH1U1mExVavSzD+lYP/Xpi5rndMnUz6YdWMQd4M9ozqIrCl01Cj/GN4SHyRS1F84IUQU5CPxq7em2WFEZV7H7+IuJvVz+vLScWNEEofqharRDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498977; c=relaxed/simple;
	bh=QyEwWP72+Xm96kfIGiDD25H1YgIBErGLt4rEWx729Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCoH9+NFnd7myc7x2HuAA9qr887PGZN0kJh2C7M/jp1gDlRsWNjId0EorBn4uJjMSfc4P5L+NMhRzmJEswpHD16p7sJTiKutJ1h5dfB63K5+gSJOfr4lAagg0YKaKPefGCksHV82MbTedQ6g8ZlBKxmNyRoBE5aH3d6IEdoaFa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdqjnNlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdqjnNlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C9D1F00A3D;
	Fri,  4 Sep 2026 05:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498976;
	bh=WJrDM8s5pOg0kwE/UT4x2GIui1lvS0AMxSlvw1H05io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdqjnNlKP1QG8R5fBiW1k52Sq8zZ+w7iHPHqn+owaAhPbg5RduUP07riS8wx2u2b1
	 cPr5E1ImMLy1u41U6jAAnLmVu9LzYe31Rzm8owR6ELt+CSXnDxCQlL9lsAUV/cTQG9
	 EpmllzQgMf6FyuZLewEMKG+ITAQ9lwgy95c0igzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 253/713] HID: mcp2221: stop device IO before hid_hw_stop
Date: Fri,  4 Sep 2026 06:53:41 +0200
Message-ID: <20260904045809.510999885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit dca151633c0fde90935311c60e7cfc064aa56134 upstream.

Quiesce device IO at the start of the devm cleanup callback
mcp2221_hid_unregister() so that incoming HID reports cannot race with
hardware teardown during probe failure or device removal, addressing a
potential use-after-free.

Guard the call to hid_device_io_stop() with io_started. On normal
removal hid_device_remove() has already cleared io_started before the
devres group is released, so an unconditional call would otherwise hit
the !io_started path and emit a spurious "io already stopped" warning
on every removal. The guard preserves the probe-failure balancing,
where io_started is still set after hid_device_io_start(), while
staying silent on the normal removal path.

Fixes: d4b50ac06ea6 ("HID: mcp2221: Allow IO to start during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -1049,6 +1049,8 @@ static void mcp2221_hid_unregister(void
 {
 	struct hid_device *hdev = ptr;
 
+	if (hdev->io_started)
+		hid_device_io_stop(hdev);
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 }


