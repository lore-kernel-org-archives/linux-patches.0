Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163B4442FA6;
	Thu, 30 Jul 2026 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422860; cv=none; b=RZVSuPU7HoAkPsaCBpj6I+TFbKzxTi8Y4lo3EMdxv61DvgTQW/wD4nEXUcL7f+Fws1Totxg/S1d9gLdCKMSBT2C5CmLv8paI/xxFdCyMZKJTcBlsbQ9+ts+YItjqdFVOEIgKD6HaO8mBwGqs7cJHaP+HzWpKrQE6AAkZIfkTbEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422860; c=relaxed/simple;
	bh=f/rV02Ra+FxOCNwOEXxWAooQZbJE+TBCra7GRG0BwYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2Hj4uh7fpyN3gl/eWhLh1f2F/n6g1DBSbFk+AILfclyvi9UnpiWI12wft5S0I+lAsHm5xUKgA4gO0fbuVTG7zR/81iVmmwvHNGcFE7I9o1vm8OPwCF9FIdq8Ub1zt89QpX48E/SGp6eca0Pv0m+XAVg7X1Dft1JHfe0PStW/zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP2o/lGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP2o/lGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6111F000E9;
	Thu, 30 Jul 2026 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422859;
	bh=2mdz/K1boqqXc89lzeyC1Q5ycx38Z4NHz5C/VNI+X6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VP2o/lGi7aSWbdaf4hjJAfJaqVEpJvMCebW+Iq6C9nGdeukj4iH7OzXfqTjHs4EaO
	 D+aph7EEr49hOwRItNs1xBScuVhzYDawxkr503V+QN7dKvyK3mdf9ftTRftu+xX9SN
	 3KEGP1w5y07JSlFeyefMB03NAjqaq+3lePaHxIH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 7.1 554/744] wifi: ath11k: fix refcount leak in ath11k_ahb_fw_resources_init()
Date: Thu, 30 Jul 2026 16:13:47 +0200
Message-ID: <20260730141456.055106067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 0e120ee0822b7cc650bd7b29682a34e137cec10d upstream.

of_get_child_by_name() returns a node pointer with refcount
incremented, but the error path when ath11k_ahb_setup_msa_resources()
fails does not release it.  Add the missing of_node_put() to avoid
leaking the reference.

Cc: stable@vger.kernel.org
Fixes: 095cb947490c ("wifi: ath11k: allow missing memory-regions")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260609092528.220547-1-vulab@iscas.ac.cn
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -996,6 +996,7 @@ static int ath11k_ahb_fw_resources_init(
 	ret = ath11k_ahb_setup_msa_resources(ab);
 	if (ret) {
 		ath11k_err(ab, "failed to setup msa resources\n");
+		of_node_put(node);
 		return ret;
 	}
 


