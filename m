Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE174334690;
	Thu, 27 Nov 2025 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255644; cv=none; b=BpBH2BDNMCSyEDguldoyYGxbYTtweG+i369Ip+l1megiGZaMflSzBS/oIbM63w/E4XH7YlxX62Jf3palz+y+UIn1YN1IiwvGQvcFDER8G/r2+bSnaCvQFfaMTFgB4rO85BOAcqcVKuGRwZhqiYWkHe5tR0oB5Ob5lUSal/wgeFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255644; c=relaxed/simple;
	bh=alJw9fSXQFGql4ZiQ4eAFZChS0Qf1GgOgiwejlDkL7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8hfZHMDXORZa8aXecUvsW3M/GQxKuOuWgWPz5+WrhBAWFCsTc3T0UtmuitKLJKnmS9lg9fuqpMa+iJ+C8yuJVg10P8LIQ4l/Sp6xbLaYcYhgCjshBwrjKrQPwjpqUgsKR1+lk7TbhWelxWGn/YoHVMp//9cLrkptgLGAI5ZUTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL6iBNKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL6iBNKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE3DC4CEF8;
	Thu, 27 Nov 2025 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255644;
	bh=alJw9fSXQFGql4ZiQ4eAFZChS0Qf1GgOgiwejlDkL7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AL6iBNKdtzRHITNiOPCHLuwLR6nLVcJtYPZjRqwyukyJqv0ygutpOKRG4B9mlXFmy
	 NfW14u3qbJiUWuKBux83p7ngEdPfE8QHrdLaEqkxB0QNLC549UV6dYovfHv7zF4h7b
	 1gSnubQnPsBp3lpZD11YZeZF0DwHTtx0Ori+DCs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@h-partners.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.17 031/175] ata: libata-scsi: Add missing scsi_device_put() in ata_scsi_dev_rescan()
Date: Thu, 27 Nov 2025 15:44:44 +0100
Message-ID: <20251127144044.104824963@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Yihang Li <liyihang9@h-partners.com>

commit b32cc17d607e8ae7af037303fe101368cb4dc44c upstream.

Call scsi_device_put() in ata_scsi_dev_rescan() if the device or its
queue are not running.

Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
Cc: stable@vger.kernel.org
Signed-off-by: Yihang Li <liyihang9@h-partners.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4901,8 +4901,10 @@ void ata_scsi_dev_rescan(struct work_str
 			spin_unlock_irqrestore(ap->lock, flags);
 			if (do_resume) {
 				ret = scsi_resume_device(sdev);
-				if (ret == -EWOULDBLOCK)
+				if (ret == -EWOULDBLOCK) {
+					scsi_device_put(sdev);
 					goto unlock_scan;
+				}
 				dev->flags &= ~ATA_DFLAG_RESUMING;
 			}
 			ret = scsi_rescan_device(sdev);


