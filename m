Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021E7339872;
	Fri,  4 Sep 2026 06:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502218; cv=none; b=rYrgO5PNpq+R95CrK5JIpwBLvKdVxNqU2FCyYc6e/n75LLR8trU68UMOqP5HEurncKAhZ7wru05PygYphgqON7aAZh7swD1O5tQ8bLy9NVAYaFUUIl015wNPNJspGb6Hr96q2DMEvZ5Tkc9iJ+lmrDw0vVe6PkOGhX5+6dO6AqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502218; c=relaxed/simple;
	bh=a8KLwklhOdNbGtXHi3O91JYYKHBYHwTcgi2YqTptogA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYpYYmlsTVNet6BL0spdOFA9rfPNA4q4xtazndykd82sCxngWWJtyBHE2hZ1gimJfhIF2BMbZ9ygi+ieq4bV8nPfK832iC32+SRjbWmqlyzcju5sfkbwPrsuMLExVLYFGaT1j3j1a2JW+B6HnXTwuiOcXeWm0al6501iDjtQfv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnygODU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnygODU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B43F1F00A3D;
	Fri,  4 Sep 2026 06:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502216;
	bh=Xu5EHeMTIpXMuclsL2UP+i6hxCPDRpFhIV81d1NbBf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnygODU60BMlRzf7hvpF0TrJ8FykAb3FKHYBI2B9Ne7HWncN3M4RO64mlVtgoJ7+v
	 MuOJM4oWuu1DsnsBHt0tRlMZGcrX2WIhjCvJil5I6KfrV8hEAP+xXdygxRYYN2bIsM
	 3FJ4YF4yqnaymjo29d78eBhcWX0S8hPsMePhknZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 128/403] HID: mcp2221: stop device IO before hid_hw_stop
Date: Fri,  4 Sep 2026 06:58:51 +0200
Message-ID: <20260904045737.748296530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


