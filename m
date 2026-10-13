Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BA4FDE60;
	Tue, 13 Oct 2026 12:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895103; cv=none; b=FO5YJYk6ze0M6fWs8sHlrOgWYsl5Jri9feOrnItlqZAqQEHTgNtcdRDfhJnBgioTwabx7oNeJiWK9KpVnH9hrF6X41B2m+ZilrVYCYfCPUyQ6Un254RUA6MWuZqb/Q2jUiGI8CuTyjllKgcPgsjKB2qMqzVbWoC0Jtlrfjmk3bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895103; c=relaxed/simple;
	bh=G3nFXOQpLrMyeRXi1xJ16oKB/PA+AWScizQxtP+qUvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1nhH3zcaLBr6LULRUFIP9kH2u2G9uww01Pntr74wT+Bimy25zZX77iJupDZ/KR5QvnFvgFFYAS542kb9SAFsseco8nVydpELqC4IMk19FGvFDYwZSr/ARSi2F2QqVU88nKUvUgX4+WFh2KNBgesggokMxduow4iqdKD/9Sp5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYNKIo/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYNKIo/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B961B1F000FF;
	Tue, 13 Oct 2026 12:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895102;
	bh=+qMuwoygSVbZKZREKeisca0XluJHD9XDcPDmEpcy1VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYNKIo/nPvLxCr6NJQl7X7oEtmSfhhyu5ohZduXx46EYF4f8nj6JaUUjxFZjLhreS
	 aQf2qwXLqCfEs4qg8PnoyLTZc+np1loxCoXDTh0vrDj19ZFXEPZ9pGsAYGpy1mObbW
	 rfFkxEgYJFCq279HwQVEElmgAaK0Bss0E2r7p79U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.12 161/497] tty: vcc: zero-initialize control packet in vcc_send_ctl()
Date: Tue, 13 Oct 2026 13:35:28 +0200
Message-ID: <20261013112911.711000888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

commit 1f71f565e3585da1098ff19ca3c24687dab59185 upstream.

The stack-allocated struct vio_vcc pkt was partially initialized,
leaving the tag.stype_env field uninitialized before being sent via
ldc_write(), potentially leaking kernel stack data to the LDC peer.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-1-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -492,7 +492,7 @@ static ssize_t domain_show(struct device
 
 static int vcc_send_ctl(struct vcc_port *port, int ctl)
 {
-	struct vio_vcc pkt;
+	struct vio_vcc pkt = {};
 	int rv;
 
 	pkt.tag.type = VIO_TYPE_CTRL;


