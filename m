Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06F2D77E5;
	Mon, 20 Apr 2026 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700183; cv=none; b=sK21Tk3YQczz0pGCWCZxZ8gKIJ17Q9frFnzhY5cCsn3yRCdrzmUKACH88vosUMqDYlg60zJDmxEYoZQKNDUi0yogRAjBUVc6/HBNMVWb4Zk/u3FosqiGArjOiBtWwciiaBq+djQFMbCEo9jhaMX7iM7wTD30bU8yFD2jVu/a0e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700183; c=relaxed/simple;
	bh=R+pw9QNlfnggpF/IzFfUGeB2ARzNlzINcsfynhuhfsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5hQz8vHDjYjsOWC0h+wI0j7kwQy43I2Z9gfW+ROWLvBJ9fd+MnI0PXA+kUd87ocBmkrGTcgSSuITwXhLfwH6rksMuqVfqAe4qWyTfmRgnPevvLYQpk+0Pn0fEAnjSoSfklIX6gj95W/vKyPbzB9DUOEQus1YdoOhKCru7ZztR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGATSYpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGATSYpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93B4C19425;
	Mon, 20 Apr 2026 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700183;
	bh=R+pw9QNlfnggpF/IzFfUGeB2ARzNlzINcsfynhuhfsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGATSYpr2BWR8zjVNBn8zQQn2TVBDmFFKUjDNImcRzYZBiXgqruYRoUHKSrhv+GBh
	 TlW1xx6HiUymqydIMKP8Oqo6WRuo2WKLd+cSvZmjosWxghUFeKpdUmXxcEKKqv/G3V
	 t3Gxg53C72KPu3JYsTZhIwUXkIjyT1CBUFzMbPpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 041/220] HID: roccat: fix use-after-free in roccat_report_event
Date: Mon, 20 Apr 2026 17:39:42 +0200
Message-ID: <20260420153935.516189711@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit d802d848308b35220f21a8025352f0c0aba15c12 ]

roccat_report_event() iterates over the device->readers list without
holding the readers_lock. This allows a concurrent roccat_release() to
remove and free a reader while it's still being accessed, leading to a
use-after-free.

Protect the readers list traversal with the readers_lock mutex.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-roccat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index c7f7562e22e56..e413662f75082 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -257,6 +257,7 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->readers_lock);
 	mutex_lock(&device->cbuf_lock);
 
 	report = &device->cbuf[device->cbuf_end];
@@ -279,6 +280,7 @@ int roccat_report_event(int minor, u8 const *data)
 	}
 
 	mutex_unlock(&device->cbuf_lock);
+	mutex_unlock(&device->readers_lock);
 
 	wake_up_interruptible(&device->wait);
 	return 0;
-- 
2.53.0



