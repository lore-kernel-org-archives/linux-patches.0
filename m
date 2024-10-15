Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F77213F435;
	Tue, 15 Oct 2024 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992630; cv=none; b=Env3C8wsOOjettD68Gz4Cy3t0GFUHk8TbwNYmGz8z9ZpzDVTThb2LoeoJVgI0W5xrdp9H5TvHIhCJTB22NoX7T03zdfqfg1jprTacR93AtPh0QpIOZK03Ru2XhC1Kf/uEkJq6sgS045vbRsVQnD8ArVMmEbFZU9OzfCAXxg8wHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992630; c=relaxed/simple;
	bh=WM0RR12tfSghzmG5Oeat7StLUc+OV24UPfcWSehkfFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc21S3D1EGxsgBhfKzrDy+0R1sTuh43y5HeqbunIfGYEgxLqgiflMH7ou6qWPVD3PTuA+4EDsEmEUpfuaTzOSa/FW/E/7nE8ePyjYSIAmYNUFTpINhVttvI8pKV8w7RH5HpE1zPMT+4JtOFzVgqvfsW/MzJT6IYY039ZNQ9QoWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCzz9wUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCzz9wUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CC0C4CECE;
	Tue, 15 Oct 2024 11:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992630;
	bh=WM0RR12tfSghzmG5Oeat7StLUc+OV24UPfcWSehkfFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCzz9wUqhPtSNZlne9udI25rpM6Tp4sq4UangkuUAYyxJ3rCCKG26CyTfLrAUFooh
	 u3ZtJxeUq0SCxtt3C7acnPw1UQ+v1bHIa+RtIf9jBzaIIr9c8FCcdUvEPZR0TpF5cG
	 GmHm5bKCfsM2RT/ft8Q7HM+ZALEqXTO3VNVzOAik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/691] scsi: elx: libefc: Fix potential use after free in efc_nport_vport_del()
Date: Tue, 15 Oct 2024 13:22:00 +0200
Message-ID: <20241015112447.193069420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 2e4b02fad094976763af08fec2c620f4f8edd9ae ]

The kref_put() function will call nport->release if the refcount drops to
zero.  The nport->release release function is _efc_nport_free() which frees
"nport".  But then we dereference "nport" on the next line which is a use
after free.  Re-order these lines to avoid the use after free.

Fixes: fcd427303eb9 ("scsi: elx: libefc: SLI and FC PORT state machine interfaces")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/libefc/efc_nport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc/efc_nport.c b/drivers/scsi/elx/libefc/efc_nport.c
index 2e83a667901fe..1a7437f4328e8 100644
--- a/drivers/scsi/elx/libefc/efc_nport.c
+++ b/drivers/scsi/elx/libefc/efc_nport.c
@@ -705,9 +705,9 @@ efc_nport_vport_del(struct efc *efc, struct efc_domain *domain,
 	spin_lock_irqsave(&efc->lock, flags);
 	list_for_each_entry(nport, &domain->nport_list, list_entry) {
 		if (nport->wwpn == wwpn && nport->wwnn == wwnn) {
-			kref_put(&nport->ref, nport->release);
 			/* Shutdown this NPORT */
 			efc_sm_post_event(&nport->sm, EFC_EVT_SHUTDOWN, NULL);
+			kref_put(&nport->ref, nport->release);
 			break;
 		}
 	}
-- 
2.43.0



