Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7971F3BB9F4;
	Thu, 15 Jan 2026 17:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496552; cv=none; b=Nbf4gB4mfM1R/MAQ237f/8XJOL8JIkRmv9TDVVonKflvE8Fy3y/zjRfmYUCRSX/AIloUysqlPKhWPxcGZhrwmlNmdiltYGx9BjOVDXT2f5TxxqE6/ArvlTFOsqwhzYRxX754cdXjJ/bqtvcu/M/zY4qGut5osv/LrysrlEjOoEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496552; c=relaxed/simple;
	bh=gVueE7pMa4gNlDUTQZ7bBg6MkQQaHIhjuNClJ9jGIlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE9kw0jY4SQriDykbsfHxd54kc6pbrDpkUUTu9a6ZY9+2iy5yU/XlvvTb7ro+SLbHeNpHUVDj82DuJjtXLzTlZygFEK9p7SzAoeNiTowaaf8ZK8zP3t6O5KUJSZnPuoqOigJN2b9+LwYvymf6k4oOKDbEX72gtrablo3gXnqEjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THUo7Cdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THUo7Cdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06657C116D0;
	Thu, 15 Jan 2026 17:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496552;
	bh=gVueE7pMa4gNlDUTQZ7bBg6MkQQaHIhjuNClJ9jGIlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THUo7CdkOYI3NUocAsdGmXMfcw4k/+UoEGt026226Gn3/hoxidq5qqd/GS6HK8TQY
	 1hePqBfdbMv06n2YcOv6HHhpQAIUoMexzDCv94UoDQCQWQer34HjTvQrg0pz+GiDN5
	 rGXcjO8aAZ1gqCjkFZ/OzFcjcrxbUtW07sSzeLlw=
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
Subject: [PATCH 6.12 052/119] crypto: qat - fix duplicate restarting msg during AER error
Date: Thu, 15 Jan 2026 17:47:47 +0100
Message-ID: <20260115164153.837226897@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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
index 4cb8bd83f5707..bd19d3a14422a 100644
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



