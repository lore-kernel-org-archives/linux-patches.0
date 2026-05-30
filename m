Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936CE21E098;
	Sat, 30 May 2026 18:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166035; cv=none; b=ftB9YHhJJXVSPisI1qXQYvTHy7qP1JuTtyVSl223UPdf8C+r4s/qGsFKsAsthD8DNOogwMhLWM1b2P2k7ZDu7su7a2si+k5GHOi80iJlIkHY3aQpeIfWe6JNhqPX7le+zGSEuhXDqlNoZ/Qo15W1pFkzzxI1NhGe/8sndUyqpYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166035; c=relaxed/simple;
	bh=mHSC+eQtuTdifPJF/2ZStnFfzS3UoYclR0JBndX7riI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiQ11pJu/7sNT5G1RYCt74lyiqBSR5tG+Sl3N+yM21qtmf40ct2U9RnWLwqiNLOn7ZacJrsWMCaryOqgsqziFuEE/3QmM9s2VMKKCaRc1yj5cxivsbkLM/GdcZ4164ifanUcJ7LPkdd/CDh1oEjefMt/0juA/6KhoquSzGCvmW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yztp3T6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yztp3T6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24F11F00893;
	Sat, 30 May 2026 18:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166034;
	bh=QP4ed4G9Y9nmNV6zMW9mCgKkKtgOSl99BBdHRNiztSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yztp3T6ua+YH+0TIlZ4xhdH1m017EZmFGvKrstinJBHzwNqkKgjmkwHdgr/70NOvk
	 FU6ZFfcirZ5aiNBv6rcuVlNZhLetKd0Sfk2crWfEb5Z0tOdyy4yuPyhd2zZ76gLp11
	 gSA5opNMwrhxQVu3cp+9R0wHCamSNuedAPFhcDHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.10 255/589] s390/debug: Reject zero-length input in debug_input_flush_fn()
Date: Sat, 30 May 2026 18:02:16 +0200
Message-ID: <20260530160231.682552558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1387,6 +1387,11 @@ static int debug_input_flush_fn(debug_in
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


