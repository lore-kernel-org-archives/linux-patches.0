Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EB633B96B;
	Sat, 12 Sep 2026 09:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205783; cv=none; b=hW2f04+/CDW6SLs/HS8s53AJzk3rRru7Ov1lY21sKF6nvu8YvUXnEbx17sM11LosS6x8YtcGCV8+y3WbMmf7f8s5KQfJgrlbwAxWxyJ8MO1GZdjaimO+KgpBpZW9UP+FHW1c4xltWae8pylowlPemNGrnJwuCIfuWgfvx5ridPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205783; c=relaxed/simple;
	bh=QIUADHEv0UpRijSJJB6Euxh/VDEzKGXNnTUXVv9W8aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1+0TWCwQMdbPbMe7+BhO72JOeDf+LjTP0jHNPYStAPkXIlhj0z1uyRJJpen8NbU5PVpSj6f/VxbQGxYFFk/t4e1BXlV5lu5Zrkiw36shYtS8TUefhoBdg+rxFdXbHNzaVLhkrtvFD6kc2KZZcPN2/asX7U+w5faDv/Z+SSFNYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwLoH8HY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwLoH8HY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668151F000FF;
	Sat, 12 Sep 2026 09:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205782;
	bh=H7cSqpapIS0PvkychubfMhPXp3TG1adeKeSCz9cvJmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwLoH8HYuVUmhGgRSKLrnXeElooEVXUu8gHO4hYTm3GdWCs1ADNDD3JLidDOh+XnD
	 gpOIpvSXIOkOiEtZxZGcFRYdd1EyGMQps2UQ96w8xkYR8i3MvYpaO1Oa3QdFfS13Lx
	 G1T1/Afa9hQ5zNcLanWzWBo5d+91hF0PsxSvbJpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0072/1518] platform/x86/amd/pmc: Fix msg_port restoration in amd_stb_debugfs_open_v2()
Date: Sat, 12 Sep 2026 08:37:21 +0200
Message-ID: <20260912065625.089040601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit cbb32ff92f8a62212e0f7384b1de986ced92082b ]

amd_stb_debugfs_open_v2() switches dev->msg_port to MSG_PORT_S2D to query
S2D telemetry but only restores it to MSG_PORT_PMC on one path.  The early
return on the dump_custom_stb path (and the error/allocation returns) leave
the port stuck on MSG_PORT_S2D, so subsequent SMU communication - including
the s2idle prepare/restore handlers - is directed at the wrong mailbox.

Consolidate the exit path through a single label so the message port is
always restored, mirroring the fix in amd_stb_s2d_init().

Reported-by: sashiko.dev
Link: https://sashiko.dev/#/patchset/20260717162023.956346-1-mario.limonciello%40amd.com
Fixes: 2851f4f8ed4e ("platform/x86/amd/pmc: Define enum for S2D/PMC msg_port and add helper function")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260721181756.143084-3-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ adjusted allocation context to retain kmalloc(struct_size(...), GFP_KERNEL) instead of kmalloc_flex() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/mp1_stb.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/platform/x86/amd/pmc/mp1_stb.c
+++ b/drivers/platform/x86/amd/pmc/mp1_stb.c
@@ -157,7 +157,7 @@ static int amd_stb_debugfs_open_v2(struc
 	struct amd_pmc_dev *dev = filp->f_inode->i_private;
 	u32 fsize, num_samples, val, stb_rdptr_offset = 0;
 	struct amd_stb_v2_data *stb_data_arr;
-	int ret;
+	int ret = 0;
 
 	/* Write dummy postcode while reading the STB buffer */
 	ret = amd_stb_write(dev, AMD_PMC_STB_DUMMY_PC);
@@ -176,22 +176,24 @@ static int amd_stb_debugfs_open_v2(struc
 	 * the enhanced dram size. Note that we land here only for the
 	 * platforms that support enhanced dram size reporting.
 	 */
-	if (dump_custom_stb)
-		return amd_stb_handle_efr(filp);
+	if (dump_custom_stb) {
+		ret = amd_stb_handle_efr(filp);
+		goto out;
+	}
 
 	/* Get the num_samples to calculate the last push location */
 	ret = amd_pmc_send_cmd(dev, S2D_NUM_SAMPLES, &num_samples, dev->stb_arg.s2d_msg_id, true);
-	/* Clear msg_port for other SMU operation */
-	dev->msg_port = MSG_PORT_PMC;
 	if (ret) {
 		dev_err(dev->dev, "error: S2D_NUM_SAMPLES not supported : %d\n", ret);
-		return ret;
+		goto out;
 	}
 
 	fsize = min(num_samples, S2D_TELEMETRY_BYTES_MAX);
 	stb_data_arr = kmalloc(struct_size(stb_data_arr, data, fsize), GFP_KERNEL);
-	if (!stb_data_arr)
-		return -ENOMEM;
+	if (!stb_data_arr) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	stb_data_arr->size = fsize;
 
@@ -214,7 +216,10 @@ static int amd_stb_debugfs_open_v2(struc
 
 	filp->private_data = stb_data_arr;
 
-	return 0;
+out:
+	/* Restore the default message port for subsequent SMU operations */
+	dev->msg_port = MSG_PORT_PMC;
+	return ret;
 }
 
 static ssize_t amd_stb_debugfs_read_v2(struct file *filp, char __user *buf, size_t size,


