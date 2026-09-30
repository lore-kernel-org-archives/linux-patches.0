Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2201502560;
	Wed, 30 Sep 2026 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782699; cv=none; b=RKuX94GlLLS6dBIUC3y1mjKpL0VOml0UjrGTy4m75VDiQrVfe03kXDmCPZIeOIaPwVFBDbFNLHmBNWw5LSPvtMk/QyJDG7cNRJPA+4H+mZOsUw8yZ4Mzh9uDnl1Yg67fb4r5tzqTeo1b99jsucgkn2fhvaKdx6lQljX/OhT3dGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782699; c=relaxed/simple;
	bh=4VrbfkK6zvUZQ4bzHxz+lKAGBQsXg2kboB31KpDaPwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJ2bELlc589PvnkpVfqKetJ9RSPLlRxUW6PR2qNVieqbhkvsHGQGNcfmKnHtRGnKkSx7Rb0BglZLE0DzwV4TDp85sG4oq/2nHWf/B4Y/WitpbNj+n6CAsp6HJzd1ZxYcP5LeD++qeIsaUSr/Nd82DhbvwfJMA6MuwNkhxxSzbdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzDVPaLQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzDVPaLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDF21F00893;
	Wed, 30 Sep 2026 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782686;
	bh=n9LpA02V/hhhaWQWaXz2189+Q3vS+wpbk7IqPghQ0GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzDVPaLQR4I9/zuMKnTsj/h9qOSGzj7861sxRCF3KB/lcUxaunnHdq6KRr7j7LzNG
	 9xrmVrSr0e6YWp32BaXoN3r5rHie6oDURMymqfpG1RARs+QpWAwnUxx52BUU8PBFeq
	 1Xi9WWd9FqXWocLjbAbNCYSpTqnnYWNatNXptSi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/595] leds: uleds: Return -EFAULT on copy_to_user() failure
Date: Wed, 30 Sep 2026 17:20:27 +0200
Message-ID: <20260930152350.618604153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 90e54370fe7ea..3e47cb74f49ab 100644
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



