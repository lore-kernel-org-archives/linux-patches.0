Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEDE2E405;
	Mon,  8 Apr 2024 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581314; cv=none; b=cahpB+Mn0DF68fk+ZvgHHZbC+CXClVQV8Btmd5j3z6t7ovb/kjVFitzSWlNM+t2tSJD61Ujp2GaAvnlSi1W2fXQwY69+s7dgcr2Dpwodhlt2+ZhKdfoyQzwRfF36QSDVsTJ1m6KMaDWmnbF6kbawUTxTa5PuJb/FqloA11MZRF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581314; c=relaxed/simple;
	bh=WGpgnkW4+JbYbrBxpqFV436td9DEqIqgw3aqle7HQVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoUtAcozMrY8hFFGtkWXkYXDtNP4wuUo9r2eHaj8toD66eB0/KSMVGCeBWxjwZBkqSC0xh3XJv0QT500qPL6GDovQLQ7APQHRhITl5DJjEX6epwOh26qKW8ahr1Y408rxsADzdIVHLy46Hq+bvfvtviLr0l+5U6lDGuygRKB9fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1YLh8iA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1YLh8iA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BB0C433F1;
	Mon,  8 Apr 2024 13:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581314;
	bh=WGpgnkW4+JbYbrBxpqFV436td9DEqIqgw3aqle7HQVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1YLh8iAuaBov9JvBiTyWZ53i5VZDqyQHFdA+6kc1PyuYHZ0om433WPL5UJD8oiQ0
	 b/q05Un0FDwToe70g+IJ4drPzIdiDmM3TVvfzPsmv4jdc53PGtbPomfqRaq0VXvip1
	 fzBLKwcZDa+hG1mzZZ4M2iJA+9gQ9oGnfi3MJFP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/690] crypto: qat - fix double free during reset
Date: Mon,  8 Apr 2024 14:48:08 +0200
Message-ID: <20240408125400.366335679@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

[ Upstream commit 01aed663e6c421aeafc9c330bda630976b50a764 ]

There is no need to free the reset_data structure if the recovery is
unsuccessful and the reset is synchronous. The function
adf_dev_aer_schedule_reset() handles the cleanup properly. Only
asynchronous resets require such structure to be freed inside the reset
worker.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 7d42e097607c ("crypto: qat - resolve race condition during AER recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index ed3e40bc56eb2..b3138f8fc3f30 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -95,7 +95,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		kfree(reset_data);
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
+			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
 	}
-- 
2.43.0



