Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8343FA5E6;
	Tue, 31 Mar 2026 16:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975311; cv=none; b=Jn74EBnItOcCznnx/1WeNPZooc0ttvykcoThHSyCUwLKMNFYWRcgGoqlO4eh0A8MOa5SWVzY/UyCLR7HtLBa78SEpkJMxUAoYE5idAVTlgCQ4xVMLBwB/5X3OxvwfwdHz2mIwiNpMtKoJJWD0hdpZLCf4PB8viS7HyDgC3xUnI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975311; c=relaxed/simple;
	bh=XKylVhbJe2jYycpV+CgVWOFR/DejjpEc6jYxX/6j4eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZecA7NmQ4cADIkwZxPvrFXtXCztUIi0Xyk3rUU49fG0iHcZQtPWZOiu7/m75THEpSuDg1jwKZlYa8yCMUYQ9wbUnOLy5Djh/jfEpStFbq4T+iM3UbsfCI2EblbH0oL+aj5k0udSAitmTDhARuotcydXSBUhjEU28cmh0xF3d04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d76WUjxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d76WUjxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E71C19423;
	Tue, 31 Mar 2026 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975311;
	bh=XKylVhbJe2jYycpV+CgVWOFR/DejjpEc6jYxX/6j4eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d76WUjxaDiaAGVVHS76YToZd+x6XhKqj7O9jrh2gUF3w8gdULVWtU3P87gnZlt7Lm
	 K5ACcbvS5VSHZ2qIBN27+BUad1UxEF5ZIyBGjaAWKr5gxj/A0cvMNMKYFzH0gk/KQa
	 k1YR17Ihr1iNJWc9WylFgsTnVBzif9sIsJvJXAxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable <stable@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6.19 246/342] scsi: ses: Handle positive SCSI error from ses_recv_diag()
Date: Tue, 31 Mar 2026 18:21:19 +0200
Message-ID: <20260331161808.015804135@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,7 +216,7 @@ static unsigned char *ses_get_page2_desc
 	unsigned char *type_ptr = ses_dev->page1_types;
 	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
-	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len) < 0)
+	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len))
 		return NULL;
 
 	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {


