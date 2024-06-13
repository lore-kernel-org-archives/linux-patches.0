Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE71144D36;
	Thu, 13 Jun 2024 12:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280644; cv=none; b=YQlIYhXZH5NacWeGYmuMy6krHd1f+QezSb9IZdXSQplcYS9q0utKfEskljGBYOuQfJyEfg91OQrQsChrpxSRpq2PTVlEiaYNHr8emA2qzcGSgDcbY6th2qkwf8XbTEq8fR/cbR0+h7KWmOVJqmCew6YAG+FZ926DmwhqkGnaqeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280644; c=relaxed/simple;
	bh=owcb2T9D6YXa/1zzZezM2WJKWI04WT/N8u2mkQSLc/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nFdg7ZNARxLSt8n5Lcwm5su+jhmpqYAP5P6zJCpYHOiBAgqOUE205c7WBFxEjAMfXHEpnJ4MK+C4pHalIwaKQK1T2lRLrKDKcZ81RPnzl6sMtEf6EeIwm32crV2NlUKwI1q3tDqEmqXgM3fH3GhK2mLfAND70MWp0hxKFGrWO1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0+e2H9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0+e2H9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA55BC2BBFC;
	Thu, 13 Jun 2024 12:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280644;
	bh=owcb2T9D6YXa/1zzZezM2WJKWI04WT/N8u2mkQSLc/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0+e2H9eJKf8iKUPSad+HU5sLIZe7LM21k9ej+OY6YQtCC+2FEv6a8JCFaEgtYRU4
	 udRaUniYXMICZPlaMeBO4IowBepvG+8tlNaJsMwqNH4/5aM5HxkpbPhiwIw4fOd/f3
	 kjUE/RscH4okT15xHdR91mrzICT5fgA9PEr1lCP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 124/137] EDAC/amd64: Convert PCIBIOS_* return codes to errnos
Date: Thu, 13 Jun 2024 13:35:04 +0200
Message-ID: <20240613113228.110035601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 3ec8ebd8a5b782d56347ae884de880af26f93996 upstream.

gpu_get_node_map() uses pci_read_config_dword() that returns PCIBIOS_*
codes. The return code is then returned all the way into the module
init function amd64_edac_init() that returns it as is. The module init
functions, however, should return normal errnos.

Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
errno before returning it from gpu_get_node_map().

For consistency, convert also the other similar cases which return
PCIBIOS_* codes even if they do not have any bugs at the moment.

Fixes: 4251566ebc1c ("EDAC/amd64: Cache and use GPU node map")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240527132236.13875-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/amd64_edac.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -80,7 +80,7 @@ int __amd64_read_pci_cfg_dword(struct pc
 		amd64_warn("%s: error reading F%dx%03x.\n",
 			   func, PCI_FUNC(pdev->devfn), offset);
 
-	return err;
+	return pcibios_err_to_errno(err);
 }
 
 int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
@@ -93,7 +93,7 @@ int __amd64_write_pci_cfg_dword(struct p
 		amd64_warn("%s: error writing to F%dx%03x.\n",
 			   func, PCI_FUNC(pdev->devfn), offset);
 
-	return err;
+	return pcibios_err_to_errno(err);
 }
 
 /*
@@ -1016,8 +1016,10 @@ static int gpu_get_node_map(void)
 	}
 
 	ret = pci_read_config_dword(pdev, REG_LOCAL_NODE_TYPE_MAP, &tmp);
-	if (ret)
+	if (ret) {
+		ret = pcibios_err_to_errno(ret);
 		goto out;
+	}
 
 	gpu_node_map.node_count = FIELD_GET(LNTM_NODE_COUNT, tmp);
 	gpu_node_map.base_node_id = FIELD_GET(LNTM_BASE_NODE_ID, tmp);


