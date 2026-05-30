Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDDA2628D;
	Sat, 30 May 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163705; cv=none; b=KmCwtS/oag4Ier/LXqv7siiPst75SoLjhm/f9mb9fWIGzKwY/r97akpqQ9b5YGB03mHzYCuTaX5Tsn2xpoB4CEmpAydVKOFd8EAZQcFvoo6+RhGn8HVg1qlsh9aWb2EZVKrvEnAW611pdFi2yz9VSYtVGrMpXv2SXNShJTUE408=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163705; c=relaxed/simple;
	bh=SEyp8eeqA4TDjN4cy6ZGFsAI2cFbr31qtLMfFawDwYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ixi7VywTj7HDE01rmdOw+GV2o492XNIImI1oxr6/w1lnyvySf7nrbuVYX+U+H7CRPYiiNbiGqja7MCJ+Zqj25jGya9O+lh77XcV/4MjVOryt4lwQzEqL3WOWyFYrc7FRiuLXjzRCUjQIO2wuhiUz1+7wRJDDRCMx+0gmh1x4RWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTCUswbb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTCUswbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C99C1F00893;
	Sat, 30 May 2026 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163704;
	bh=+O9M9zYEU59O3u9j4wZDvzR4qkAJl5lGWD3/i9zL8AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTCUswbbOC9XHfmBaJsBXca3YTCru56QvizcSimhu0QpqyCwpNwSFR2WDna1ntf3x
	 o2ZIdcsmgkPtSIXdOlf27fKnQ1ORArRJZokKhRMv4iNnodeJsE7tbdtPN+J+JmZIzF
	 OPC3gK8AWV9nR7X2qkl+GJ3G78MPzLFJSV+MR7nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.15 338/776] s390/debug: Reject zero-length input in debug_input_flush_fn()
Date: Sat, 30 May 2026 18:00:52 +0200
Message-ID: <20260530160249.307998753@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit e14622a7584f9608927c59a7d6ae4a0999dc545e upstream.

debug_input_flush_fn() always copies one byte from the userspace buffer
with copy_from_user() regardless of the supplied write length. A
zero-length write therefore reads one byte beyond the caller's buffer.
If the stale byte happens to be '-' or a digit the debug log is
silently flushed. With an unmapped buffer the call returns -EFAULT.

Reject zero-length writes before copying from userspace.

Cc: stable@vger.kernel.org # v5.10+
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/debug.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -1444,6 +1444,11 @@ static int debug_input_flush_fn(debug_in
 	char input_buf[1];
 	int rc = user_len;
 
+	if (!user_len) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	if (user_len > 0x10000)
 		user_len = 0x10000;
 	if (*offset != 0) {


