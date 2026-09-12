Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF982BDC0E;
	Sat, 12 Sep 2026 07:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197707; cv=none; b=RqO0XQ+SVN6dukREN14wkz1utWq+UbIcAwxMOxnE269lceT6mluvMnXCoLa2K2wL2aHGW25bbdtmpc8xvLAjMRhnjgYcAQaINFoDzdBzZbaQjA5jFFTqBDomskurMSS3GXAP/L4NbuUWrbfNkjY/n7s6R99To2cR3QgbjwoW5rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197707; c=relaxed/simple;
	bh=qpA5smUvtJ3fTvq85tKZjUZfSA4r80BeK2NLeCGfdOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqclrMELWAMkS8b8zrNFmdqpy8I36UUPmVSeOqc80nXEnMl0jGhmMk1eNXCP2g09pmhfj+AQIXLnIJbzSUPEHMTCgI0I9HN+7RnTFsXdbqbkIhigO5qy7gYBjYZnpMHc5pASyzBTQAlAeLVA5C3cEg8Q5sJfKH232G3kwhEXfyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIpTlGqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIpTlGqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECAC1F000FF;
	Sat, 12 Sep 2026 07:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197705;
	bh=aUgeCfNaLMvaW8ocZkKG5sYMc/BfH1W5ZYc0T/PqrEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIpTlGqzxpSQBFrbDNpp+TA8oSG4WIqZP1eKsTJpUF8kdvoAh2JyyWm3L/jsqSuMD
	 p8ppF0RFuiuWezbjwkVdPcfeCmmr4lcoIktINp+Mgpx1JDgOj8/QGzEKpyNKPnn7I6
	 jVdTbUx+zV6S2VfrQu2hpTzxSXaRJK32bs9JaT8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0188/1815] crypto: qat - cancel work on re-enable SR-IOV timeout
Date: Sat, 12 Sep 2026 08:32:18 +0200
Message-ID: <20260912065653.419668573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d58cd7fbf7077..afded3030e9a3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -189,6 +189,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	queue_work(device_sriov_wq, &sriov_data.sriov_work);
 	if (wait_for_completion_timeout(&sriov_data.compl, wait_jiffies))
 		adf_pf2vf_notify_restarted(accel_dev);
+	else
+		cancel_work_sync(&sriov_data.sriov_work);
 
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
-- 
2.53.0



