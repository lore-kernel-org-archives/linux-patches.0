Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1331F343893;
	Sat, 12 Sep 2026 13:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219994; cv=none; b=gpLYLYIe+cQKXU0jCAoFDfTwSq1+MMJBVVjJeZBqu/zcnIOtYKHOjZjv6Qki4zMGSJz5v1qCIAJTuI8gb9uNkeoyoTzvr3fSvxnnWq1NtVU+ctP0xn/nUyUgqjPeopw0a0s8G0n4JL3Cjw0kcj34zqt9vcKG1ieqyewW0nBVGFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219994; c=relaxed/simple;
	bh=FjbDcz02KzcopqmQNY8ZA0aadQnEn5z+ojPZ7Jcq76U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQg5ou4JwXkM7aQH8gec2uk/Yfse8H0uzQOFZU1FULnfGgqAVRxvNJht6eVuvfTvmhPqaw9rkzDn1ggdLOYJ9fWCCA+eRaAYmm2LZhxSIwYBpgK0X5PrXo/Y0/fPJGntMadyXGAp2UcRKOUb7WZ/+nv0lLlNyuPyNZv6k1ROn+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmdn7ytb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmdn7ytb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC5A1F000FF;
	Sat, 12 Sep 2026 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219992;
	bh=61axSE2+p5bpw2vfzP8TRWvh36XuLTtxdHiMVpI+Wjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmdn7ytb0OrNYIvQ91f9MFtArc8Y3jUgxikfH/O4vlmqUkXR9bnFFVjbVYufLA2AJ
	 SJ5IS799xf6QIZk/hiWx4+xt8gfFbzdPueGD4c0YJCDd7We+OcpJJZYcT1IPSkNuj0
	 nLmYYIRcE5jy0UmLy2wZ5o6bUZdvcyJtHLtZuooE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0087/1424] HID: mcp2221: stop device IO before hid_hw_stop
Date: Sat, 12 Sep 2026 08:41:59 +0200
Message-ID: <20260912065609.254153812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -943,6 +943,8 @@ static void mcp2221_hid_unregister(void
 {
 	struct hid_device *hdev = ptr;
 
+	if (hdev->io_started)
+		hid_device_io_stop(hdev);
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 }


