Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D22282F1B;
	Sat, 12 Sep 2026 07:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199048; cv=none; b=TROAkQI5JIlybnkumZCtZt3IKioIXDkZ33XyCNqMRNPWqutNtbyKVETOC1QWAkVvdbSIVUwHGfyVtYhsW0j8w7LD9qGtUMFbbc55262mljxSON6wXkkpsOrfhWvzP2finOeur2xTHOvWwmMRgWpUiLRuxRIyjnqzumaNOqw4pKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199048; c=relaxed/simple;
	bh=VCg8yO9ZavOm11/TUjohkK3CG58+ZgISUsjf2lq56b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWGDMtpyOsBv30AWWRzOWJs+Wfkiw9wvEJRqi308afs0QoZ/sfjVfiPf6pI5xpjwckloYaGdo7U+HHavD5Dx+PaKeP2k+Km+NcImQxMMF7Ugvjh6LLQWNf1EGiXSNBZi9dtzTbRJWey9zRHFbKztykOEbQQvve3uP/KUz5bLGdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjWYCxkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjWYCxkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E620F1F000FF;
	Sat, 12 Sep 2026 07:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199047;
	bh=/GCJLGlh70/hfmvqTzkmhhf05bP2eBNxYayt6lPbvPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjWYCxkjeUc5KXuCcUGHg2g+hUICAljkzA2n7lznuWNrxs9N+k/nmoIQ6g10eUzEL
	 w85OodZcF8rxDRFbiJZCI7VL/2Q7LY0kHCGalo8xvXfqy3by4iJsq6wjvgT+3swDex
	 mEJqljIpBovUjl16kG+SUyZIpUx3B4MKpVE+ekmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0462/1815] spi: geni-qcom: Fix sticky ret causing wrong return value on invalid proto
Date: Sat, 12 Sep 2026 08:36:52 +0200
Message-ID: <20260912065659.735778750@linuxfoundation.org>
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

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit 2c1c13da3a3a639d2ac7221e1a5e57945cbc7235 ]

spi_geni_init() reuses 'ret' after it has already been set by the
runtime PM acquire check earlier in the function. When an invalid
protocol is later detected, the function returns this stale 'ret'
value instead of a proper error code, so it can end up returning 0
(or some other non-error value) even though the protocol check
failed.

Fix this by returning -EINVAL directly on both invalid-proto paths.

Fixes: d8e9ea989acb ("spi: qcom-geni: Fix missing error check on pm_runtime_get_sync()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202607122241.qzP3QAXF-lkp@intel.com/
Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260716-fix_return_error_code-v1-1-3295003aacd5@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index a55a3afc0ebd1..1fd9cf6e30f7a 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -625,7 +625,7 @@ static int spi_geni_init(struct spi_geni_master *mas)
 	if (spi->target) {
 		if (proto != GENI_SE_SPI_SLAVE) {
 			dev_err(mas->dev, "Invalid proto %d\n", proto);
-			return ret;
+			return -EINVAL;
 		}
 		spi_slv_setup(mas);
 	} else if (proto == GENI_SE_INVALID_PROTO) {
@@ -636,7 +636,7 @@ static int spi_geni_init(struct spi_geni_master *mas)
 		}
 	} else if (proto != GENI_SE_SPI) {
 		dev_err(mas->dev, "Invalid proto %d\n", proto);
-		return ret;
+		return -EINVAL;
 	}
 	mas->tx_fifo_depth = geni_se_get_tx_fifo_depth(se);
 
-- 
2.53.0



