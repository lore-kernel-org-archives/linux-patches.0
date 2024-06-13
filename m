Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D31414264C;
	Thu, 13 Jun 2024 12:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282796; cv=none; b=T0q24vTcRo6iSTGYRcMhjER0RlQVMPv/e1Z77PRSZ5EHs3ECdPPN9SlYOmgb4Rqpga4J8bYm1iS+GiIlKIiLpzktfGC55kcgjEPgsGEW+KYMNy9P4D4wI6ZjC75tCqEeM733Es7KDxE3sHNprcyvYb4Et2UZuANkMAvxz5FvShQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282796; c=relaxed/simple;
	bh=kMQXDTqKBTbkAbvxWrjlpU6npOeojG+qgV7SNa3MXzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/ORWo58UEDIIBHPnurMHU9SLIVDHuHyRtP1VjRZm2+cMn1TlimQTbXrNgdySx4GCcXmco1rN6ycgQlSdyjXqlIeX9qIXc4AI/MwaVC3kf5Fy0CIzAWXvtNTw7mtPN0UWOZKxxmdPOFiL52tV7YwqF9OS/2HlXa0gWv4laYSoh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGwfPrFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGwfPrFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9765CC32786;
	Thu, 13 Jun 2024 12:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282796;
	bh=kMQXDTqKBTbkAbvxWrjlpU6npOeojG+qgV7SNa3MXzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGwfPrFB360G9g0Amlhi7E2W0QvhXcKv6I17dv5v1jY11iBwg/4h9PDu8fI5dmBJb
	 9rUD+/7m8t7ldnrKx4eGd3OLG2AoUcQL/B6w35RfGnnZOpQY0hOByghxZtg2raK9tW
	 e2VOv8Gfk0HY8yysPpf4xfM3yzuAXs8FMx8oTQvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 5.15 399/402] EDAC/igen6: Convert PCIBIOS_* return codes to errnos
Date: Thu, 13 Jun 2024 13:35:56 +0200
Message-ID: <20240613113317.716744869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit f8367a74aebf88dc8b58a0db6a6c90b4cb8fc9d3 upstream.

errcmd_enable_error_reporting() uses pci_{read,write}_config_word()
that return PCIBIOS_* codes. The return code is then returned all the
way into the probe function igen6_probe() that returns it as is. The
probe functions, however, should return normal errnos.

Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
errno before returning it from errcmd_enable_error_reporting().

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240527132236.13875-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/igen6_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -627,7 +627,7 @@ static int errcmd_enable_error_reporting
 
 	rc = pci_read_config_word(imc->pdev, ERRCMD_OFFSET, &errcmd);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	if (enable)
 		errcmd |= ERRCMD_CE | ERRSTS_UE;
@@ -636,7 +636,7 @@ static int errcmd_enable_error_reporting
 
 	rc = pci_write_config_word(imc->pdev, ERRCMD_OFFSET, errcmd);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	return 0;
 }


