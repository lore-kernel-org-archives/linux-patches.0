Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8F02874FE;
	Wed, 28 Jan 2026 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615954; cv=none; b=shM1D4cgDnLwsdtrSfKY32tvYIMYND9E8cTVSHkkMxkmNbByk5po+tn25OF7+YTxSvQDZXqm08bm75X3kI0uB4I2PjVxywSCH6KF5i+Nhr93hRXjU028WahaKlq64YvC/mrS96v4AaIVvIah/KlchjvnkefA5CXUGKW+obGLNEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615954; c=relaxed/simple;
	bh=E7NPyEpMhe4wJW20KmoB20dfhcPNQ2eIFv63qrnI2zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JytxP/TdUf1Jn+DmTqZx5RcFMCn3ajLZNV75AhA3FAHeIqgQ+i9J+Odqzhs/uRMi/nb4r1U7j+R7soJKanmtYefPctQ1r3BnHNP+HDuBTg7flrfdxam7qw7g45E+myJg1Nxr3eSb5xnZYAThXhEnYrXOczSD+caC73MmatoAxrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz1CYxJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz1CYxJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC8CC4CEF1;
	Wed, 28 Jan 2026 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615954;
	bh=E7NPyEpMhe4wJW20KmoB20dfhcPNQ2eIFv63qrnI2zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qz1CYxJ5Eqd725QiGzUbmNjkm7V3p1moqwBYgJeq80KfUGaAuZCGyeuTI9dG9OCWV
	 1MQuBjbtE2aaNgxB/UYlJQSiM4z3wHNPTnWBnYqYCA5OQ4gKxy8xiiiw1LdmKRZLiW
	 QldZBBgnh7zPBeKQeQgYS8ALk+mbj02v14Wpyy6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 162/227] iio: adc: pac1934: Fix clamped value in pac1934_reg_snapshot
Date: Wed, 28 Jan 2026 16:23:27 +0100
Message-ID: <20260128145350.283345867@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit da934ef0fdff5ba21e82ec3ab3f95fe73137b0c9 upstream.

The local variable 'curr_energy' was never clamped to
PAC_193X_MIN_POWER_ACC or PAC_193X_MAX_POWER_ACC because the return
value of clamp() was not used. Fix this by assigning the clamped value
back to 'curr_energy'.

Cc: stable@vger.kernel.org
Fixes: 0fb528c8255b ("iio: adc: adding support for PAC193x")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1934.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/pac1934.c
+++ b/drivers/iio/adc/pac1934.c
@@ -665,9 +665,9 @@ static int pac1934_reg_snapshot(struct p
 			/* add the power_acc field */
 			curr_energy += inc;
 
-			clamp(curr_energy, PAC_193X_MIN_POWER_ACC, PAC_193X_MAX_POWER_ACC);
-
-			reg_data->energy_sec_acc[cnt] = curr_energy;
+			reg_data->energy_sec_acc[cnt] = clamp(curr_energy,
+							      PAC_193X_MIN_POWER_ACC,
+							      PAC_193X_MAX_POWER_ACC);
 		}
 
 		offset_reg_data_p += PAC1934_VPOWER_ACC_REG_LEN;


