Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AF02B9BC;
	Tue, 16 Jul 2024 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146110; cv=none; b=n7NgpZfNTJ0yDzncUUD63KfhMJKDUgOfWYlJ9I/GDAD78QOhCvhdkB542c2pMi75TRiCCWR60H0exMQG8uMK9Ht1GUOF+LupZig8LK5TjISvO7Sx5gkybeygOkMAN/S/gXiojUSmimCQtNsDCL4Dt5V6jmivO0OvIoQqZvEiMHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146110; c=relaxed/simple;
	bh=AXJC/ciAolZt45GxSZVhK4EqdYv6NNDcDPyM9QOgEWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzHtxX25VlcOCvELMWcORT+7PbdUHrf+3+/2xTrxCjSW4wSX0m5gb/DoTh3C3DkaWD3M1B+t/IcQNS32GtdEWAYMaxWAttuHoCTpLUdRtj+CSUs/eOzO0DYByfZz637fiWXAzTCuz4LpcNF/UrrVC/jVM4e68kU+XYDCRk157K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArmfSMiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArmfSMiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855CCC116B1;
	Tue, 16 Jul 2024 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146109;
	bh=AXJC/ciAolZt45GxSZVhK4EqdYv6NNDcDPyM9QOgEWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArmfSMiUO74ft5Sy4//sTDJY6bzakPvA3PgSjktmgz06nbdhMkQLFg4HEzgao6i1d
	 WkznVEGkztOygvAePSbLUepAPOS8znPSIyXbON894BRhPTAJi8b1t5s0E3j26YLKcP
	 H5HPm2/oqYYWdzDah7gV3/rZHSXjxE+VzHc/i2fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/144] s390/pkey: Wipe sensitive data on failure
Date: Tue, 16 Jul 2024 17:31:38 +0200
Message-ID: <20240716152753.660229225@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: Holger Dengler <dengler@linux.ibm.com>

[ Upstream commit 1d8c270de5eb74245d72325d285894a577a945d9 ]

Wipe sensitive data from stack also if the copy_to_user() fails.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 34e1d1b339c12..43dd937cdfba1 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1170,7 +1170,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (rc)
 			break;
 		if (copy_to_user(ucs, &kcs, sizeof(kcs)))
-			return -EFAULT;
+			rc = -EFAULT;
 		memzero_explicit(&kcs, sizeof(kcs));
 		break;
 	}
@@ -1202,7 +1202,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (rc)
 			break;
 		if (copy_to_user(ucp, &kcp, sizeof(kcp)))
-			return -EFAULT;
+			rc = -EFAULT;
 		memzero_explicit(&kcp, sizeof(kcp));
 		break;
 	}
-- 
2.43.0



