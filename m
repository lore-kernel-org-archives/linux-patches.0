Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0346198845;
	Tue, 20 May 2025 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749696; cv=none; b=hNPszHdKzWo4D/jq2rtmqgiCjALwWMv/Uvr38riLtRB9C4SipaQaDjiXSl7n+mvvctS0QJHghmGS0YLbITkTjD2lxo0vo9RQxb6RJ/4YSdhncvZb7Bb2DnaC2oB5ufpQu2vaRm8+fb0rFzhD5doKl02yo03/K7dt3ocArZZPAOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749696; c=relaxed/simple;
	bh=Wda9TnTRhXyqgsx3vThtcOxCIGkrjtKbDKi6W7I2ACc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pm9sghPeMKrdI9VRsmN2FDAocA/9ityS3f1OFaHNxiq4yayO2lW7pB782aJFiFdhWlP/ZpK25qwMa/DbVcZn9xNqRuRqZQcntbstatpNbtv+/e4Y2Azn6YpJjDVDcEES2xXKJOIKlVm/7pmBYz713JKQ1qYoZ75uBGiEq1ed+Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcuLz0ZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcuLz0ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656D8C4CEE9;
	Tue, 20 May 2025 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749696;
	bh=Wda9TnTRhXyqgsx3vThtcOxCIGkrjtKbDKi6W7I2ACc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcuLz0ZWDzFlMJUKJw0wjPycLkNMOZ2hfyMpZ3u/XaOvspoRLQwep+pXRginJQ/sU
	 Gwjv33YOJuvykIjebOk0vQmHMtiEyGZn3eM0JXwR1148uA/IYKtn+XNftBKmyvaH4Q
	 t6ZNoo1M3iozBmjUmSHdYD9jCz0gOZof0XDKhG0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/117] HID: thrustmaster: fix memory leak in thrustmaster_interrupts()
Date: Tue, 20 May 2025 15:49:56 +0200
Message-ID: <20250520125805.220934639@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit 09d546303b370113323bfff456c4e8cff8756005 ]

In thrustmaster_interrupts(), the allocated send_buf is not
freed if the usb_check_int_endpoints() check fails, leading
to a memory leak.

Fix this by ensuring send_buf is freed before returning in
the error path.

Fixes: 50420d7c79c3 ("HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding endpoint check")
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index 3b81468a1df29..0bf70664c35ee 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -174,6 +174,7 @@ static void thrustmaster_interrupts(struct hid_device *hdev)
 	u8 ep_addr[2] = {b_ep, 0};
 
 	if (!usb_check_int_endpoints(usbif, ep_addr)) {
+		kfree(send_buf);
 		hid_err(hdev, "Unexpected non-int endpoint\n");
 		return;
 	}
-- 
2.39.5



