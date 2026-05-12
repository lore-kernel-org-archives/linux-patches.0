Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E7A3E9C14;
	Tue, 12 May 2026 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608053; cv=none; b=Tei2aFrmGKhQBtMsSFBIE+guywKhrncCwEqUndwx91u/QgvlDp2BXKdTDqJbBPBc2ZbyVekCXJtUrQI5BaYekofpu223GVNLJ10lt8L9ySmw4MTaUR7BafCf1hf2Fawd1PyCYQVfo/YNw4aSW4uFO/SsiHGuNrnObqcooYdkwrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608053; c=relaxed/simple;
	bh=bN8bL2G62fFXSsI/ZAXK66OP8QadpxuVBweQ6elsQmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpzkC7K9lwlwX2DuLOmcxgGD7jsbk7Z3pe+HaYYqYDWK3sOD5qrU1qsja6rigJVKjfzR1cpz7iecaJOGk1MpvbnStr1YNeOsPgVp7O4nog3kZRl+ocXdgLcsty1tA34cbdmtFZmaoCEe7tWC28Yq4TYFR1999+A37XOhPCTCHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcA/qDFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcA/qDFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E324C2BCB0;
	Tue, 12 May 2026 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608053;
	bh=bN8bL2G62fFXSsI/ZAXK66OP8QadpxuVBweQ6elsQmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcA/qDFo+th4BQs2dBzmpzAtc2qVYXuAwXPwxOqpOugCjrtsHzV88unDTVTxMyWXV
	 w2HHJjNwlJMtPC6PV1B7lii9AUepXqtwluyF1y92QiuuWu6tLQiXfoeXxrXc+zmTeq
	 D7MF+9xqgIuKJmBAn2b/DWf3kLq+uzHLHC0B5DnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.12 136/206] s390/debug: Reject zero-length input in debug_input_flush_fn()
Date: Tue, 12 May 2026 19:39:48 +0200
Message-ID: <20260512173935.739820236@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
@@ -1432,6 +1432,11 @@ static int debug_input_flush_fn(debug_in
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


