Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9B347517;
	Wed,  8 Apr 2026 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671876; cv=none; b=t4qg53a50m0VKdb8Oc9X0X8AHZ/ivVihCO92By1tZpsQm1xURdluQ/cxCXohHQUWi2ziQyHAyBp4d/ZjGU1q2Cs03wOnlKS/3iiIqtTWUjQ7+py2l9KnfVPZCM3dkDScKPzxoBI9l25N276lkDJhnvLkWFgNOfGXhVdJynAHvrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671876; c=relaxed/simple;
	bh=bMi7EjPxuVoFhGHeLpzE+vn9UZwa45rN8nOCeDT8SWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz1DXGCRhW2Qa3wuw9UiR8lJBEtHZthXfykToD7MMhIaQaKcVdS/wwruqpcB4bU2McIatMOBt3QbnLqpyHokaB3kI6TPQ0+ysD88Hf0218HnP76Vsy4XUo3hZH6L96MG/GuiCnPbGbxrS/G4RiiiZrNwyXeK57pu3Dhp7a7+dMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5yPrAWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5yPrAWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FBCC19421;
	Wed,  8 Apr 2026 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671876;
	bh=bMi7EjPxuVoFhGHeLpzE+vn9UZwa45rN8nOCeDT8SWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5yPrAWsXy76EL66ia9bFb/qO0ghZlsdd2KYuLHqLu71krPMOHScRNpFVyqMRrwDx
	 co359D3lCAErrLK2/8ELzM5vqxj4Un3UgLO5Q3OMh/xC/jtOwKdWcYZExvMKpXr3WU
	 YYSK0dqGs8j0ArtmXfr+5/8hNI+EA94HkYbCXZOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable <stable@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6.1 103/312] scsi: ses: Handle positive SCSI error from ses_recv_diag()
Date: Wed,  8 Apr 2026 20:00:20 +0200
Message-ID: <20260408175937.610667712@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7a9f448d44127217fabc4065c5ba070d4e0b5d37 upstream.

ses_recv_diag() can return a positive value, which also means that an
error happened, so do not only test for negative values.

Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://patch.msgid.link/2026022301-bony-overstock-a07f@gregkh
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -184,7 +184,7 @@ static unsigned char *ses_get_page2_desc
 	unsigned char *type_ptr = ses_dev->page1_types;
 	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
-	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len) < 0)
+	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len))
 		return NULL;
 
 	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {


