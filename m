Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F90B2CCB9;
	Thu, 30 Jul 2026 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427230; cv=none; b=BcPTlROUu8YseBWFrEObbPXUiw9nUrL0Il5WMAbbodDjxxnu8fig3Jr+tr0cX7uevCzMNrx0qZj44JlvcIKHIo4Vcs5iDI9/lpxhhoaO8ov53bk2d7tBhhnVmGAhXKoQHM47pYsTCd6Z5gF5TiNkamXCYjht7rLue5jue1bJclw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427230; c=relaxed/simple;
	bh=Fkm8VmTcL0nIeQ2IJ5GensVa6D0GYFF1/ZYhjT2PmZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rChYxnEkPXLSTWJMXbQhcYZVbqB0E9CtdcKAlhN+s0gClyWk3/YBC05Q96LI4SY3jyczCeQMDzTbo8hCZckbtIHX67OrKhN/r9xAgnU49LZla1zXnCYsJYdfxtMmKL9Z5wcfVDIxRl3m9Bv2EBQXKeGmzCJUyqHWgpqhkoJtPgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQVeusks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQVeusks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55C91F000E9;
	Thu, 30 Jul 2026 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427229;
	bh=CXGOtUeYssiEZaJBsq/Q/PnsFpUnfEpbHG/kPKGU+EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQVeusksot7vy/uj2K3mG7c6c1JqaUXxETH/pdskwPxFU6g6NCU9u1v3W030GEEQf
	 PLMfzjm6/qQx+2wzyi9BNg3SnfjFfX0rp8JIqimLpWUy9DdmzSrLZsg26nDKYrX/cH
	 o8a6hr71kw7Zx09EJbJ2qcPxeQa7zh95/cfNouXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.6 098/484] usb: chipidea: fix usage_count leak when autosuspend_delay is negative
Date: Thu, 30 Jul 2026 16:09:55 +0200
Message-ID: <20260730141425.582130602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit fc3afb5728e297994863f8a2a01b88a920bbf53e upstream.

The probe() calls pm_runtime_use_autosuspend(), but remove() does not call
pm_runtime_dont_use_autosuspend(). This can lead to a usage_count leak if
autosuspend_delay is set to a negative value.

The pm_runtime_use_autosuspend() also notes that it's important to undo
this with pm_runtime_dont_use_autosuspend() at driver exit time.

Fixes: 1f874edcb731 ("usb: chipidea: add runtime power management support")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260716104126.2763454-1-xu.yang_2@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1265,6 +1265,7 @@ static void ci_hdrc_remove(struct platfo
 		usb_role_switch_unregister(ci->role_switch);
 
 	if (ci->supports_runtime_pm) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		pm_runtime_get_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_put_noidle(&pdev->dev);


