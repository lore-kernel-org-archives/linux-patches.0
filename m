Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1741494D9;
	Fri,  6 Dec 2024 14:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496278; cv=none; b=cLtycNfYWneApF45A+4cNhczIOidMx/5sTtLbEFTpnABaEfhUPan+y2lOxxb0VaN/cjf0G67BFRHALxYsAKH1B6RCEGHuT4NAnWcYjZydRJqzw2oqom+lQM5fzTp+RB36VtDTWJQ8kH8Nn6mQRRS2+sZwvwoNUyue2c3359scUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496278; c=relaxed/simple;
	bh=EDbYnR9XvOducD+JWlulLrU0fT8u0clHfofXWsasth4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lN3Yjajbs2OJDp8vb02imI5OQerhhH7u/RjhxPC6stb/9qa0SBOdKb/ZL1SVmcrk0MXx9pgJ/HldxyLz6NDgjK1x6JUTW3C27g9DsqDi+qQYPwgzXNCNxKLYi9hCIIOZZ5PgXWw5uFT+aa/etjrqyypYZ27eBZzSEfu+tkCW9ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfmOkigT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfmOkigT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEAAC4CED1;
	Fri,  6 Dec 2024 14:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496278;
	bh=EDbYnR9XvOducD+JWlulLrU0fT8u0clHfofXWsasth4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfmOkigT0Xz1LrXhJbnzO3s1K8GvgQRXlhgmz8gJyE4NzsDSQITqLPQrK1etl/od2
	 xD4dxlaaVV09Uei3OHU1vx8SaCG7s64Pe9V30VcOSR3hb4i+WY411pFHSCPCfdneuR
	 D9jurZkvXTj+0SQHhvu/KavRIqHlBL+V9SVm5yIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 105/146] iio: gts: fix infinite loop for gain_to_scaletables()
Date: Fri,  6 Dec 2024 15:37:16 +0100
Message-ID: <20241206143531.699942831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

commit 7452f8a0814bb73f739ee0dab60f099f3361b151 upstream.

In iio_gts_build_avail_time_table(), it is checked that gts->num_itime is
non-zero, but gts->num_itime is not checked in gain_to_scaletables(). The
variable time_idx is initialized as gts->num_itime - 1. This implies that
time_idx might initially be set to -1 (0 - 1 = -1). Consequently, using
while (time_idx--) could lead to an infinite loop.

Cc: stable@vger.kernel.org # v6.6+
Fixes: 38416c28e168 ("iio: light: Add gain-time-scale helpers")
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20241031014626.2313077-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-gts-helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-gts-helper.c
+++ b/drivers/iio/industrialio-gts-helper.c
@@ -205,7 +205,7 @@ static int gain_to_scaletables(struct ii
 	memcpy(all_gains, gains[time_idx], gain_bytes);
 	new_idx = gts->num_hwgain;
 
-	while (time_idx--) {
+	while (time_idx-- > 0) {
 		for (j = 0; j < gts->num_hwgain; j++) {
 			int candidate = gains[time_idx][j];
 			int chk;


