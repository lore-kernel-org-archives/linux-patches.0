Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EFE241103;
	Tue, 20 May 2025 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749372; cv=none; b=cZuY7CL0qnHR+mfGChK4ytEIq7f8vtIs56zneEGffLouose1Ri9NJStxoC09H0IsnEuwOUzTlSyRQNSdmZcMezasKMNrzTAmmT0snSB7luB4qLO1Ow7qjFXnjKJbOXIocVF8Ld4BzA4kmUAdQK7isiBdhXIMPj4cGh4geceK1NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749372; c=relaxed/simple;
	bh=rpLYCW5Q7iKPEa/d9kkuIDbCyEz5Eznv0E/XFCkdVPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLjswP9SCEYcJjELVE5yr2TDqP4tJU6m5/6oumYkT1xhYGl7JB2gNLaGIj+MhH4B8i/6kbBQeu56K3uiXzyuKfSBhuiR8zl2IReRDSg2d4zLBA40c0Mmf8JBj3XPwsVrmsrWbD+wMBefnitnoioVFNhNtyP4P0Ss+LETR8bqzV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+03HomY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+03HomY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA92DC4CEE9;
	Tue, 20 May 2025 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749372;
	bh=rpLYCW5Q7iKPEa/d9kkuIDbCyEz5Eznv0E/XFCkdVPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+03HomYhChfBoTkNfXcD2ehchRWkDOkrZnYMQPnMMMkeaQYU53TJws0qaW/YhyYH
	 alTum9qY8/aUMaHW/FLy2tPTcWrndAtlxmqplOYjdCKnaLdHi5wiM4myun49xQnBp8
	 fSRs0+57HnxhUl/e2D5Ewy5Nrb9B27vPdawj0q9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/97] HID: thrustmaster: fix memory leak in thrustmaster_interrupts()
Date: Tue, 20 May 2025 15:49:48 +0200
Message-ID: <20250520125801.573867258@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



