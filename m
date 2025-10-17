Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23E4330B09;
	Fri, 17 Oct 2025 15:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715545; cv=none; b=gZ9fuuM1YrbGTyGdRzR6vZnv/C8i9rogh873jae8cTNL8sm7sfdzi4Lp27+C6YFz0Yrl+pVk3VsSh1FzZMO87ipPmjlXRVL8oO3oeBKr8Kl7+eUiYrOhNMq1MvwRyj+l+2ouzmYFw8/0cybwH4MBnf9q/JbDNnKkMuBdm9sHRTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715545; c=relaxed/simple;
	bh=ARujz2a98pzGFpGAUWmbs2DeaeIubSE82hC0RqRLS84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fubwwdV2t2gcm7D+uHmWZeL/oLeUNq0cLFxQm2vrflezJuUr2omraxur3OlS/uMm+23csc/t6LQRgkGsX0cI1DNpKgRcKxH9edE61l3b0jQPYvgCVYpok6joTfAFsUx6q/RryTbs0w7PPe6AgoaJaVxUZ5AWKCjUuw6UfC/NZPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6B1PDHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6B1PDHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F35C4CEE7;
	Fri, 17 Oct 2025 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715544;
	bh=ARujz2a98pzGFpGAUWmbs2DeaeIubSE82hC0RqRLS84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6B1PDHprx570C2qQ1Vz20khZCz+dRFPoQZp367vo8EqqyfGDDjTQ4eDIJ9ABq9XB
	 f4AUIG9SnfKrxu7HzUPZYEI0xP3FrpHhC66jW7KaTmmm70/KOR6Y0ym3qF1vo6a8sE
	 i80mJwUG7pUD5SDRbmYyMilxH0gpL+9vSlBqLRYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>,
	Eric Hagberg <ehagberg@janestreet.com>
Subject: [PATCH 6.17 253/371] Revert "ipmi: fix msg stack when IPMI is disconnected"
Date: Fri, 17 Oct 2025 16:53:48 +0200
Message-ID: <20251017145211.233428865@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 


