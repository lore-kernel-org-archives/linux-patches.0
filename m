Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AE076C85;
	Wed, 21 Feb 2024 13:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521463; cv=none; b=jY+1w6DFGCTEmOuWGuIo+G/LmgftWnO5xLUxsvnKWvoEeiYdBBDBQTCBfixp9UFTkZ/SEWZ2k58KAaWdXrR5Ch8LDJXOmOpoB6LstjtzXPsioElDKrknvN44u0wBKJfQ5VUkF6putaLd2ySrjclY7K3oNwoUhOTg0ARqdrcK7mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521463; c=relaxed/simple;
	bh=zwTaaxmzfyoEdR6JlClTahT6m35k8pnQ776rNJLeKdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4HLUeOPsKZxq+9JttSPJogyX3H9D6q4pATD1gffIvl+SIV1mHZ9zYjtfp0UXzT7IBmD/b0oNg0qxuPz7T0CVI2pH5tt3kc/ftLCd18pC/cDaAtFO4Ux5m/iFuAWLKTGgoSgyCeMjO0Dsi6w3ib4CzvjnP31H3YXis8Atqo+Syk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAgquRcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAgquRcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919E4C433C7;
	Wed, 21 Feb 2024 13:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521463;
	bh=zwTaaxmzfyoEdR6JlClTahT6m35k8pnQ776rNJLeKdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAgquRcdRZG+j0C5YY9P4AnZ+NZSl5RmsJ54EWzyCC4CIXu7qcUtSW4R7ODaaoKpO
	 Hsl6zKSVrgeYvCeMR6wJsDwkDsxCpyuLQ/CV54l32lVdZZa1oHboX8mvYrwsoNrROV
	 l5pc9m8dZ65GLGKu2yepzNiEqxqjhNT6FfZk1ct4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/202] um: Dont use vfprintf() for os_info()
Date: Wed, 21 Feb 2024 14:06:59 +0100
Message-ID: <20240221125935.540458696@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin@sipsolutions.net>

[ Upstream commit 236f9fe39b02c15fa5530b53e9cca48354394389 ]

The threads allocated inside the kernel have only a single page of
stack. Unfortunately, the vfprintf function in standard glibc may use
too much stack-space, overflowing it.

To make os_info safe to be used by helper threads, use the kernel
vscnprintf function into a smallish buffer and write out the information
to stderr.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/util.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/um/os-Linux/util.c b/arch/um/os-Linux/util.c
index 8cc8b2617a67..0436cc9537e0 100644
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -166,23 +166,38 @@ __uml_setup("quiet", quiet_cmd_param,
 "quiet\n"
 "    Turns off information messages during boot.\n\n");
 
+/*
+ * The os_info/os_warn functions will be called by helper threads. These
+ * have a very limited stack size and using the libc formatting functions
+ * may overflow the stack.
+ * So pull in the kernel vscnprintf and use that instead with a fixed
+ * on-stack buffer.
+ */
+int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
+
 void os_info(const char *fmt, ...)
 {
+	char buf[256];
 	va_list list;
+	int len;
 
 	if (quiet_info)
 		return;
 
 	va_start(list, fmt);
-	vfprintf(stderr, fmt, list);
+	len = vscnprintf(buf, sizeof(buf), fmt, list);
+	fwrite(buf, len, 1, stderr);
 	va_end(list);
 }
 
 void os_warn(const char *fmt, ...)
 {
+	char buf[256];
 	va_list list;
+	int len;
 
 	va_start(list, fmt);
-	vfprintf(stderr, fmt, list);
+	len = vscnprintf(buf, sizeof(buf), fmt, list);
+	fwrite(buf, len, 1, stderr);
 	va_end(list);
 }
-- 
2.43.0



