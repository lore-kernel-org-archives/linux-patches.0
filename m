Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7783E0089;
	Fri, 15 May 2026 16:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861281; cv=none; b=iALF05dD8++rhRuxjgoxg8EVsqgCWb2MVkelJ910kKk1wYHha6ydPo7mD35hH/JuTffwxYlpsdmf8FNkuZMiLEXzCQ8sgR1D3j4hpLvnFVbHhbaym372QSCbkJImbAm7xVVsfUwZrz78gNYVMUk6UjmiSf6LRZ1mB1E3iMsv/Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861281; c=relaxed/simple;
	bh=fg7f7s7leu6m6taHYG4zqHssocY/K1eVdQUgQUkbyu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUAXsccUwl/KVApGO77U9EyGm2GtuRirWO4cex/BAsEcdlMKzxToCcD2mKOqLIyMiaSxyQWYZcNRONP1h5J0XfAzVbbOZaos1DHLBoI4IMhCLjGUQVy72+Eqmr61yA/n73gHSKQYkh2i0NQN/AnQsjB7w4Y3tbAMRE3cli0n1eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TV5MspTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TV5MspTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9301CC2BCB0;
	Fri, 15 May 2026 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861280;
	bh=fg7f7s7leu6m6taHYG4zqHssocY/K1eVdQUgQUkbyu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TV5MspTZtL22t97vfTABNR82CPgkX/fm3BF2jaGzO3xcu/3/AR21rl375Z4CGNrjk
	 XLTD8Oa5icIBUUf/7607TBA/mP+1eYQ2HdfPcFc5uIWBW346jmpMnb87Txfr7HClut
	 use/3GvTBLN7sOvnDSl5CGMSUum2xuq6/3TcpVQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.6 268/474] s390/debug: Reject zero-length input in debug_input_flush_fn()
Date: Fri, 15 May 2026 17:46:17 +0200
Message-ID: <20260515154720.800440190@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1434,6 +1434,11 @@ static int debug_input_flush_fn(debug_in
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


