Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A81F274B43;
	Thu, 15 Jan 2026 16:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496193; cv=none; b=SRMxuNIcZAHiAhPuJKpLmmPV7WuG9lV44odjGcw4CANVK83lNFVUGFlEbvmxRRAoCozwJj+/0t70oz4ECn7YxRwVqE3DPSJH6YP8skbwNOz3egX4/X8ZawQHJvmy7Fp+3rIuYvo1hokkA1+abKQpbE9sigTgU78BQwSlQi+3LeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496193; c=relaxed/simple;
	bh=ej2dK1SYcn2OzZPfozRVsiROA49RgYuwFmZrp8rFeLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5VpweWTK+xGkmszmKfcE/qFfwcwFll1oDkRudLJIy6JHiYae5D9Y5Uz7a10yH4/rWkNLHVUHOgg6iVvGDYNZKtcrT0upyhmenc4G/zLO2yMz9QXX+5Hxk1jHv5w5R/Bh+z2qRENuwbodeCKr1dWD0QbXtK3kI/ASZihZOakb0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTD0vSQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTD0vSQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A4FC116D0;
	Thu, 15 Jan 2026 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496193;
	bh=ej2dK1SYcn2OzZPfozRVsiROA49RgYuwFmZrp8rFeLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTD0vSQGcE+Pyd9/65kfhF51EJYBx1ux3WjTCm40ejScvD/p6QjlV12qQ82BeEsMc
	 Xx3DXBSvHncsd5dxbdeqkyCIoGwYUGuypqlWZLz1tSafhaf+Ojux/cKqvyhMvGXDmN
	 Ti1aCdUGpeqKqPfZy1TRlMdMIgzyDTVPRGJ4V6OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshita Bhilwaria <harshita.bhilwaria@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Ravikumar PM <ravikumar.pm@intel.com>,
	Srikanth Thokala <srikanth.thokala@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/181] crypto: qat - fix duplicate restarting msg during AER error
Date: Thu, 15 Jan 2026 17:46:55 +0100
Message-ID: <20260115164205.145068841@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Harshita Bhilwaria <harshita.bhilwaria@intel.com>

[ Upstream commit 961ac9d97be72267255f1ed841aabf6694b17454 ]

The restarting message from PF to VF is sent twice during AER error
handling: once from adf_error_detected() and again from
adf_disable_sriov().
This causes userspace subservices to shutdown unexpectedly when they
receive a duplicate restarting message after already being restarted.

Avoid calling adf_pf2vf_notify_restarting() and
adf_pf2vf_wait_for_restarting_complete() from adf_error_detected() so
that the restarting msg is sent only once from PF to VF.

Fixes: 9567d3dc760931 ("crypto: qat - improve aer error reset handling")
Signed-off-by: Harshita Bhilwaria <harshita.bhilwaria@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Ravikumar PM <ravikumar.pm@intel.com>
Reviewed-by: Srikanth Thokala <srikanth.thokala@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 35679b21ff63b..a098689ab5b75 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -41,8 +41,6 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 	adf_error_notifier(accel_dev);
 	adf_pf2vf_notify_fatal_error(accel_dev);
 	adf_dev_restarting_notify(accel_dev);
-	adf_pf2vf_notify_restarting(accel_dev);
-	adf_pf2vf_wait_for_restarting_complete(accel_dev);
 	pci_clear_master(pdev);
 	adf_dev_down(accel_dev);
 
-- 
2.51.0



