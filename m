Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1613B19DE;
	Fri,  9 Oct 2026 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556776; cv=none; b=nFsT8CW2AsnNUgBRGOPQWFY8QAKUs/fZqaXTAPmrK/U/pPsHAQg14FrnUkaJFCPVf3eP8b6Vz1/sB/YP72pVQou/eSQa4Ta4G8caBlT9eGsD4HPWe9CkV4jUCIZTKmvFm98ubvpAsLXxbWRxHepq1StK+j5CSTQaZKnkfgrH7VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556776; c=relaxed/simple;
	bh=Gh0q0O9Ye5fuANMH+nbReYWVZeSf2c4PN9vO3VN/PU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtQJD+pXRALVMwfQ68u35gh3TioX7BmNMoasVYF90o2OWtt/Mh5smXOPFOI2rfhLplBwDnv9iq/z4Zj0CqNpvcmxLocCvAwh4/8uqkhG9LqLglLu/ZfmQkJ7ucmXYrnHJ66XsGCuBmVhLqe+rzizEtCLPxMX5Iko2atSEKKAUp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlPskY9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlPskY9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C27F1F000FF;
	Fri,  9 Oct 2026 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556775;
	bh=9ZImGcTPkH9opkhZMNTAsevrThyc/Y6PYPom8lCYf+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlPskY9L8kPLbWo1fO6eSn1RQ76DYUrFZf8Xhdsw7zPqEbpJMYNvWZBG/SLGF0ol3
	 mKZ0Szc64tg8jRa4KS3j6uZlJK98AQJKu+PFcDfuTDq3lqDkl3bL9TAA6unlxCciwM
	 TlzWIB+J93EG6O9uiivmdJonnwgNuG1JE/cIjG8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 7.2 240/428] tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup
Date: Fri,  9 Oct 2026 16:09:37 +0200
Message-ID: <20261009140951.382572217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 03b49c991abb8d021ca6fe51cd173447236b0552 upstream.

vcc_cleanup() sets port->tty to NULL without holding port->lock, racing
with vcc_event() LDC callbacks that read port->tty under port->lock and
then use tty->port. This can cause a use-after-free when the callback
dereferences tty->port after cleanup has already destroyed and freed it.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-2-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -986,7 +986,8 @@ static void vcc_cleanup(struct tty_struc
 
 	port = vcc_get(tty->index, true);
 	if (port) {
-		port->tty = NULL;
+		scoped_guard(spinlock_irqsave, &port->lock)
+			port->tty = NULL;
 
 		if (port->removed) {
 			vcc_table_remove(tty->index);


