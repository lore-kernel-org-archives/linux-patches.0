Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE72C4FD7A1;
	Thu, 17 Sep 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668154; cv=none; b=SM8dxMJF3Ena08Lkuf+MF445tg+MSkhhOFiAao1ndVLkZzp/5HjAXeY+tKWivwVfM0NQhLfF6dp5oRnpdPb4+QHwSD5q2ouILKLNX9/mwHLQ3mIon5/Ewo5TdLDEV1goQCGTmc8nQhlm5dYjYdZaFUbWN6iTHq+PPGfRW4MbaBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668154; c=relaxed/simple;
	bh=PvQqVbS5HgQCOqbrbcDUSDK2KKoQWkw6O0GT15Lt9bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoSCjxdOtom1n+qBb/QY98palYQbizdfSPpg5+m5rFhodLLwZUV33wwpquwpHSSbiP4yu9TTLLXoT50FVYcU5i4DgtF2zhv8PrMh8dfuqjnwB9tnl+OdWYfO61PiFL7uPxxn/A8XbXD08mxOYhPkHhqQ3/BoyBsDqUjYHxM7HMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ1tfCWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ1tfCWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9D81F00893;
	Thu, 17 Sep 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668152;
	bh=CwQiRTP9596P6wariNSwGyLHkW85QDg9ZbQ/zs5YtME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZ1tfCWq/3THtGh9qiNLRxzfJQUbvgRF41g2HwfPce7EsmqsJ3k8XllNjjWP/Fpq0
	 UlUJg9pFGSDmKNLAAn6vviRXH9v7A0QiJRAS/7HrZDzyOr+xK85cwh3KiJjDLVgMc+
	 k9Vr6MQsRDos3i2kFIpGuCMJQSJOk306682lQLD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0324/1102] leds: uleds: Return -EFAULT on copy_to_user() failure
Date: Thu, 17 Sep 2026 16:04:27 +0100
Message-ID: <20260917151547.766502752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 61ed78f55a46e12afd4b464c4ba736f55ff33c5e ]

uleds_read() copies the current brightness value to userspace but
ignores copy_to_user() failures. It then clears the pending update and
reports a successful full read even when no data was copied.

Return -EFAULT when the copy fails and leave the update pending so a
later read can retry.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260521181205.15130-1-alhouseenyousef@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/uleds.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/uleds.c b/drivers/leds/uleds.c
index 48ca73c106bc0..8e250838a15e5 100644
--- a/drivers/leds/uleds.c
+++ b/drivers/leds/uleds.c
@@ -148,10 +148,13 @@ static ssize_t uleds_read(struct file *file, char __user *buffer, size_t count,
 		} else if (!udev->new_data && (file->f_flags & O_NONBLOCK)) {
 			retval = -EAGAIN;
 		} else if (udev->new_data) {
-			retval = copy_to_user(buffer, &udev->brightness,
-					      sizeof(udev->brightness));
-			udev->new_data = false;
-			retval = sizeof(udev->brightness);
+			if (copy_to_user(buffer, &udev->brightness,
+					 sizeof(udev->brightness))) {
+				retval = -EFAULT;
+			} else {
+				udev->new_data = false;
+				retval = sizeof(udev->brightness);
+			}
 		}
 
 		mutex_unlock(&udev->mutex);
-- 
2.53.0



