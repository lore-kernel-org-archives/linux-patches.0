Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0485553C3BE;
	Thu, 17 Sep 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664757; cv=none; b=MdBZF5jkHFDHs0R+czRGMGKQmCIJJBXoP7X3qVP7yNOmYqaR99A7oYkPikOXlTCYRTefj1Cy+VvQKEjwiX/ohPxNJUs7UnfDqDPxZo1VXkfEGvKJUDQE6+DPPkSoYvLsLeNBYLS5EV6K0LuiZ+lbpNs/XmyzzI5N9cynDPJaZwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664757; c=relaxed/simple;
	bh=M7qx9a2pBYg6XCmBwS0rEf8ZK7i9+FqO3pu+4qxdh0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDQDZIYHYe4/ckS9sPB5dvNC54HqT/046UrC2ohY8UYf3MUgkqkBMS/3zi9cCzU+SLgGzGtwXSqlKm/iHjp6y2cHetfHXwQAB1BysP4wfHTGn5k6sITXm886qzdfpJSlS/TuoXxKS/H9qiQe0TxWwO2O3dbKVL9VTHvxnSlMIFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxJDArWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxJDArWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9E41F00898;
	Thu, 17 Sep 2026 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664755;
	bh=LytloPtizkwH5t6HdKYF5QRudHZ7cPbalaHLvFjKLGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxJDArWhsUr4rkD3DZTHtNxOjvjgTyGPUw8o7+SCUGLXa0ShzWdpdlIl7B6B0RGBW
	 TzkIqQfb6gEtmzPXxDO4Zt661F0OmICd8EgJo+0c4n/7EJPqNTa0aF5FyWnVB50EUc
	 KARGv1vdqyVlrT9CNQ0xKzZUQc6Wp9LC/3KfFam0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0429/1250] leds: uleds: Return -EFAULT on copy_to_user() failure
Date: Thu, 17 Sep 2026 16:03:44 +0100
Message-ID: <20260917151603.647750278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



