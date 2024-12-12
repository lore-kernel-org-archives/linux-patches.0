Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF467225411;
	Thu, 12 Dec 2024 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025629; cv=none; b=NNP52kvUQmhjIH3gzFoxZtaEZUWnIOL+AYzGubha6Q+nTvWHiagfjkQQwhBPeYDne1anXSC2+pcXJiHS9jwaChSWQ2zNmBD7ugQupZCYj0S3QSIVZq+rBxUDVWrkSIZKFlS/n+1Eo37Cnh4Eqg0kjYLXTgGUjTnc42mB4E9lYvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025629; c=relaxed/simple;
	bh=Lk37zG/Ap6w0KYXQJGfNoru8ndoN9ugnVNDul8FBHkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9YNUTvdekK+2DfF9RhXJa2zWfOWTnjcx806zmFn2BPJhUERnvwiVAcHAWTe0UgKH7Wj0dQVYxGVRx+qEXrT2e1yBLLLyM85BcmyKqKvbHbcII7dn9WySjXppzV7O/Xlp5WijplziO6o7Y7DmSWArPH+3PDE9PY+t+SZzv5/M+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOEon8td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOEon8td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6950DC4CECE;
	Thu, 12 Dec 2024 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025628;
	bh=Lk37zG/Ap6w0KYXQJGfNoru8ndoN9ugnVNDul8FBHkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOEon8tdBDokO5XTGn4w7CZTzixK1V/TfCMnmZaK0uji/Vm4F9P2pOiKYUbM/zvcH
	 fbaFJ8H/V/JFuOOTR/QJtHggXkiP76M0QVSTWjofHaK6CYiXMapHNemWrBb7Xa3LZW
	 PVJSzAVdPpYVfgM1LQuR253bmOzOc/gEHKFdD5k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Forestier <florian@forestier.re>,
	Louis Leseur <louis.leseur@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 233/321] net/qed: allow old cards not supporting "num_images" to work
Date: Thu, 12 Dec 2024 16:02:31 +0100
Message-ID: <20241212144239.177674319@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Leseur <louis.leseur@gmail.com>

[ Upstream commit 7a0ea70da56ee8c2716d0b79e9959d3c47efab62 ]

Commit 43645ce03e00 ("qed: Populate nvm image attribute shadow.")
added support for populating flash image attributes, notably
"num_images". However, some cards were not able to return this
information. In such cases, the driver would return EINVAL, causing the
driver to exit.

Add check to return EOPNOTSUPP instead of EINVAL when the card is not
able to return these information. The caller function already handles
EOPNOTSUPP without error.

Fixes: 43645ce03e00 ("qed: Populate nvm image attribute shadow.")
Co-developed-by: Florian Forestier <florian@forestier.re>
Signed-off-by: Florian Forestier <florian@forestier.re>
Signed-off-by: Louis Leseur <louis.leseur@gmail.com>
Link: https://patch.msgid.link/20241128083633.26431-1-louis.leseur@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 3769b15b04b3b..168dbf11efed8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3059,7 +3059,9 @@ int qed_mcp_bist_nvm_get_num_images(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
-	if (((rsp & FW_MSG_CODE_MASK) != FW_MSG_CODE_OK))
+	if (((rsp & FW_MSG_CODE_MASK) == FW_MSG_CODE_UNSUPPORTED))
+		rc = -EOPNOTSUPP;
+	else if (((rsp & FW_MSG_CODE_MASK) != FW_MSG_CODE_OK))
 		rc = -EINVAL;
 
 	return rc;
-- 
2.43.0



