Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938F225771;
	Wed,  2 Oct 2024 13:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875176; cv=none; b=ONNS8nPHAQnGqNA1HaYQqizi8IeZd+DzfEHzLbf7KjLAvOdktJ6EJoiH5JRAw0uWtmfDx6WOZDxB4GfAZMXzRsavdblH/tNZn7HbKmzwcBb3z7KzFbu/CqoRzXJoeP7PV+iKEdh0sBYvzGCdPqtpeMzPwnxiJRL2tieJbnglzD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875176; c=relaxed/simple;
	bh=dzBRJG79zjSq7KKaz+tj2bG828IZSXlBzQC6imL9A8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYNhrzEpvin58injZROP/1HCe++FkjB5SI+ZcwTlb35W1tDKeO94ySzqNKOoL0yy6PsRuYcwD+S5BoqdqVnd4lUhpyEeo6gAhZxErAk/WViU0OQKYzNZ4TKP5yDKBY8H41pIxaXl2IqLLqTEMzVZBbcR5V9hgdRm7kURKHpKsq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIXl2lIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIXl2lIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2805C4CECF;
	Wed,  2 Oct 2024 13:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875176;
	bh=dzBRJG79zjSq7KKaz+tj2bG828IZSXlBzQC6imL9A8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIXl2lIfapFt/EDmdfO+25vGiPUi1tWGvTKs9S8vs9YVyJ2tmYl4bcYrf4menLavi
	 ecaZsJs87g3/Ve20ERoA3MsBY3RujojB5gQHa2bflFpwOO0pp2P6WHX6ZuZ2QYzRH8
	 Rzbp0eZaILlT8TLmhEzeiTHLtX+T/JB/t/y2Cpmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Witwicki <michal.witwicki@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 005/695] crypto: qat - disable IOV in adf_dev_stop()
Date: Wed,  2 Oct 2024 14:50:03 +0200
Message-ID: <20241002125822.698023867@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Witwicki <michal.witwicki@intel.com>

[ Upstream commit b6c7d36292d50627dbe6a57fa344f87c776971e6 ]

Disabling IOV has the side effect of re-enabling the AEs that might
attempt to do DMAs into the heartbeat buffers.
Move the disable_iov() function in adf_dev_stop() before the AEs are
stopped.

Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 74f0818c07034..55f1ff1e0b322 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -323,6 +323,8 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	if (hw_data->stop_timer)
 		hw_data->stop_timer(accel_dev);
 
+	hw_data->disable_iov(accel_dev);
+
 	if (wait)
 		msleep(100);
 
@@ -386,8 +388,6 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 
 	adf_tl_shutdown(accel_dev);
 
-	hw_data->disable_iov(accel_dev);
-
 	if (test_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status)) {
 		hw_data->free_irq(accel_dev);
 		clear_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
-- 
2.43.0



