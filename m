Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69108BF8;
	Mon, 15 Apr 2024 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191589; cv=none; b=OlSKX0Ns9ED84/g+rwJZlcTFCRc+3WhYPdczj57Z//AFA4FD/dEsMQOOjgpLc4+tOj/33YpB6KeJpZViU/bhiUf3xs0J8eNb/RhNN7cD2cDiu4gH6vVHhv9/3Xj/SkUnJnx8U98rSGrJA9mVmrf5+PRRdzoaMcDZsYBhjunhyCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191589; c=relaxed/simple;
	bh=UjYAjyeRXtXqZKCFkPE+QWVCyE8hcPvw3L/ecbzWKps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYGW7uJ8BOHCrcgV8N8tcTQxdqHtVZBKYCd++lC48bJftCJlcRSbsRW4HKdOVgn82+BH/fzXRxALOZtuvIOHPEnkeaUOE5Y6nwaQpCNxbqEmvktXy4yeMduDIuST+oBY+R4t98YTkD/N4qUzqTQfCxVF99w4Cd+GDgypjuIeqIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUyCMKXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUyCMKXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DD0C113CC;
	Mon, 15 Apr 2024 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191589;
	bh=UjYAjyeRXtXqZKCFkPE+QWVCyE8hcPvw3L/ecbzWKps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUyCMKXRR15z9CJibXa4mfHEqp7arjSIjq+JDhL4CGwfzp3zjqHxxHIn1PMNaUPpa
	 fENrl+Uu8rRLDpZwYkiQKS9i1obpJPJeebKWXYZPEzdIPqqtBBQZg838CSUiSja+Pp
	 QBe5Pn3BEIfHO3kz9938h5vcNz5pvlVhq0cOJcak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.6 003/122] ata: libata-scsi: Fix ata_scsi_dev_rescan() error path
Date: Mon, 15 Apr 2024 16:19:28 +0200
Message-ID: <20240415141953.471519955@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 79336504781e7fee5ddaf046dcc186c8dfdf60b1 upstream.

Commit 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
incorrectly handles failures of scsi_resume_device() in
ata_scsi_dev_rescan(), leading to a double call to
spin_unlock_irqrestore() to unlock a device port. Fix this by redefining
the goto labels used in case of errors and only unlock the port
scsi_scan_mutex when scsi_resume_device() fails.

Bug found with the Smatch static checker warning:

	drivers/ata/libata-scsi.c:4774 ata_scsi_dev_rescan()
	error: double unlocked 'ap->lock' (orig line 4757)

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4780,7 +4780,7 @@ void ata_scsi_dev_rescan(struct work_str
 			 * bail out.
 			 */
 			if (ap->pflags & ATA_PFLAG_SUSPENDED)
-				goto unlock;
+				goto unlock_ap;
 
 			if (!sdev)
 				continue;
@@ -4793,7 +4793,7 @@ void ata_scsi_dev_rescan(struct work_str
 			if (do_resume) {
 				ret = scsi_resume_device(sdev);
 				if (ret == -EWOULDBLOCK)
-					goto unlock;
+					goto unlock_scan;
 				dev->flags &= ~ATA_DFLAG_RESUMING;
 			}
 			ret = scsi_rescan_device(sdev);
@@ -4801,12 +4801,13 @@ void ata_scsi_dev_rescan(struct work_str
 			spin_lock_irqsave(ap->lock, flags);
 
 			if (ret)
-				goto unlock;
+				goto unlock_ap;
 		}
 	}
 
-unlock:
+unlock_ap:
 	spin_unlock_irqrestore(ap->lock, flags);
+unlock_scan:
 	mutex_unlock(&ap->scsi_scan_mutex);
 
 	/* Reschedule with a delay if scsi_rescan_device() returned an error */


