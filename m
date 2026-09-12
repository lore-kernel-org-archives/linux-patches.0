Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6D4343893;
	Sat, 12 Sep 2026 12:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214800; cv=none; b=ClYMxXTROjtbWL+zhOgNXPCsHD9S765be5Flq0uP/OxR1EYzMR8a0wbF0SrWxqkiaoi/JXPbQ1FCyVnj4LYdPNnD+En7lyWZ0Kt9IaOFil91+jtJgMFGKRPJKK4kYYqgM5gtCEpXhQCFdJVEB1IhrOXJY/v+Fy3WRIL/bmKXvBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214800; c=relaxed/simple;
	bh=lJdAF+mGYaMoU/5xfVTTB4AQUOMEVvnA07DXpWcf6OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWpsFKPCsknVtMSlPch5HXHXzkDT+AQMy7rRXS+/Ru073tBeK+fVfe50IwzeOEQa4CdQyeA9QA0Y/pjZ8gUbu+hKuCBESniBpABk+tO3oWL+TwrqaHxAXGaRTyAvO3I7FOuo0jdpdfpvf/Cr7AuZksclF+5SOXuakmC8a2sblgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adfcip7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adfcip7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20171F000FF;
	Sat, 12 Sep 2026 12:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214799;
	bh=0zfGh1aVIladC2RX/E0PMdM+GHT4LF16nTP8MU5NzYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Adfcip7QQzVzBJx6CiIouyOH60KWYCmb2sY3ob667yqDrKGus0dt0JtbGoYKPymht
	 uzzGTADxgmgOUFYrQsZVrWgFX1slOBhJthMrZlY2hbrQJGwekll/N8zvbrPWXooqcx
	 cm19NVXKHeZ6HozcL8zUua0U/O0qaG3doQFGC6DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0400/1376] crypto: qat - cancel work on re-enable SR-IOV timeout
Date: Sat, 12 Sep 2026 08:47:06 +0200
Message-ID: <20260912065616.457905345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 455b0f3ac9e254edab9f5a873d337abe5e6e3604 ]

The QAT reset worker queues SR-IOV reenable work using a work_struct and
completion embedded in an on-stack adf_sriov_dev_data. If the completion
wait times out, the reset worker can return while device_sriov_wq still
holds or executes the stack-backed work item.

Cancel the work on the device_sriov_wq on timeout before the stack frame
unwinds.

Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index bd81458bcf327..403e53347f8e2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -140,6 +140,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	queue_work(device_sriov_wq, &sriov_data.sriov_work);
 	if (wait_for_completion_timeout(&sriov_data.compl, wait_jiffies))
 		adf_pf2vf_notify_restarted(accel_dev);
+	else
+		cancel_work_sync(&sriov_data.sriov_work);
 
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
-- 
2.53.0



