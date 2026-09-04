Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C036C3B95FA;
	Fri,  4 Sep 2026 05:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499889; cv=none; b=M7Z0ygmM2e3t0GFz2lDe9cdxNBsjorzAgoFt4Y9Jfh1I5UdZBHNFqNIJaFQXMEQD3tqBNC8ZOat76xIaN0uzFiIjLtnU9q+TlqUZ1yxsBrN3GJCky86cFehNqAc1Znh/Tt9Cx+EkMQ6TrxLy2ZIe+I6KXPhBIjkBdSiwAheBkwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499889; c=relaxed/simple;
	bh=Lef3wIG1FT32/XFWxUVug5aPIDcLmB2NkqQpnG/StiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0LAor6RKqwpx1HUmHSL7AoFc5DnwtreWIjcW+CAjBaG3WiujyrDc+6ZXsL9JGGnLVWg2AnZ5rSkSRxnjIf3yy/fFdT2hD3pBQRTzHpd8cpyILPInE7Xp24FrCrVnzb34NwRzrmQTrZvohYGj4OWAZfncfrZARGbEQgDacyFfuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVsaSVHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVsaSVHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2710D1F00A3D;
	Fri,  4 Sep 2026 05:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499887;
	bh=dekKnfOZBkKRLjOpX6TBJfc9YEudqiVFZ5kZqIRMxaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVsaSVHx8OZrDH6p7jV1eYm7Qx2ye4b9aMs5tmNm3BPBBNOPSH5gyc6ji4jSk4/6x
	 a/RUPNqfbYhEb4otS4t4f0KE4YbGPj1KCwer+E26wwAEJVi/8XaN5t4MrECajHS5b0
	 NCWDaQXKDVdrHt5qhyLDWM5h16+bcR3xaAOKxB9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 575/713] platform/x86/amd/pmc: Fix msg_port restoration in amd_stb_debugfs_open_v2()
Date: Fri,  4 Sep 2026 06:59:03 +0200
Message-ID: <20260904045816.710089352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit cbb32ff92f8a62212e0f7384b1de986ced92082b upstream.

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
 	stb_data_arr = kmalloc_flex(*stb_data_arr, data, fsize);
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


