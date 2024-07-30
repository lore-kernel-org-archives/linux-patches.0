Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29C31A76BE;
	Tue, 30 Jul 2024 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360554; cv=none; b=m/vDoH0xNDiPrJY5g1QFurb4CyBlRnAYslJKw6xTb0ZXnV4QYuEstaLvOFQVmAnkT8csYrN+vEQU1iRjAQ9FsOyMWi96PC79Dir5UOOZXgKgzAQP9k9KlJakLQY1SOSvHd7VQVFXw73JqDsEiq6I0dbiPFAeXNHyB/eX+j5n4r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360554; c=relaxed/simple;
	bh=L8j5uBS4NksLtbFfDvWj+aSW1/3acTi7A5BjgwjA6To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEBBgheMHWIyTdMTwHyWt5Lq1DPDdV98bn9mj0fFF0p7lVwfWazmppe5i1ErmJzz5q+FG3i0ImwiA6XTRU4y5KVWjtIxpZzceSMzzb6/W6iizYu/Et4BnRMUeizIS7pGT+kzt99HNXpTS19kA8QlQeZNUoB4S5p3JBaBctuAxYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vh/MIlRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vh/MIlRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43019C32782;
	Tue, 30 Jul 2024 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360553;
	bh=L8j5uBS4NksLtbFfDvWj+aSW1/3acTi7A5BjgwjA6To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vh/MIlRr3HrHT8F5dWa9B0m46nhytnKWSwNVDUaJi4h432nBFrNfUBPoM92eOjupj
	 1zn1IoaYGWIUJKKmlfjTQIFuyO7vAXIK0UWghPBF2C3X6PsLieI9X3tHaQcE3TcMi1
	 gESsOKVLK16Hvs0wa3k9clDCMT4QGnCjMHLtEkhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.10 735/809] minmax: scsi: fix mis-use of clamp() in sr.c
Date: Tue, 30 Jul 2024 17:50:11 +0200
Message-ID: <20240730151753.978133858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


