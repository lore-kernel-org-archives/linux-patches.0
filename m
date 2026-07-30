Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7659217723;
	Thu, 30 Jul 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424758; cv=none; b=ZZhxdFLaSePOq+ezMW2nJvwXblvbqrYdyDxm9ou/Pc4UnCB5/7Dy7QJkVgfmoRKrN7IXqsPntJdAX/9i54vb7VvXGUu0vMafI8m6u9A8lR4dOB12mlyvAmyNshRzgXtJptLOHWz7ngwQ8GCs3cFkV0MlxyfXgYlZqVm4aHXMTDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424758; c=relaxed/simple;
	bh=j07nf5nACiuyGBx3cRmsRNBOgTTJ0gJUVbHlvbglVVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXUJySHnO8PrZMEaw+K2zWV24PZAD7aECF/VHPc/AcAMyu8gjKh8MQNFXuzJIQJovmeu6HEci2lUvx6SFpItOGAIm3n8is/xQyn2ywMGMzOR7Q9ahdUNmgqEyU1qR3hUMCfWFROdYGyF98TO0wUkG6Rt5PeTk+LHF5qXepylKyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jh0crQrs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jh0crQrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDEA1F000E9;
	Thu, 30 Jul 2026 15:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424757;
	bh=Fu1BrIKGrtibKgU6hVOPfXppZpQ2OiQoK4fESvVf1EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jh0crQrse2iSDfmz+pQjHbJa75bSLxA2V6b6hVmdqNnoGhatRFOxvSR1zAzptcLzd
	 DQ2yCbai40OHLKsQmQ2TUwuXlsrFiTFau7b9t6H3dksPflymjOHDq51gnw/oAjOVhq
	 +MVOxy69xNnQiZyHk+JdNM7lYljJjT3aQMvHOWqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 461/675] wifi: ath11k: fix refcount leak in ath11k_ahb_fw_resources_init()
Date: Thu, 30 Jul 2026 16:13:11 +0200
Message-ID: <20260730141454.928981018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -998,6 +998,7 @@ static int ath11k_ahb_fw_resources_init(
 	ret = ath11k_ahb_setup_msa_resources(ab);
 	if (ret) {
 		ath11k_err(ab, "failed to setup msa resources\n");
+		of_node_put(node);
 		return ret;
 	}
 


