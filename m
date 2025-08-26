Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166C020CCCA;
	Tue, 26 Aug 2025 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215215; cv=none; b=INNXVvN5WhMcfgI8x1F9OcY4/6rLG9EiBOGyedMOJZJlqvam64ysSfFoohUq1QsZ25uxWoLEb1LYhVhPBuO2aqBdByxn51gEKi8yYsa6he5YrBdMA4JA7H0wIt6kDyggJ83BzoNiLbgNvV8qKT1cR0hpARaRoA0Xx+UGnbjBPUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215215; c=relaxed/simple;
	bh=LI0IZqm5//eghdHfAqql1NbE9x8Y/yhzQBxlYu0NxdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEVSd/Vy94HBi3mJx3O6lGs45t0qiRJiKRvXl12dRJ8LpvX06z1B9X9BfYXOiBIIyt7B+4Z6Hv9o0yGBvl6CWGcljB7ftCY10h/CTbxNvZBBQ9KOeiiuBw/Qc1D32XxJLNam5CYElzGWb/oNC8iJjAmxJ6KYbRYmHbhb84jxP88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpptgIwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpptgIwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C98C4CEF1;
	Tue, 26 Aug 2025 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215215;
	bh=LI0IZqm5//eghdHfAqql1NbE9x8Y/yhzQBxlYu0NxdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpptgIwB0Hp3nWGngdVIXY7JynRR2oXN5QBBG41nGWmRju7a+hGYTcpKfG6dBsf7I
	 Y4Mv/n+M2Wgb/kvZjU2fkXpOZlsqYMRPa4Rfobk3KatEy4NWZMOtg5hMvXRzBs/b7v
	 0LvLDusFSU2fG5dmFEM98REnMNti0yj4oIWEsb60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melody Olvera <quic_molvera@quicinc.com>,
	Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 431/482] soc: qcom: mdt_loader: Enhance split binary detection
Date: Tue, 26 Aug 2025 13:11:24 +0200
Message-ID: <20250826110941.477825243@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>

[ Upstream commit 210d12c8197a551caa2979be421aa42381156aec ]

It may be that the offset of the first program header lies inside the mdt's
filesize, in this case the loader would incorrectly assume that the bins
were not split and in this scenario the firmware authentication fails.
This change updates the logic used by the mdt loader to understand whether
the firmware images are split or not. It figures this out by checking if
each programs header's segment lies within the file or not.

Co-developed-by: Melody Olvera <quic_molvera@quicinc.com>
Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
Signed-off-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230509001821.24010-1-quic_gokukris@quicinc.com
Stable-dep-of: 9f9967fed9d0 ("soc: qcom: mdt_loader: Ensure we don't read past the ELF header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/mdt_loader.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -264,6 +264,26 @@ out:
 }
 EXPORT_SYMBOL_GPL(qcom_mdt_pas_init);
 
+static bool qcom_mdt_bins_are_split(const struct firmware *fw, const char *fw_name)
+{
+	const struct elf32_phdr *phdrs;
+	const struct elf32_hdr *ehdr;
+	uint64_t seg_start, seg_end;
+	int i;
+
+	ehdr = (struct elf32_hdr *)fw->data;
+	phdrs = (struct elf32_phdr *)(ehdr + 1);
+
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		seg_start = phdrs[i].p_offset;
+		seg_end = phdrs[i].p_offset + phdrs[i].p_filesz;
+		if (seg_start > fw->size || seg_end > fw->size)
+			return true;
+	}
+
+	return false;
+}
+
 static int __qcom_mdt_load(struct device *dev, const struct firmware *fw,
 			   const char *fw_name, int pas_id, void *mem_region,
 			   phys_addr_t mem_phys, size_t mem_size,
@@ -276,6 +296,7 @@ static int __qcom_mdt_load(struct device
 	phys_addr_t min_addr = PHYS_ADDR_MAX;
 	ssize_t offset;
 	bool relocate = false;
+	bool is_split;
 	void *ptr;
 	int ret = 0;
 	int i;
@@ -283,6 +304,7 @@ static int __qcom_mdt_load(struct device
 	if (!fw || !mem_region || !mem_phys || !mem_size)
 		return -EINVAL;
 
+	is_split = qcom_mdt_bins_are_split(fw, fw_name);
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(ehdr + 1);
 
@@ -336,8 +358,7 @@ static int __qcom_mdt_load(struct device
 
 		ptr = mem_region + offset;
 
-		if (phdr->p_filesz && phdr->p_offset < fw->size &&
-		    phdr->p_offset + phdr->p_filesz <= fw->size) {
+		if (phdr->p_filesz && !is_split) {
 			/* Firmware is large enough to be non-split */
 			if (phdr->p_offset + phdr->p_filesz > fw->size) {
 				dev_err(dev, "file %s segment %d would be truncated\n",


