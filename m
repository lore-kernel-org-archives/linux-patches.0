Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8181972617;
	Tue, 11 Nov 2025 01:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825516; cv=none; b=mH7sNhR8m8XE6ukVU+c0+XfEl2frXWMpfwFk41fUANdXKWsqOzarENd4oxwMGNE/WbC0bV9pszYDqVWbkns471JG99klIs8Z2zalNGlJ2q6COWimtZQo6Y4zv6NZKVBWHx+hLRYrRr1v8aw6tipUAUxvAH+VYYipSW4wKv0Gdeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825516; c=relaxed/simple;
	bh=JL6d6Ku0EA8swH+DRmD1r4PEf0y4ssy4fAVFBi/bmn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqBvWlYncn7LPf868LAqNktkeNIz6DZm2gyYccwXfA8xE7Gy+O42WQrxSXjYM8tzgaxejavUVLuCeD24PK31vB7xCM7B89LJHnh4fEQVPS4etre70h3ZJ5vyK2CUsOb2l8pdtJkQc/abVbLEwy1QnoX9qlHwF1m0g6jIz4O13W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJ71Zt8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJ71Zt8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBB0C19421;
	Tue, 11 Nov 2025 01:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825515;
	bh=JL6d6Ku0EA8swH+DRmD1r4PEf0y4ssy4fAVFBi/bmn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJ71Zt8+P3WcYkdotATbYTi0LuA7JUCJsGEhLd6CCfFg6D6Xg2xgPfGnm5ijEd9Q1
	 kbt5S6gsJAQ1wx2/7eNH6AKUWPjtMoPt6kg9NEp32mGVHGgs0WtYQazbUVpQmzgXOh
	 r2naYIOSecMsek6YOgxCJHA8ApNv3SJE1enhE6w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.17 834/849] scsi: ufs: core: Fix invalid probe error return value
Date: Tue, 11 Nov 2025 09:46:44 +0900
Message-ID: <20251111004556.586182423@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit a2b32bc1d9e359a9f90d0de6af16699facb10935 upstream.

After DME Link Startup, the error return value is set to the MIPI UniPro
GenericErrorCode which can be 0 (SUCCESS) or 1 (FAILURE).  Upon failure
during driver probe, the error code 1 is propagated back to the driver
probe function which must return a negative value to indicate an error,
but 1 is not negative, so the probe is considered to be successful even
though it failed.  Subsequently, removing the driver results in an oops
because it is not in a valid state.

This happens because none of the callers of ufshcd_init() expect a
non-negative error code.

Fix the return value and documentation to match actual usage.

Fixes: 69f5eb78d4b0 ("scsi: ufs: core: Move the ufshcd_device_init(hba, true) call")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251024085918.31825-5-adrian.hunter@intel.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10638,7 +10638,7 @@ remove_scsi_host:
  * @mmio_base: base register address
  * @irq: Interrupt line of device
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success; < 0 on failure.
  */
 int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 {
@@ -10879,7 +10879,7 @@ out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
 out_error:
-	return err;
+	return err > 0 ? -EIO : err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_init);
 


