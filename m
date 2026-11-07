Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065549;
	b=W3gHUIee4eqtvaKrjl/9vZ0sb6sdC3pnSh2CCh3+NVrTNZNcSfpubrdChw5bJ3H+qxL/
	 fflJzlKjnVdmeaxrnig1zNtz22q/T8F3CNIl6azsCbYkBNaZuheH3/YFWkihOyOsJmwrz
	 BaiogmIwLUPKEXmgcqYxsf+/wMhUwUuLiSDojev7XO2qtGjd3LrUB3myUW3c9GrzzJwWH
	 eGMlPS9eATbmnS0h+ANFo2nGlB0lr5phcvSwlHDtrTyyDWXkVxeGYq1ft5ctW9/UE0C9L
	 nSG1Rk5SbZAJIDeiUXRRWx0r1zfcMqwgdHY+siZg5LYyP1hxypxqM5txEZA/l2IUz7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=udvtJOBfuDw4WU7pBPLA9YQwkWj05ke0zPnByujIL3o=;
	b=reIiGDJac3fqIjlplS43467CNI3TuslcR3vb42UeloHCEBqaBLviNF/dfpMqxSjdocAK
	 UhJemjzS+eq0etqgeMS8ZfV66o6cVEBT5EOIxxw8dxLSDTdg17z0RI8P8aKfBwbcUUE12
	 fXs6tA0hlSpq5HirlAdzHAGuT4XS4xRD7R9f126twbGj3FNHOq2/CcvmCxIHvnHAmYac/
	 df4LcpTleKxYlDbn2UDlmtMWTSCbXngouDBgxIQ3trDfyWBm1ZPvwfgk3L1ur+9rygrJV
	 l8tbP6oVmOj7EF6EVNiIvheGliVsprDzatshWpDxnG/h5OYy5yCUoVfb1z4J2bXfysA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZCi2NYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538AD606A330;
	Sat,  7 Nov 2026 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZCi2NYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA191F0089F;
	Sat,  7 Nov 2026 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065548;
	bh=udvtJOBfuDw4WU7pBPLA9YQwkWj05ke0zPnByujIL3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZCi2NYMGNYtWQaz+uA5+Kd3/bfhtnycJkVF5EncT2jgrMm3WVha507iao1wXXXXr
	 6O+ufB1tOvm/qzWiwIYr7IljZB74TnNKGF8VcNoVQeJdnswBE65jlZMEESQ6ngE98D
	 xzkz3nSE7l6Kc2fHgYVA3HDxycHly2RVPCMbZ7Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1205/1257] nvmet: pci-epf: require SGLs to match the command data length
Date: Sat,  7 Nov 2026 08:58:21 -0500
Message-ID: <20261107135012.629510829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 9fb4adbc39751697b9fcf71e45bd5d5119c3f07c ]

The PCI endpoint target sends the host every byte a read command's SGL
describes, even when the SGL describes more than the command transfers.
The excess is kmalloc() memory the command never wrote, so the host
receives stale target memory. Any successful read can do this,
including Identify.

nvmet_pci_epf_alloc_iod_data_buf() allocates each segment at the length
of its SGL data descriptor, but sets req->transfer_len from
iod->data_len, the length the command implies. Once the command
completes, nvmet_pci_epf_transfer_iod_data() sends every segment in
full. Nothing compares the descriptor lengths with iod->data_len, and
the MDTS check only bounds iod->data_len.

Fail the command with Data SGL Length Invalid when the data descriptors
do not add up to iod->data_len, before any segment is allocated. The
tcp and rdma transports take the data length from the SGL itself, so
there most commands already reject a mismatch in
nvmet_check_transfer_len(). PRP lists are built from iod->data_len and
are unaffected.

Found by code inspection.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Cc: stable@vger.kernel.org
Tested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index 4c5fff232fb99..a8df176c1a574 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1073,10 +1073,22 @@ static int nvmet_pci_epf_iod_parse_sgl_segments(struct nvmet_pci_epf_ctrl *ctrl,
 	return 0;
 }
 
+static u64 nvmet_pci_epf_iod_data_segs_len(struct nvmet_pci_epf_iod *iod)
+{
+	u64 len = 0;
+	int i;
+
+	for (i = 0; i < iod->nr_data_segs; i++)
+		len += iod->data_segs[i].length;
+
+	return len;
+}
+
 static int nvmet_pci_epf_iod_parse_sgls(struct nvmet_pci_epf_iod *iod)
 {
 	struct nvmet_pci_epf_ctrl *ctrl = iod->ctrl;
 	struct nvme_sgl_desc *sgl = &iod->cmd.common.dptr.sgl;
+	int ret;
 
 	if (sgl->type == (NVME_SGL_FMT_DATA_DESC << 4)) {
 		/* Single data descriptor case. */
@@ -1084,10 +1096,23 @@ static int nvmet_pci_epf_iod_parse_sgls(struct nvmet_pci_epf_iod *iod)
 		iod->data_segs = &iod->data_seg;
 		iod->data_seg.pci_addr = le64_to_cpu(sgl->addr);
 		iod->data_seg.length = le32_to_cpu(sgl->length);
-		return 0;
+	} else {
+		ret = nvmet_pci_epf_iod_parse_sgl_segments(ctrl, iod);
+		if (ret)
+			return ret;
 	}
 
-	return nvmet_pci_epf_iod_parse_sgl_segments(ctrl, iod);
+	/*
+	 * The command executes on data_len bytes, but each segment is
+	 * allocated and transferred in full, so they must describe exactly
+	 * data_len bytes.
+	 */
+	if (nvmet_pci_epf_iod_data_segs_len(iod) != iod->data_len) {
+		iod->status = NVME_SC_SGL_INVALID_DATA | NVME_STATUS_DNR;
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int nvmet_pci_epf_alloc_iod_data_buf(struct nvmet_pci_epf_iod *iod)
-- 
2.53.0



