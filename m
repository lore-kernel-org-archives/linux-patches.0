Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119BA3EDE4E;
	Tue, 12 May 2026 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608791; cv=none; b=UsEtCPQcnfcU+8Ri7bKzYjyd0HplNEygjpJoftBXuKONQQmQS8UEH5ANOzb/oXJcp3sk8aQsrWM+LOu71FSb9GlT0D3gsndmmCdtXUKufXKToSnEiC2R4OPJ+sIyKSSRySZq1j2qW9imfTelIo9rjlozHoA5aJb2XVpP5HlYRjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608791; c=relaxed/simple;
	bh=a7xF+1S2zVsnrTy8J1Vrw0L3iitEI3PdUfMk2q/93CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tllvmYllj5NchvSa5wuU/h1QL2HAAO8Tppke9usADayB8e/+2LrCkGQDo25bWxX8Ag5K8H/sp2cJAY/nvtfgvdPf+5aFMxe2LwEcwe5ukmTFXqwgwDa0dry+AGDbfuE0e8IOXwCbuJAJYQMeyO7WUWZLdFbs7e0sISDGIQrMJ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLfYE/Rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLfYE/Rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D588C2BCB0;
	Tue, 12 May 2026 17:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608791;
	bh=a7xF+1S2zVsnrTy8J1Vrw0L3iitEI3PdUfMk2q/93CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLfYE/RluNxRcgZsYODsdMJ+7XInn3Y2RZZvwiWngiyByUlK+3NdtC38wNalhsT+F
	 Il+MemH2xeh0N8GrBr32lSOuGG1aGdUguhQAEQQ0hwqj1OcPJsQgXgbOjZHysgORr3
	 QJFgZxgLWzfKq7QvnWcrXz0uQ2rnJF/SMR+1s8Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.18 174/270] s390/debug: Reject zero-length input in debug_input_flush_fn()
Date: Tue, 12 May 2026 19:39:35 +0200
Message-ID: <20260512173942.110701402@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -1586,6 +1586,11 @@ static int debug_input_flush_fn(debug_in
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


