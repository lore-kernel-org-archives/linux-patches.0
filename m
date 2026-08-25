Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC83459AD7;
	Tue, 25 Aug 2026 13:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665758; cv=none; b=Y/3m1FhkpSBpOVdTdAKqc3tsWPwpn8hoGrZODQcBEMq9QIkoo5G8DGPOz7C2IUUeRyxIp2HAKOW9BWf6QDuzMq72nXlUSixEnr4FI+3gqOgIV9DyzdP4jEXqIC1Ft7/ovGQNOhJyoTaibnQzc1dXJiTogUd8Szvay6Da53x9Ggk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665758; c=relaxed/simple;
	bh=CYUZHe7Et3csZwPSMjLJwYcSZvneB3P3fbeocEEiiW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sP1Acew9IQcLAB0Pel+JoJd+Er3gy27afObLXh8I8HALEST+4ppqZdGh1+WJqkDiBlduB3l1fVqbDDxQY14GtUR5arqMMPueVA3ixqkKQ5cnASayLMx/LNCFQ1ukBGvxYOyL1vx/8jxscGf4+lb5Z+DkhTi3OI5GCmRg9HEeUDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEqetS2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEqetS2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E241F000E9;
	Tue, 25 Aug 2026 13:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665757;
	bh=GfKyYm1OD3CZX6Gxqp35nQ6ALW2NBI3XCwHGQ1bscHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEqetS2/Jxj3VSp+esgzgSLqydBY6/TDBR32xuzXe8m3MExVaAr3wIYx+2rVRU9bm
	 1afQ1rsSSdBm/2HUzV0mL2vF+YfKPQV8AbQw6eLMDqsGyjX0ZGpyl275DnJQkGfP9F
	 MFkT0o9TuFV4ur/JkTKwDm+7zAeedZBShAr18BEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 54/87] nvmet-auth: zero the AUTH_RECEIVE response buffer
Date: Tue, 25 Aug 2026 15:26:17 +0200
Message-ID: <20260825132543.962454521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 3ddcfb013322aa37eaa7a0d344b73079c38dfa21 upstream.

nvmet_execute_auth_receive() allocates the response buffer with kmalloc()
sized by the host-supplied AUTH_RECEIVE allocation length, but the
DH-HMAC-CHAP builders write only a fixed-size message into it. The full
allocation length is then copied to the wire by nvmet_copy_to_sgl(), so a
remote initiator receives the bytes past the built message -- up to nearly
a page of uninitialized slab -- during the pre-authentication handshake.

Allocate the buffer with kzalloc() so the unwritten tail is zeroed before
it is sent; conforming responses are unaffected.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -475,7 +475,7 @@ void nvmet_execute_auth_receive(struct n
 		return;
 	}
 
-	d = kmalloc(al, GFP_KERNEL);
+	d = kzalloc(al, GFP_KERNEL);
 	if (!d) {
 		status = NVME_SC_INTERNAL;
 		goto done;


