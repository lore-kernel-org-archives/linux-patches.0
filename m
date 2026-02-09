Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CA2125B2;
	Mon,  9 Feb 2026 14:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647840; cv=none; b=A+8bekiqMmRxJI5U2n2WNU3lWAHDlLdXAk3RxtxlE2/V48w00U4VATXS4bTBOPYW4mJHdBeq5/91P1k1Rux6XEGnW86spbjM5NjlwPB/PsdEqEWvuiR8e77l95SQxa88v4hvhPOjV6vQ0HPJ6sWvsw32ETfuBSpUw6XJj5IRtAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647840; c=relaxed/simple;
	bh=evVXKXIavpMybFyxWvQVgwY12wlIPUhsvXznhn6+7l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYt89ozfpxea+coN7Cx9O72sAmc1WTH7kkLNO7ShmWE6WBe85VqY1JssEXTEZj8JhMb1zqDtu1MbEfHmH5ycim0+aPI/Jp4vw49uTovgtRXvAUZdeMCeA3qGTjkP3UP2F9vAGDy+kSecqEZweR2PWpSR4SdVRxb5K1pmY7+AlcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTCr8iX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTCr8iX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B39C116C6;
	Mon,  9 Feb 2026 14:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647839;
	bh=evVXKXIavpMybFyxWvQVgwY12wlIPUhsvXznhn6+7l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTCr8iX7Ugsay1hQLrJB22jrhw7RpzveIJUCKrbRPExZcbxUiAwOMu9v40D9GusaA
	 ZjPS3BJzGlWsgBIj3GQvvbwrNksmWHPnOIDmxZhRvic93w4fWkfkG+/dD9I8c4/AF5
	 Ib5CRPK2vbIYUW81oKnVZyn/qHzAb4cd9QIp15lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.12 026/113] binderfs: fix ida_alloc_max() upper bound
Date: Mon,  9 Feb 2026 15:22:55 +0100
Message-ID: <20260209142311.147065167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit ec4ddc90d201d09ef4e4bef8a2c6d9624525ad68 upstream.

The 'max' argument of ida_alloc_max() takes the maximum valid ID and not
the "count". Using an ID of BINDERFS_MAX_MINOR (1 << 20) for dev->minor
would exceed the limits of minor numbers (20-bits). Fix this off-by-one
error by subtracting 1 from the 'max'.

Cc: stable@vger.kernel.org
Fixes: 3ad20fe393b3 ("binder: implement binderfs")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260127235545.2307876-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binderfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -131,8 +131,8 @@ static int binderfs_binder_device_create
 	mutex_lock(&binderfs_minors_mutex);
 	if (++info->device_count <= info->mount_opts.max)
 		minor = ida_alloc_max(&binderfs_minors,
-				      use_reserve ? BINDERFS_MAX_MINOR :
-						    BINDERFS_MAX_MINOR_CAPPED,
+				      use_reserve ? BINDERFS_MAX_MINOR - 1 :
+						    BINDERFS_MAX_MINOR_CAPPED - 1,
 				      GFP_KERNEL);
 	else
 		minor = -ENOSPC;
@@ -422,8 +422,8 @@ static int binderfs_binder_ctl_create(st
 	/* Reserve a new minor number for the new device. */
 	mutex_lock(&binderfs_minors_mutex);
 	minor = ida_alloc_max(&binderfs_minors,
-			      use_reserve ? BINDERFS_MAX_MINOR :
-					    BINDERFS_MAX_MINOR_CAPPED,
+			      use_reserve ? BINDERFS_MAX_MINOR - 1 :
+					    BINDERFS_MAX_MINOR_CAPPED - 1,
 			      GFP_KERNEL);
 	mutex_unlock(&binderfs_minors_mutex);
 	if (minor < 0) {


