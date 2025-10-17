Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8055930CD9F;
	Fri, 17 Oct 2025 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714478; cv=none; b=msA8C3scoG1ZDF6DpNmAJZt9MgnPBhTvtyJekPO/hx2OiwRZtCqmNTV7N3xwpqtyPjjlpBKV2WjCHn4g7Vi6zL5qgdTUci2IrDn5J4BRm1oI9JIo6jGEWh2QZbc6g5UfigtxGf04kCGV4kXpas8ZAXfz0xPJqVByQTX3u2Ctfao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714478; c=relaxed/simple;
	bh=ZgdicFh4oXog7jrWCWpfNN9bgwfbiXQwFnZMX967COQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0rVHiL2ENwjzdefyRmKWh0Mb2i5EtQKW49E6jzKUqTjPfeCzY7bRP3zTWmDn3yWM5Y62ylHMycO4J40sUDBPdK0c7Ic4dffGOzYne9VMOX+OQd9pr2rswFurmS3M/B85QUwzhQK9dvAWDBxnZhBqy0YGBCqSaCms9hc7iUj24s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD9gEhKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD9gEhKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07835C4CEFE;
	Fri, 17 Oct 2025 15:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714478;
	bh=ZgdicFh4oXog7jrWCWpfNN9bgwfbiXQwFnZMX967COQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD9gEhKo8Dw1scugMo0qakOmT4nDcs2hejzqvEI9fGMKI8pC9N+4Q2BxIwr3K968u
	 YzSGoA3yADS8oesH9MFcCRWLG2N0OgRLE9bMn3a/AvYbwUsDWPb/RTEzmkx9+NWV2v
	 E3XErc62GnDiOWM+S92ZQCjk2us6sdUUg0Jqex/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>,
	Eric Hagberg <ehagberg@janestreet.com>
Subject: [PATCH 6.12 159/277] Revert "ipmi: fix msg stack when IPMI is disconnected"
Date: Fri, 17 Oct 2025 16:52:46 +0200
Message-ID: <20251017145152.930412912@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Corey Minyard <corey@minyard.net>

commit 5d09ee1bec870263f4ace439402ea840503b503b upstream.

This reverts commit c608966f3f9c2dca596967501d00753282b395fc.

This patch has a subtle bug that can cause the IPMI driver to go into an
infinite loop if the BMC misbehaves in a certain way.  Apparently
certain BMCs do misbehave this way because several reports have come in
recently about this.

Signed-off-by: Corey Minyard <corey@minyard.net>
Tested-by: Eric Hagberg <ehagberg@janestreet.com>
Cc: <stable@vger.kernel.org> # 6.2
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_kcs_sm.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/char/ipmi/ipmi_kcs_sm.c
+++ b/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -122,10 +122,10 @@ struct si_sm_data {
 	unsigned long  error0_timeout;
 };
 
-static unsigned int init_kcs_data_with_state(struct si_sm_data *kcs,
-				  struct si_sm_io *io, enum kcs_states state)
+static unsigned int init_kcs_data(struct si_sm_data *kcs,
+				  struct si_sm_io *io)
 {
-	kcs->state = state;
+	kcs->state = KCS_IDLE;
 	kcs->io = io;
 	kcs->write_pos = 0;
 	kcs->write_count = 0;
@@ -140,12 +140,6 @@ static unsigned int init_kcs_data_with_s
 	return 2;
 }
 
-static unsigned int init_kcs_data(struct si_sm_data *kcs,
-				  struct si_sm_io *io)
-{
-	return init_kcs_data_with_state(kcs, io, KCS_IDLE);
-}
-
 static inline unsigned char read_status(struct si_sm_data *kcs)
 {
 	return kcs->io->inputb(kcs->io, 1);
@@ -276,7 +270,7 @@ static int start_kcs_transaction(struct
 	if (size > MAX_KCS_WRITE_SIZE)
 		return IPMI_REQ_LEN_EXCEEDED_ERR;
 
-	if (kcs->state != KCS_IDLE) {
+	if ((kcs->state != KCS_IDLE) && (kcs->state != KCS_HOSED)) {
 		dev_warn(kcs->io->dev, "KCS in invalid state %d\n", kcs->state);
 		return IPMI_NOT_IN_MY_STATE_ERR;
 	}
@@ -501,7 +495,7 @@ static enum si_sm_result kcs_event(struc
 	}
 
 	if (kcs->state == KCS_HOSED) {
-		init_kcs_data_with_state(kcs, kcs->io, KCS_ERROR0);
+		init_kcs_data(kcs, kcs->io);
 		return SI_SM_HOSED;
 	}
 


