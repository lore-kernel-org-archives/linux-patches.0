Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C3199EB5;
	Thu,  6 Jun 2024 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683262; cv=none; b=QxD1B9bH7VCAHaLqoSl04a7nuqXT1buks6IGX4WYd9lZwTGKVQDdMrpT08EshzLzQM62gzGI1VJbZXUZZl/FK01en9/8iK9Wbm+m1IcvT1wmoU6mCtksMJaSzhT7nzufmvcjzx14pqFDlFT2MWpTCl+IJX5fhOl3aYBL+7meLmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683262; c=relaxed/simple;
	bh=A3TOCVZ/I4oUQA13+fV9+dH+6l/RJ9JokZIPtL4OnV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLdrdjlgkSTAxOWch/8mYnlJtz8fRg4mzmbIcQyYCvBlV2s3MLdk7DuFVKzdOD0GjX79OoaOysNf+8yYlTT9wLkTpqlF/ZEUmAT5dB94SSeq+buFlkSXPt06o/bkNwba6Fxa/wRtGeDUNA1OFIYJcp79d3pwqkWQZsfEsfhTqxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAqrTnhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAqrTnhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D700C32781;
	Thu,  6 Jun 2024 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683262;
	bh=A3TOCVZ/I4oUQA13+fV9+dH+6l/RJ9JokZIPtL4OnV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAqrTnhZpsnscvsX0nSTcFDr4KEALxaaxM5Nj498SWYJZpQlZ5GUi8WSTuGNmdEQl
	 5kpPekXzUnhhRimxgANuKIb+aB1ZxIQOe6zG9DaS4+R5Q1YXa/G9MBjWBGTHUqiVFV
	 Y5ndHE2qgMmip1t9azACfDrLJCw4As2NGw8jAzVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/473] scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV
Date: Thu,  6 Jun 2024 16:00:38 +0200
Message-ID: <20240606131703.524679160@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit b715c55daf598aac8fa339048e4ca8a0916b332e ]

Currently, HCLKDIV is written to and then completed with an mb().

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s purpose
wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: d90996dae8e4 ("scsi: ufs: Add UFS platform driver for Cadence UFS")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-6-181252004586@redhat.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/cdns-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index e05c0ae64eea4..38a238eaa2133 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -137,7 +137,7 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
 	 * Make sure the register was updated,
 	 * UniPro layer will not work with an incorrect value.
 	 */
-	mb();
+	ufshcd_readl(hba, CDNS_UFS_REG_HCLKDIV);
 
 	return 0;
 }
-- 
2.43.0



