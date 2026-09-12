Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02021F1534;
	Sat, 12 Sep 2026 08:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201477; cv=none; b=hBkYchUgVF8oDKyJfyVNX2oe54LlEzlvoF9tL48AAGp4Yq+FsUyDQobeWsnatMUOG+U+KuB4Xy6MriDN5Eh4rTM+n9t4DnYxyR6T+Fkrkd0FsT3brAMGmvBAGJrsYHI4cqZx3YA69AiYUoEYuTKtw0hyhPrD5VZxVUnCfK0jRsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201477; c=relaxed/simple;
	bh=YclsVhnIe1hzgg6lu2nF6mrrqtFDIKDHygFUT8RP/r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RAbXr+yehNdgShQssuARHmSsmFe8zILyXb9GQPAuclhVRxRbq9fNKt89E83x3G7nrDrT2OYLQ85LXgXXYboXZyy6absQbKtHdDGWpWxM1sINaYYz0u8LJ0lC7DkjokDk2Gd/a68fqI6mTU+Caq58mAwVo7XnvwctYu39IIj5tb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnp04F3f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnp04F3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86BC1F000FF;
	Sat, 12 Sep 2026 08:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201476;
	bh=B7rlYX3H6jXh9GV+5+0VW4JXDjadBFaKq57zBdsw0eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnp04F3fDScTt5KZz3PSMDtxtBmb4hLRiWN4EioAaP2cVLJk5jpnS6UWv0sbmf10s
	 +ILrx6LVRCmCp6FLULausKmRKXjHyLlm3GDlOQaArDOyt0o0FNM9O65POvMgjhOfA1
	 4ywV0HC+Mgi/8yY+xrwpaT10xVTjmZFhpzdwVgqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Anvesh Jain P <anvesh.p@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1002/1815] platform: arm64: qcom-hamoa-ec: reject incomplete responses
Date: Sat, 12 Sep 2026 08:45:52 +0200
Message-ID: <20260912065712.530282388@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 1b04f556e8428a3865a95627ab7a0acb5d9b93a5 ]

qcom_ec_read() accepts short positive transfers, while both callers
unconditionally consume every field in their fixed-size response. A short
transfer can therefore make them use trailing stack bytes that were not
returned by the device.

The first response byte contains the number of payload bytes, excluding
the byte count itself. A complete response of resp_len bytes must
therefore report resp_len - 1 payload bytes. The existing check only
rejects counts that do not fit in the response buffer and still accepts
an incomplete payload.

Require both the SMBus transfer length and the EC-provided payload count
to match the expected response size.

Fixes: 5c44f48e91de ("platform: arm64: Add driver for EC found on Qualcomm reference devices")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Anvesh Jain P <anvesh.p@oss.qualcomm.com>
Link: https://patch.msgid.link/20260728111924.4106898-1-lilinmao@kylinos.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/arm64/qcom-hamoa-ec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/arm64/qcom-hamoa-ec.c b/drivers/platform/arm64/qcom-hamoa-ec.c
index 5ca7308c60774..4d2ad042a7f84 100644
--- a/drivers/platform/arm64/qcom-hamoa-ec.c
+++ b/drivers/platform/arm64/qcom-hamoa-ec.c
@@ -92,8 +92,10 @@ static int qcom_ec_read(struct qcom_ec *ec, u8 cmd, u8 resp_len, u8 *resp)
 		return ret;
 	else if (ret == 0 || ret == 0xff)
 		return -EOPNOTSUPP;
+	else if (ret != resp_len)
+		return -EIO;
 
-	if (resp[0] >= resp_len)
+	if (resp[0] != resp_len - 1)
 		return -EINVAL;
 
 	return 0;
-- 
2.53.0



