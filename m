Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F7D481DD;
	Sat, 30 May 2026 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160528; cv=none; b=Ip4qNJJBKnfVPruEzjj2e54Op5WOPIprfjHnKFG+EY8GlOS15bG5IH4m5rrbBki+ni3mzNr5OdHX4m6GSzaIpwdGMXIvsk8iI/gZoFzl+C8ffJoidumB1Hby6HvsJatg8BGUibBI6cCn8h6cbq7dFpi3boAhmZwDaQYz0ARn1YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160528; c=relaxed/simple;
	bh=olvpsoj+5b902jAupNNSQy+kMOIcbUReTdPZBvTgzPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L28FPtfiD+XN4JDZlYHsE8eqPLme40n//J5wWfS7j2/+2mHFm2+jBqDib7TAGKatIzZaTPsv8ZwXPgqKqFNFYUF3Zfzu9lE1lvZnC4KgUTzG+MO24m/AnmdI2FM4AaowKcdl3jbIOtoc8Iy9G8+ara1DRtkYJ4F0XnOUYguudhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsbI+wey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsbI+wey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9A11F00893;
	Sat, 30 May 2026 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160527;
	bh=xBFRQ/oa92s8kUDPEVr2Rfw9FAGvMEbl/s6y3N0GfsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsbI+weyNeLYrQS2MMHRayVITL1RQyBWMqQVA1g72JS7BMj+Zlw8hXHueFOzecYr6
	 WaiBK0th66uu8Jg2GZ4DxekVvZtaHLFTuNMc2NUMC54JjhcKKAIwoNn/JF4z1bb62E
	 DPI/ACm9NHLl3UPc5pgrcDT/KXg6phrifs4GWtE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.1 362/969] s390/debug: Reject zero-length input in debug_input_flush_fn()
Date: Sat, 30 May 2026 17:58:06 +0200
Message-ID: <20260530160310.329049897@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


