Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C931428E9;
	Thu, 13 Jun 2024 11:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279619; cv=none; b=GfdSwI/L0IqZDrPwq5SuNdMnfvh/HRvLSGyzH6E/Ya27sgvxl8mp/9m9bsuaA0P1SmdgZeBbNcy7PeJSy+XhDjI2ToZGB7who/xIdweVr7vFX+o+N2GGHcrlqIe1ZXwcA2loFyBSb7Cz+YowB1TUZsIcTJWQqWxYwKzmL02gOCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279619; c=relaxed/simple;
	bh=Qn3n46aIQSy+PnCOt102U2T9K4gjD8wO48WAl17eId4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FXJ+u2a9Fadie/sdsg7Q5VX9zLRgeW6d4GXPhPg+QYndXCPKwRKFW5Z563dXUGq6aKu1jgcT996b320unnDa2UiBY39nq8sTjodu6VOYI7OBsn9ivHAvW74mrGl1L0YCAojmTH+3EiQrzRfobnKSJkAi3OOKQs9Y7tKWOraNCLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhrJKoRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhrJKoRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF11C32786;
	Thu, 13 Jun 2024 11:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279619;
	bh=Qn3n46aIQSy+PnCOt102U2T9K4gjD8wO48WAl17eId4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhrJKoRO6oIur4KkAac1WDQstJ6996mk2p2muoZ0cU8olZUhlC/UT4BlhqTE/YAf7
	 NcLY/5hY0hjpQ21eXhUTJagOs+indnrayeX0qvKOfPWYa4aFImGwFTxP+6vfmojdoW
	 f21Px3RK8u0a73hWNOaDMFa6CVJXuep/5XPKwfOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 6.9 138/157] EDAC/igen6: Convert PCIBIOS_* return codes to errnos
Date: Thu, 13 Jun 2024 13:34:23 +0200
Message-ID: <20240613113232.742313950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -800,7 +800,7 @@ static int errcmd_enable_error_reporting
 
 	rc = pci_read_config_word(imc->pdev, ERRCMD_OFFSET, &errcmd);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	if (enable)
 		errcmd |= ERRCMD_CE | ERRSTS_UE;
@@ -809,7 +809,7 @@ static int errcmd_enable_error_reporting
 
 	rc = pci_write_config_word(imc->pdev, ERRCMD_OFFSET, errcmd);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	return 0;
 }


