Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039C31E2618;
	Mon, 21 Oct 2024 10:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507109; cv=none; b=RBeqJctwEPxeijvUzhiFi0MSDrtLTres0o8aGb/vyWxZ9I+ozjzhiGMuydsVNWnxEraellyv6ivkIopcELS9Bo7zZR9xK5drZG8Fd7k91gGDQ0ROBjrxqhJWlN4fAzBGcCgaPNXVt0dCKQLAAZnk1kRsxU4ObQAFjz7bGOZ5HQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507109; c=relaxed/simple;
	bh=zYTE7E2EZWtBz2CmLS4wYmbJ/ZB/wcsp02RT2gijDG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaJiGfjxfhEsXowjTNg+hFd2OKfitCGuWFEqQK8DFCweEvmMlVbnWDnkSxwneFd4u1DjxRy9ivoCC1lIYRUJy0U4Gs650/sF5RuFe78VBQq4DbntsnVV/w80MPy55Jp21o0x2iF7BFYlaOHRyV+OjehsFIbEGylstZs1EmlQvLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqpVDIpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqpVDIpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CA4C4CEC3;
	Mon, 21 Oct 2024 10:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507108;
	bh=zYTE7E2EZWtBz2CmLS4wYmbJ/ZB/wcsp02RT2gijDG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqpVDIpw50THVaIVdHcZPgvICKaumi0NyLxMx4dAGxH6+g3XA33xcdi4TapFAd2Jl
	 5HPPEqa+hGfRzfTf3gsH1wI8OS/c0LQQzHO5kVP02oiIn5ARJw1+hgdq5GZ/vYkBIK
	 No9ItAlrG2LIUGjDZ7h5+QWNqoF8U0GdI5CeAAkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 061/124] ublk: dont allow user copy for unprivileged device
Date: Mon, 21 Oct 2024 12:24:25 +0200
Message-ID: <20241021102259.095542206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ming Lei <ming.lei@redhat.com>

commit 42aafd8b48adac1c3b20fe5892b1b91b80c1a1e6 upstream.

UBLK_F_USER_COPY requires userspace to call write() on ublk char
device for filling request buffer, and unprivileged device can't
be trusted.

So don't allow user copy for unprivileged device.

Cc: stable@vger.kernel.org
Fixes: 1172d5b8beca ("ublk: support user copy")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241016134847.2911721-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c      |   11 ++++++++++-
 include/uapi/linux/ublk_cmd.h |    8 +++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2327,10 +2327,19 @@ static int ublk_ctrl_add_dev(struct io_u
 	 * TODO: provide forward progress for RECOVERY handler, so that
 	 * unprivileged device can benefit from it
 	 */
-	if (info.flags & UBLK_F_UNPRIVILEGED_DEV)
+	if (info.flags & UBLK_F_UNPRIVILEGED_DEV) {
 		info.flags &= ~(UBLK_F_USER_RECOVERY_REISSUE |
 				UBLK_F_USER_RECOVERY);
 
+		/*
+		 * For USER_COPY, we depends on userspace to fill request
+		 * buffer by pwrite() to ublk char device, which can't be
+		 * used for unprivileged device
+		 */
+		if (info.flags & UBLK_F_USER_COPY)
+			return -EINVAL;
+	}
+
 	/* the created device is always owned by current user */
 	ublk_store_owner_uid_gid(&info.owner_uid, &info.owner_gid);
 
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -173,7 +173,13 @@
 /* use ioctl encoding for uring command */
 #define UBLK_F_CMD_IOCTL_ENCODE	(1UL << 6)
 
-/* Copy between request and user buffer by pread()/pwrite() */
+/*
+ *  Copy between request and user buffer by pread()/pwrite()
+ *
+ *  Not available for UBLK_F_UNPRIVILEGED_DEV, otherwise userspace may
+ *  deceive us by not filling request buffer, then kernel uninitialized
+ *  data may be leaked.
+ */
 #define UBLK_F_USER_COPY	(1UL << 7)
 
 /*


