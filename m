Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B873D7D69;
	Thu, 15 Jan 2026 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499921; cv=none; b=hUDQa+YtAfNGyQnTEOlENGc7fplnjXs9MSF2u96K2RfsB8qkvU3qmXCrRF+qw0lZB5PEGG8Wsb/e9FMqradNqqhITRsS8e15rWgnI96dmzmbEDkrwUm5gS1q3kSyIVSO0AaAiFn+ZGDqS5FdE1jYgKFIYxZSVC8AbTfJb0nnNJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499921; c=relaxed/simple;
	bh=W4sP4csE6KKCLnfKb0TWObbWVScfRHdA9RcDjONxy3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obDX7LLQ5B0HRMmF37AQQwFP91m+o71qx7ZkBwJrrKkNghI9iDOP/ueD5t8rcxBkyol9GWA/+buoO2PsGeNgw1jv5XQeKLcLkFOZVdwg1C4oodkFaoLCI2sQrMiTCDeHu7QnLXqWKtxPp/c2exh5ObSRfez3w19Enhfuh1rLxvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7QVrrkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7QVrrkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FCCC19422;
	Thu, 15 Jan 2026 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499921;
	bh=W4sP4csE6KKCLnfKb0TWObbWVScfRHdA9RcDjONxy3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7QVrrkLPSpacs9yGizWvzjpGhi2kKQ5N6AJEwLDnthOJ3CAmYgdFaRonOyOi0gjU
	 CURv+wsehpQlgOLSvdMaKhp7zyj2fY5iLvOH2ZI1hJVmrKoJdTNesIJt7mupDOJ/UJ
	 Qp1/47e2nnLm53SQ4XAiBDe7y5gmX/TZarRfFp8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, vamsi-krishna.brahmajosyula@broadcom.com, yin.ding@broadcom.com, tapas.kundu@broadcom.com, Shivani Agarwal" <shivani.agarwal@broadcom.com>,
	Lee Duncan <lduncan@suse.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 395/451] scsi: iscsi: Move pool freeing
Date: Thu, 15 Jan 2026 17:49:56 +0100
Message-ID: <20260115164245.223934708@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit a1f3486b3b095ed2259d7a1fc021a8b6e72a5365 ]

This doesn't fix any bugs, but it makes more sense to free the pool after
we have removed the session. At that time we know nothing is touching any
of the session fields, because all devices have been removed and scans are
stopped.

Link: https://lore.kernel.org/r/20210525181821.7617-19-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libiscsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2902,10 +2902,9 @@ void iscsi_session_teardown(struct iscsi
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
-	iscsi_pool_free(&session->cmdpool);
-
 	iscsi_remove_session(cls_session);
 
+	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
 	kfree(session->password_in);
 	kfree(session->username);


