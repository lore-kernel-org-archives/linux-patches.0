Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5AB57ED84;
	Wed,  9 Sep 2026 14:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964546; cv=none; b=DoY2QR3NBlw4uhuRb2f3SOngTAWL8Y6q0yY6V3J6boRH558ydWiRJHxEvQ6y5N87SZTc/bCOne44DplTH6tC4fth02tTi4u27xiDQH27S0rLCBZDFDEUp8quEOM2su1xAASryGZEKzPis491G57TNNzdnEzfCmc/vJJstIhDiPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964546; c=relaxed/simple;
	bh=E14uExPjkflf2V1bgHky77qNilSFhGyXfFHrMoj2AZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwzBUoOBRFoWRg1aJA0Z2jG8+vdhTWEWvD/0Bmv17sO4FeesO8MeK98RMnxWwq+4K7l0X7i14s5HsxU7FxHZUa0i6ozLZ1dUkwZSBmrToshaJwT3Kr0Dzm03SjTV0AaS4jwfZE6bzYnSlv+F2NlR+RRxhNLTnuvnws2pP5NoKuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6AZPV58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6AZPV58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB821F00A3A;
	Wed,  9 Sep 2026 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964545;
	bh=YrjrBBwKfUG1qIvGqEtp7n5dhrx01tYS0Du9LJFDRBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6AZPV582WHenYLdR/B0yf3YOaS1X35eWKItD7jaweIyIK2UFUgZPZ6yJBeTPcbp6
	 GyfeYZigLXhnNVQ4s9eBt4L9EoqwCQS0i47DiCOyfS1ZUfoqKu3YKmYEWn4R5FqunB
	 0YeY1F1tNSqRZ2JCJBBicZDMV+wvKrkgRrCgBOEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	Neill Kapron <nkapron@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 460/583] usb: gadget: f_fs: Fix Use-After-Free in AIO error path
Date: Wed,  9 Sep 2026 15:42:25 +0200
Message-ID: <20260909134253.854141594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Neill Kapron <nkapron@google.com>

[ Upstream commit e78dcb1f7ec271449c54984dc90c62a5ba272de7 ]

In ffs_epfile_write_iter() and ffs_epfile_read_iter(), when ffs_epfile_io()
fails with an error other than -EIOCBQUEUED, the io_data structure (`p`) is
freed. However, for AIO operations, the kiocb cancel function was already
armed and kiocb->private was set to `p`.

If a concurrent cancel operation (such as sys_io_cancel()) executes after
ffs_epfile_io() fails but before the function frees `p`, a Use-After-Free
can occur when the cancellation handler accesses the freed pointer.

To securely fix this race condition, we must properly un-arm the
cancellation. Invoking `kiocb->ki_complete()` does exactly this by
acquiring `ctx->ctx_lock` and safely removing the kiocb from the active
sequence. In doing so, it ensures that a parallel io_cancel can no longer
discover the kiocb, effectively closing the race window.

We then return -EIOCBQUEUED to notify the VFS layer that the kiocb has been
consumed and it should avoid attempting to complete the request again or
triggering subsequent completion handlers.

Fixes: de2080d41b5d ("gadget/function/f_fs.c: close leaks")
Cc: stable@vger.kernel.org
Reported-by: Xingyu Jin <xingyuj@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://patch.msgid.link/20260724235100.106011-1-nkapron@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1261,8 +1261,10 @@ static ssize_t ffs_epfile_write_iter(str
 	if (res == -EIOCBQUEUED)
 		return res;
 	if (p->aio) {
+		kiocb->ki_complete(kiocb, res);
 		mmdrop(p->mm);
 		kfree(p);
+		return -EIOCBQUEUED;
 	} else {
 		*from = p->data;
 	}
@@ -1310,9 +1312,11 @@ static ssize_t ffs_epfile_read_iter(stru
 		return res;
 
 	if (p->aio) {
+		kiocb->ki_complete(kiocb, res);
 		mmdrop(p->mm);
 		kfree(p->to_free);
 		kfree(p);
+		return -EIOCBQUEUED;
 	} else {
 		*to = p->data;
 	}


