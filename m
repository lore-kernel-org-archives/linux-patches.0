Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87171779B1;
	Tue,  8 Oct 2024 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391145; cv=none; b=GSXw+ymjXGWLemlvFxr1GfGVPaVg7k4lSmhGZYwy4WVf0tLIgCPdrRuRGcBSR0rjl0NAB1F6nEyn9etOhBLIEawUnnEpyqLxtZZdJTDwN0psRdQHnh025Oz4OhxDiG3kIDB3e9+U3LPaGEbUKKBbto/HHzg2PHm7Pr+MZjJ2I1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391145; c=relaxed/simple;
	bh=60NJX3r2XVJZyemCANvq28h/vi1ycQ+4gI58+j3Buu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFMkAYmQi494H/uAkYM5OQWkJWDNdw0RruL8e593CETeXzkw0MaqsXekdDQhjye7FMxK3sQxEccwnEbRdVSMHCKTwFDGvuTfatMY6G/n2nzfE6UuCqKC45jeJGYamJt6stk0LJbM+8yEjHt8EsV3ok1wbN1tRaKvpM+gExm/7FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fv3iLZ4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fv3iLZ4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B52C4CEC7;
	Tue,  8 Oct 2024 12:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391145;
	bh=60NJX3r2XVJZyemCANvq28h/vi1ycQ+4gI58+j3Buu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fv3iLZ4xZAm/EBrDWI6zJ1r4xOF43oS5kxzR6lTgmQWJmKutKvMfesmASNAfv5sDT
	 iKbStdwxMjsu+Y6Co4aTiX3Y18lk6HfbBStI0M/ZlWYpHz5sM5IJaee2LnFGiAC/s6
	 bosZ8AIF2cdI7eWpvBp+K6S7jbU4BAq03bnZzVrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanyuan Zhong <yzhong@purestorage.com>,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 021/558] net/mlx5: Added cond_resched() to crdump collection
Date: Tue,  8 Oct 2024 14:00:51 +0200
Message-ID: <20241008115703.057973695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit ec793155894140df7421d25903de2e6bc12c695b ]

Collecting crdump involves reading vsc registers from pci config space
of mlx device, which can take long time to complete. This might result
in starving other threads waiting to run on the cpu.

Numbers I got from testing ConnectX-5 Ex MCX516A-CDAT in the lab:

- mlx5_vsc_gw_read_block_fast() was called with length = 1310716.
- mlx5_vsc_gw_read_fast() reads 4 bytes at a time. It was not used to
  read the entire 1310716 bytes. It was called 53813 times because
  there are jumps in read_addr.
- On average mlx5_vsc_gw_read_fast() took 35284.4ns.
- In total mlx5_vsc_wait_on_flag() called vsc_read() 54707 times.
  The average time for each call was 17548.3ns. In some instances
  vsc_read() was called more than one time when the flag was not set.
  As expected the thread released the cpu after 16 iterations in
  mlx5_vsc_wait_on_flag().
- Total time to read crdump was 35284.4ns * 53813 ~= 1.898s.

It was seen in the field that crdump can take more than 5 seconds to
complete. During that time mlx5_vsc_wait_on_flag() did not release the
cpu because it did not complete 16 iterations. It is believed that pci
config reads were slow. Adding cond_resched() every 128 register read
improves the situation. In the common case the, crdump takes ~1.8989s,
the thread yields the cpu every ~4.51ms. If crdump takes ~5s, the thread
yields the cpu every ~18.0ms.

Fixes: 8b9d8baae1de ("net/mlx5: Add Crdump support")
Reviewed-by: Yuanyuan Zhong <yzhong@purestorage.com>
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c
index d0b595ba61101..432c98f2626db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c
@@ -24,6 +24,11 @@
 	pci_write_config_dword((dev)->pdev, (dev)->vsc_addr + (offset), (val))
 #define VSC_MAX_RETRIES 2048
 
+/* Reading VSC registers can take relatively long time.
+ * Yield the cpu every 128 registers read.
+ */
+#define VSC_GW_READ_BLOCK_COUNT 128
+
 enum {
 	VSC_CTRL_OFFSET = 0x4,
 	VSC_COUNTER_OFFSET = 0x8,
@@ -273,6 +278,7 @@ int mlx5_vsc_gw_read_block_fast(struct mlx5_core_dev *dev, u32 *data,
 {
 	unsigned int next_read_addr = 0;
 	unsigned int read_addr = 0;
+	unsigned int count = 0;
 
 	while (read_addr < length) {
 		if (mlx5_vsc_gw_read_fast(dev, read_addr, &next_read_addr,
@@ -280,6 +286,10 @@ int mlx5_vsc_gw_read_block_fast(struct mlx5_core_dev *dev, u32 *data,
 			return read_addr;
 
 		read_addr = next_read_addr;
+		if (++count == VSC_GW_READ_BLOCK_COUNT) {
+			cond_resched();
+			count = 0;
+		}
 	}
 	return length;
 }
-- 
2.43.0



