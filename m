Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A5083CC8;
	Thu,  5 Sep 2024 09:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530380; cv=none; b=DkkaNX+x0/veLARRVNJcdzRCPBOm7bR3Ys1sl49Pc86Sxta9JSPz+ZuP0PFML1RlAVcgqm9647lUEpT7Qk9IdlCOKc8+zsJ65SL4i+s/HgqzG7BDXC+1MCC8PH0sFjOXaygKR+Qw7vLFebseuybCppz3Ep8mE0eUWw5mE9RbDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530380; c=relaxed/simple;
	bh=YFSxQajHyq6uHEx+B+E4YWhzFzwPBNMvOYgCC1VIPqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPypMjwQALf6aRtVS6vOPZDrYtPIcj+CYkka9VwWMKKYpApIv45OG0K7Bmt1J4qZPoKrukjtHyIe55OBHBeFlXZ7KYYjgfRjow2j1FnFKeIXX3c/ztHMIRTBYDV8psc3X8aCSpHvtrq9jk/g3zwGzoeaN5erqnkEUgBYx1vZ1ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBMibxmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBMibxmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FD1C4CEC3;
	Thu,  5 Sep 2024 09:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530379;
	bh=YFSxQajHyq6uHEx+B+E4YWhzFzwPBNMvOYgCC1VIPqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBMibxmoO1CL6fgk50H2mceoSOJ2SqeK1UiZirlA6nYyp9Y7tPzB4isUQoJrX9Ye3
	 EHWcyaL5aryIYkFHAalkF0XLAvAiQ4zhiaKjqbH36TSZwu02Na5Xy/8JCSRfPPsy4P
	 sdoEJ7yn4O4Tn3CMcHxKSxxtUnPiGYbg6J7d9o3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 132/132] scsi: ufs: qcom: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP for SM8550 SoC
Date: Thu,  5 Sep 2024 11:41:59 +0200
Message-ID: <20240905093727.343543493@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit ea593e028a9cc523557b4084a61d87ae69e2f270 upstream.

SM8550 SoC has the UFSHCI 4.0 compliant UFS controller and only supports
legacy single doorbell mode without MCQ. But due to a hardware bug, it
reports 1 in the 'Legacy Queue & Single Doorbell Support (LSDBS)' field of
the Controller Capabilities register. This field is supposed to read as 0
if legacy single doorbell mode is supported and 1 otherwise.

Starting with commit 0c60eb0cc320 ("scsi: ufs: core: Check LSDBS cap when
!mcq"), ufshcd driver is now relying on the LSDBS field to decide when to
use the legacy doorbell mode if MCQ is not supported. And this ends up
breaking UFS on SM8550:

ufshcd-qcom 1d84000.ufs: ufshcd_init: failed to initialize (legacy doorbell mode not supported)
ufshcd-qcom 1d84000.ufs: error -EINVAL: Initialization failed with error -22

So use the UFSHCD_QUIRK_BROKEN_LSDBS_CAP quirk for SM8550 SoC so that the
ufshcd driver could use legacy doorbell mode correctly.

Fixes: 0c60eb0cc320 ("scsi: ufs: core: Check LSDBS cap when !mcq")
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240816-ufs-bug-fix-v3-2-e6fe0e18e2a3@linaro.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-qcom.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1038,6 +1038,9 @@ static void ufs_qcom_advertise_quirks(st
 
 	if (host->hw_ver.major > 0x3)
 		hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
+
+	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc"))
+		hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
 }
 
 static void ufs_qcom_set_caps(struct ufs_hba *hba)
@@ -1931,7 +1934,8 @@ static int ufs_qcom_remove(struct platfo
 }
 
 static const struct of_device_id ufs_qcom_of_match[] __maybe_unused = {
-	{ .compatible = "qcom,ufshc"},
+	{ .compatible = "qcom,ufshc" },
+	{ .compatible = "qcom,sm8550-ufshc" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);


