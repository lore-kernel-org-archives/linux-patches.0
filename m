Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD06D137914;
	Thu, 13 Jun 2024 12:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280815; cv=none; b=XtoAN670G0rQvPH9Byb4Q/hOpbKyKd/LOUudjB+EuVr6XTzHwlRMLSEcPnjh4rYquJXWStdCBE0c2vhwSSZl1QppcIuXwZAbm79LS+6TrNMz6PUCxkcFDZA51CVcsRIsEzBWtySkJxVhEGU5jl5GpYSt8ISBKNhweLFWwAH9LpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280815; c=relaxed/simple;
	bh=AH83VDn32fWqiOpwcktNCDxA4xUV5lhBXFTeZQxmGLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRLTzpQhSAvnZfDDG7OZyBv5kACeHX8XXujey1kCyXaWcxQXimZP6OB7S5TxOZFHWg/nv0c3hTNYDR+gYebvRZoYrQvph+K64U6yPJ/KpszM3mHX4TlKY6My/wBEzRnyYdREoKULLuCH1UEksx3n7FhNX+rEAbq7a4eHFq9ntB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLLU9DrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLLU9DrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DD8C2BBFC;
	Thu, 13 Jun 2024 12:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280815;
	bh=AH83VDn32fWqiOpwcktNCDxA4xUV5lhBXFTeZQxmGLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLLU9DrHnBU2Soi4hd05e8uvV8Z7LK+6WFJt4u1OyNhikl71FlMFrBkeIzX25f5Ub
	 85i5GxcFoNd5LapiKV0gOX1g37AcLUk03jNUV9C6ZNB1k4TJ8192eeoyOJfhr5xA1/
	 WcCG4GF1ZQkpkuaMzo3PMuSuBYtmjekRnxgX+Vhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/317] scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV
Date: Thu, 13 Jun 2024 13:31:02 +0200
Message-ID: <20240613113249.255555187@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/ufs/cdns-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index da065a259f6e4..408ba52671dec 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -135,7 +135,7 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
 	 * Make sure the register was updated,
 	 * UniPro layer will not work with an incorrect value.
 	 */
-	mb();
+	ufshcd_readl(hba, CDNS_UFS_REG_HCLKDIV);
 
 	return 0;
 }
-- 
2.43.0



