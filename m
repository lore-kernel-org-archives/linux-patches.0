Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D83188017;
	Tue, 30 Jul 2024 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359611; cv=none; b=tRWRf+Qg4qvQl2+oqqF4O5t09VUJ4ZWSeWQXFHL4iKpYLXm7xOQ8vr154mdrDJ8MkGDPzHAfUQgQs6IFVl1Fre4M7KAmpGrsZHR+GltdHY05ZWu9PYwGLVYjGLlpmBvBs5NjK2kT7e+lJB0aL15EA5T4EX2aXi4YZI+CTKA6uQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359611; c=relaxed/simple;
	bh=HXVXF91pb216vefyfuC/Fx0rJ3iwX7leGQIgaPUclnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTAXwCVcrPi/7PkrpIMLgSrf6v0Z0op1tMTWTg3YnHzVciW2+HLsFFHNS4G2j7m2i/yusdY6DO7vf6/spa1a2jZTr3AgWgXDPiHGrUw6U/gLPwzItwjrCgb3lI9s7nOTV1U++Zm/XKeKlUgdLxCT9BFpUoXmXULVCUi+Et4Rqrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXKdnJss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXKdnJss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B11C4AF0E;
	Tue, 30 Jul 2024 17:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359610;
	bh=HXVXF91pb216vefyfuC/Fx0rJ3iwX7leGQIgaPUclnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXKdnJssPwaOXEHdUnga9MZV/EpZ8Xs/3D55ft6vR5xJAQwI1VqigRB+lk5oQiX91
	 miMYWFGITD5HmlOuWNnkR1wMNycCV+A8MSBo/MKEbjnj6Xur4/ztLRKs67n+O6JakE
	 nByGj3I6XLmEfOfQYEkcAMKzwDyNTLNBQ2qIdflQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6 508/568] minmax: scsi: fix mis-use of clamp() in sr.c
Date: Tue, 30 Jul 2024 17:50:15 +0200
Message-ID: <20240730151659.880686349@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9f499b8c791d2983c0a31a543c51d1b2f15e8755 upstream.

While working on simplifying the minmax functions, and avoiding
excessive macro expansion, it turns out that the sr.c use of the
'clamp()' macro has the arguments the wrong way around.

The clamp logic is

	val = clamp(in, low, high);

and it returns the input clamped to the low/high limits. But sr.c ddid

	speed = clamp(0, speed, 0xffff / 177);

which clamps the value '0' to the range '[speed, 0xffff / 177]' and ends
up being nonsensical.

Happily, I don't think anybody ever cared.

Fixes: 9fad9d560af5 ("scsi: sr: Fix unintentional arithmetic wraparound")
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sr_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -431,7 +431,7 @@ int sr_select_speed(struct cdrom_device_
 	struct packet_command cgc;
 
 	/* avoid exceeding the max speed or overflowing integer bounds */
-	speed = clamp(0, speed, 0xffff / 177);
+	speed = clamp(speed, 0, 0xffff / 177);
 
 	if (speed == 0)
 		speed = 0xffff;	/* set to max */


