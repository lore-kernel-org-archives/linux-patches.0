Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F924F3931;
	Thu, 17 Sep 2026 15:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660196; cv=none; b=YFrQFTCrzFGbn/OJvnoSRvCknukx1iBGa6rH13fBu2/LYFDyMPEwWO7h9IkQH1lX1nmUX4AB04qiFHaSG52L5XdVxjo8Jp8wuATpIICz7GW9/M1Rky2QLoSSHTbF08LI02ngTCYfsl6plSNOxU2cKV2wOV6cRJJoSdJ7lzVJPRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660196; c=relaxed/simple;
	bh=+bWGR56JXb5fHATVDlACzEWGHDUVhMy/JokZzUE0WDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF2mZj4M1unjJrLeTx6MCr3cjbQDLDVinBHnQqilMvrmZTo1w3enTcS1jFAWj7WRl9Ep6Qxxg65ii2le+OGg3Zs08K3241uLffXitZckWyMraQThuUTWdTozrmBt2T9wKuy5ku7Bc+PjxLLBLgfQmQsrPJd71eClWCH9Jv0lE4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIJUJyKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIJUJyKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7511F00898;
	Thu, 17 Sep 2026 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660188;
	bh=qIbU6AjefLTiM7wKwIm+eV1dcdQM/z49eIjMNnQ8Fx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIJUJyKjVOiLCt0sJNA2KZkpQInThtESKNY0/5iyM+BSqePKBTenb2El/tig7RQLA
	 RtZeFzgEDmFy4ioDQGIXauIMSSyu6d5AW4uqrFJEjg8MWczzfC0U6j1ZLrEkoOtNqv
	 xBy3QoJZh0GmvlV6D9hU35SOP2glR3Miop0Y7Los=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 509/733] accel: ethosu: Ensure cmd stream ends with a stop op
Date: Thu, 17 Sep 2026 16:13:37 +0100
Message-ID: <20260917151404.805539120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

commit eb3a41fd35e352fba387c4320a1fa0352f3e551c upstream.

While the QSIZE register setting should prevent an out of bounds access
of the command stream, it is not clear whether the h/w generates an
interrupt in this case as is required (to prevent a timeout). As a stop op
is expected end of the command stream, let's just ensure it is present. A
stop op in the middle of the command stream also makes no sense.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260827-ethosu-fixes-v1-3-346f9ea8791c@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_device.h |    1 +
 drivers/accel/ethosu/ethosu_gem.c    |    9 +++++++++
 2 files changed, 10 insertions(+)

--- a/drivers/accel/ethosu/ethosu_device.h
+++ b/drivers/accel/ethosu/ethosu_device.h
@@ -68,6 +68,7 @@ struct gen_pool;
 #define PROT_ACTIVE_CSL		BIT(1)
 
 enum ethosu_cmds {
+	NPU_OP_STOP = 0x0,
 	NPU_OP_CONV = 0x2,
 	NPU_OP_DEPTHWISE = 0x3,
 	NPU_OP_POOL = 0x5,
--- a/drivers/accel/ethosu/ethosu_gem.c
+++ b/drivers/accel/ethosu/ethosu_gem.c
@@ -390,6 +390,7 @@ static int ethosu_gem_cmdstream_copy_and
 	struct ethosu_validated_cmdstream_info __free(kfree) *info = kzalloc_obj(*info);
 	struct ethosu_device *edev = to_ethosu_device(ddev);
 	u32 *bocmds = bo->base.vaddr;
+	bool ends_with_stop = false;
 	struct cmd_state st;
 	int i, ret;
 
@@ -426,6 +427,11 @@ static int ethosu_gem_cmdstream_copy_and
 		}
 
 		switch (cmd) {
+		case NPU_OP_STOP:
+			if (i != size / 4 - 1)
+				return -EINVAL;
+			ends_with_stop = true;
+			break;
 		case NPU_OP_DMA_START:
 			srclen = dma_length(info, &st.dma, &st.dma.src);
 			dstlen = dma_length(info, &st.dma, &st.dma.dst);
@@ -688,6 +694,9 @@ static int ethosu_gem_cmdstream_copy_and
 		}
 	}
 
+	if (!ends_with_stop)
+		return -EINVAL;
+
 	for (i = 0; i < NPU_BASEP_REGION_MAX; i++) {
 		if (!info->region_size[i])
 			continue;


