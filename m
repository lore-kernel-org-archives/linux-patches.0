Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931B5155CBA;
	Mon, 16 Sep 2024 12:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488287; cv=none; b=bKUltMvJiCg75CEpRWEqAEpbud1E4OJiOEMEBFqAch1oYRqUB1s81g1VgWACE5BN3OKe2LNkcPoAg6h7+T2PsRGnxbBgsPnFxRm2vz1CHf1Ei0K6y2n+i6zsrRZEFqMrEEnUj+STLqCUq8FBbIf0fsj6U/sMxmwjqJIdPi6VG/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488287; c=relaxed/simple;
	bh=EgV4LaZP8HkC6hncPDasiuIj/nq+l+ozZEMsApVVcGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bwf7gNk4UkpqPWrsdgNu36NEjZlA5u1YydYYuiJmdzPwtkV6LQbLrd5PA9R6GkrFvlalk184I9aTJCQ+s6c5XXEt0lvFPyXUErAT6ob6pHsemAC5TUG60R6dH1C4lOOiLrlGPakp7t9emTXTORywLDtl93ogq4oT6twrDI6t09g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1YhpHFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1YhpHFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C204C4CEC4;
	Mon, 16 Sep 2024 12:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488287;
	bh=EgV4LaZP8HkC6hncPDasiuIj/nq+l+ozZEMsApVVcGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1YhpHFG2NY0CV0f1/Q/ORV3dSm4HoRiDeGUQYHTxWrN/iP6t5Hc6g30Xcfd7tePL
	 w92oVeFKlH8ZWhu1aN16rGLXIuzssKYonl9jFXByQIGbC9ZiO2RW2bHQLlNuwzP9Vl
	 8sngbBUIjPTc4nOgxkeHY1rg0A+sBicHz5TSC/J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 060/121] firmware: qcom: uefisecapp: Fix deadlock in qcuefi_acquire()
Date: Mon, 16 Sep 2024 13:43:54 +0200
Message-ID: <20240916114231.148806358@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit db213b0cfe3268d8b1d382b3bcc999c687a2567f ]

If the __qcuefi pointer is not set, then in the original code, we would
hold onto the lock.  That means that if we tried to set it later, then
it would cause a deadlock.  Drop the lock on the error path.  That's
what all the callers are expecting.

Fixes: 759e7a2b62eb ("firmware: Add support for Qualcomm UEFI Secure Application")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/19829bc4-1b6f-47f7-847a-e90c25749e40@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_qseecom_uefisecapp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c b/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
index bc550ad0dbe0..68b2c09ed22c 100644
--- a/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
+++ b/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
@@ -786,6 +786,10 @@ static int qcuefi_set_reference(struct qcuefi_client *qcuefi)
 static struct qcuefi_client *qcuefi_acquire(void)
 {
 	mutex_lock(&__qcuefi_lock);
+	if (!__qcuefi) {
+		mutex_unlock(&__qcuefi_lock);
+		return NULL;
+	}
 	return __qcuefi;
 }
 
-- 
2.43.0



