Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7B2248BA0;
	Wed, 15 Jan 2025 10:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937816; cv=none; b=nG8frx2/FVLpVEahD3qTrRb5jPDYRzjjmDZB1zjSxA8TXpnX/7FPYP3URJlmNQEiw4eNS0k3OjvZ8L3y/3KfPWnsGp6P/piAFqY30oqKOK8pE5M7LMDH5pMXU2V1Keb6R+oPuONlw3sTu1+i4AekUqj2FynsNAwTdZgMPU/iGCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937816; c=relaxed/simple;
	bh=kd5UG2c3zzaTbtl1jwtiPD2uVVbK+bSUkB9dvVxnnwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixedsElyNPM06JafMpfPpbDSBeLKpAN2FC+V2mNO46DL2OMgxn6T2JWtI6xv9btYfsxpU7SZJpm3TiFf9pG7hkMMHTn7VZ6CiSjfyx1i3+HpnKaoxqJ49AdcfVSa+I8RxBJAKkKKIvlPmdG7fkQg7DaRZLLcWVogr+RgCsEMWm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTk+gMx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTk+gMx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F90AC4CEE2;
	Wed, 15 Jan 2025 10:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937816;
	bh=kd5UG2c3zzaTbtl1jwtiPD2uVVbK+bSUkB9dvVxnnwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTk+gMx938f4iyK34jH0nnDmck60FTfCLw5YVBxp+SWyR5ZoiXCH1p0K4jG1zVEWI
	 6+yxcY+r8Y97CQ9BSiu5oiPmZdiGD9OatT412mXRybZJqJP+fqX7K9Mp6oLFnJ2djb
	 ZZ56Wo4SOPiE4Gb4VCW5GEIsQ1eCeV0+vjyPMdEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.1 61/92] misc: microchip: pci1xxxx: Resolve return code mismatch during GPIO set config
Date: Wed, 15 Jan 2025 11:37:19 +0100
Message-ID: <20250115103549.994647500@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rengarajan S <rengarajan.s@microchip.com>

commit c7a5378a0f707686de3ddb489f1653c523bb7dcc upstream.

Driver returns -EOPNOTSUPPORTED on unsupported parameters case in set
config. Upper level driver checks for -ENOTSUPP. Because of the return
code mismatch, the ioctls from userspace fail. Resolve the issue by
passing -ENOTSUPP during unsupported case.

Fixes: 7d3e4d807df2 ("misc: microchip: pci1xxxx: load gpio driver for the gpio controller auxiliary device enumerated by the auxiliary bus driver.")
Cc: stable <stable@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20241205133626.1483499-3-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
@@ -148,7 +148,7 @@ static int pci1xxxx_gpio_set_config(stru
 		pci1xxx_assign_bit(priv->reg_base, OPENDRAIN_OFFSET(offset), (offset % 32), true);
 		break;
 	default:
-		ret = -EOPNOTSUPP;
+		ret = -ENOTSUPP;
 		break;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);


