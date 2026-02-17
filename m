Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FA7280CC1;
	Tue, 17 Feb 2026 20:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361611; cv=none; b=XnXx0AZ/wIliOgrzOqhikxCDgJo4DNs6JG3Zd9JqcpHzfdWeOMZlzfG+Kjft4ImOBpIoUjdSEvTk7BgZ4aNLpDnRlo5nBQmwh7aKXA0IZ0LwSPJ6RpMClOqyIeLJvd4lkNJOFBg+Be9FXNNAeoddPIAjDJABmNMgg1zJOx/phUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361611; c=relaxed/simple;
	bh=tse+bC3aOOtKQ11g6Cm87d+NUyvKrHMzDFViIcuzK0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0IrGpuBkhM5W8LO9WBAd0+ufmQUdg2l7cIqmnzRezw49KAs//mZfpbv13IH402eBngBEJAij0jUFBnz2ATCjIvK+TK1i1i4GvC6nYvMLvoyVtSU4dvVdz9PbRWGxNKnqPcddyhqsPEQYl4x5+Msjs0FHTqXuYGQz5GxDFk424U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKjMrOcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKjMrOcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14295C4CEF7;
	Tue, 17 Feb 2026 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361611;
	bh=tse+bC3aOOtKQ11g6Cm87d+NUyvKrHMzDFViIcuzK0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKjMrOcd9JPP6lGK46EJliWDQiFg8irn4STFaLS5VJm9DdWtRmubUjdgwZafw9DwP
	 RO+MkJfuSuQRrtAgTShbesC1II5cTVsJph29ocPIl3iyt3NmrmxJToCA8pG8lKhwvt
	 rVzDg+5/UxpeE0P9ejPbrbbn+jDiVAEpwauK77/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 03/42] bnxt_en: hide CONFIG_DETECT_HUNG_TASK specific code
Date: Tue, 17 Feb 2026 21:31:54 +0100
Message-ID: <20260217200006.134130797@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 8ff6175139967cd17b2a62bca4b2de2559942b7e upstream.

The CONFIG_DEFAULT_HUNG_TASK_TIMEOUT setting is only available when the
hung task detection is enabled, otherwise the code now produces a build
failure:

drivers/net/ethernet/broadcom/bnxt/bnxt.c:10188:21: error: use of undeclared identifier 'CONFIG_DEFAULT_HUNG_TASK_TIMEOUT'
 10188 |             max_tmo_secs > CONFIG_DEFAULT_HUNG_TASK_TIMEOUT) {

Enclose this warning logic in an #ifdef to ensure this builds.

Fixes: 0fcad44a86bd ("bnxt_en: Change FW message timeout warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250423162827.2189658-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9844,11 +9844,13 @@ static int bnxt_hwrm_ver_get(struct bnxt
 	if (!bp->hwrm_cmd_max_timeout)
 		bp->hwrm_cmd_max_timeout = HWRM_CMD_MAX_TIMEOUT;
 	max_tmo_secs = bp->hwrm_cmd_max_timeout / 1000;
+#ifdef CONFIG_DETECT_HUNG_TASK
 	if (bp->hwrm_cmd_max_timeout > HWRM_CMD_MAX_TIMEOUT ||
 	    max_tmo_secs > CONFIG_DEFAULT_HUNG_TASK_TIMEOUT) {
 		netdev_warn(bp->dev, "Device requests max timeout of %d seconds, may trigger hung task watchdog (kernel default %ds)\n",
 			    max_tmo_secs, CONFIG_DEFAULT_HUNG_TASK_TIMEOUT);
 	}
+#endif
 
 	if (resp->hwrm_intf_maj_8b >= 1) {
 		bp->hwrm_max_req_len = le16_to_cpu(resp->max_req_win_len);


