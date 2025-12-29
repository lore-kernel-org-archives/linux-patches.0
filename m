Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7CD264FBD;
	Mon, 29 Dec 2025 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026007; cv=none; b=Um6LNV2r+Tk3IXRrZB0TDc17hUO9rj8J7C7pqXQ50UdeZX+u4ZBpuWAFgPkZXInBbgwUvXdtVz6hH9vuSDj4yoBIKwjse21b+v5xWoRNI5d84Msvd6QDYcgNUXvFN5bUIf2eIrgTQj+5pdVvjHFdaUQzhS/40M2jX2Gkha7Nu8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026007; c=relaxed/simple;
	bh=X8Ns0LSm0WaIPXB5B70GOXsV3cllhVabIC2C4B+lQzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krfT4n3CuqBYOMuNF7F6SgRwp9PJ71IEYhtScsSkhHfPOYVCzkvu/DXTNuI7CSX8eIFPWvPOQZsc1X6OCbOoPBFT/9Xwu1e2QxsLCuNIWTmp3i9zb/O3bvHDBtfgh6K8CRiwoQJ4pL5lnYNo13hNtr9m9VABUBuEEpf1y49By+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBIGlOpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBIGlOpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B402C4CEF7;
	Mon, 29 Dec 2025 16:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026007;
	bh=X8Ns0LSm0WaIPXB5B70GOXsV3cllhVabIC2C4B+lQzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBIGlOpF1odroOG4W4150Dhsbe2PlhoOZGiktqQk1xyRq58dWWHy30zF30TvLQ0Bv
	 RDhen0cXp8diTRHMuRbwNFEzswYgPn4OBWUVPNP8vAk9tVI1mMOCBZJhW23pwNehSu
	 Mepj/P8eUh6hTdKsHZamRWPaE8t1bUoLMuBg4I08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH 6.18 381/430] s390/ipl: Clear SBP flag when bootprog is set
Date: Mon, 29 Dec 2025 17:13:03 +0100
Message-ID: <20251229160738.343628699@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

commit b1aa01d31249bd116b18c7f512d3e46b4b4ad83b upstream.

With z16 a new flag 'search boot program' was introduced for
list-directed IPL (SCSI, NVMe, ECKD DASD). If this flag is set,
e.g. via selecting the "Automatic" value for the "Boot program
selector" control on an HMC load panel, it is copied to the reipl
structure from the initial ipl structure. When a user now sets a
boot prog via sysfs, the flag is not cleared and the bootloader
will again automatically select the boot program, ignoring user
configuration.

To avoid that, clear the SBP flag when a bootprog sysfs file is
written.

Cc: stable@vger.kernel.org
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/uapi/asm/ipl.h |    1 
 arch/s390/kernel/ipl.c           |   48 +++++++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 12 deletions(-)

--- a/arch/s390/include/uapi/asm/ipl.h
+++ b/arch/s390/include/uapi/asm/ipl.h
@@ -15,6 +15,7 @@ struct ipl_pl_hdr {
 #define IPL_PL_FLAG_IPLPS	0x80
 #define IPL_PL_FLAG_SIPL	0x40
 #define IPL_PL_FLAG_IPLSR	0x20
+#define IPL_PL_FLAG_SBP		0x10
 
 /* IPL Parameter Block header */
 struct ipl_pb_hdr {
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -262,6 +262,24 @@ static struct kobj_attribute sys_##_pref
 			sys_##_prefix##_##_name##_show,			\
 			sys_##_prefix##_##_name##_store)
 
+#define DEFINE_IPL_ATTR_BOOTPROG_RW(_prefix, _name, _fmt_out, _fmt_in, _hdr, _value)	\
+	IPL_ATTR_SHOW_FN(_prefix, _name, _fmt_out, (unsigned long long) _value)		\
+static ssize_t sys_##_prefix##_##_name##_store(struct kobject *kobj,			\
+		struct kobj_attribute *attr,						\
+		const char *buf, size_t len)						\
+{											\
+	unsigned long long value;							\
+	if (sscanf(buf, _fmt_in, &value) != 1)						\
+		return -EINVAL;								\
+	(_value) = value;								\
+	(_hdr).flags &= ~IPL_PL_FLAG_SBP;						\
+	return len;									\
+}											\
+static struct kobj_attribute sys_##_prefix##_##_name##_attr =				\
+	__ATTR(_name, 0644,								\
+			sys_##_prefix##_##_name##_show,					\
+			sys_##_prefix##_##_name##_store)
+
 #define DEFINE_IPL_ATTR_STR_RW(_prefix, _name, _fmt_out, _fmt_in, _value)\
 IPL_ATTR_SHOW_FN(_prefix, _name, _fmt_out, _value)			\
 static ssize_t sys_##_prefix##_##_name##_store(struct kobject *kobj,	\
@@ -818,12 +836,13 @@ DEFINE_IPL_ATTR_RW(reipl_fcp, wwpn, "0x%
 		   reipl_block_fcp->fcp.wwpn);
 DEFINE_IPL_ATTR_RW(reipl_fcp, lun, "0x%016llx\n", "%llx\n",
 		   reipl_block_fcp->fcp.lun);
-DEFINE_IPL_ATTR_RW(reipl_fcp, bootprog, "%lld\n", "%lld\n",
-		   reipl_block_fcp->fcp.bootprog);
 DEFINE_IPL_ATTR_RW(reipl_fcp, br_lba, "%lld\n", "%lld\n",
 		   reipl_block_fcp->fcp.br_lba);
 DEFINE_IPL_ATTR_RW(reipl_fcp, device, "0.0.%04llx\n", "0.0.%llx\n",
 		   reipl_block_fcp->fcp.devno);
+DEFINE_IPL_ATTR_BOOTPROG_RW(reipl_fcp, bootprog, "%lld\n", "%lld\n",
+			    reipl_block_fcp->hdr,
+			    reipl_block_fcp->fcp.bootprog);
 
 static void reipl_get_ascii_loadparm(char *loadparm,
 				     struct ipl_parameter_block *ibp)
@@ -942,10 +961,11 @@ DEFINE_IPL_ATTR_RW(reipl_nvme, fid, "0x%
 		   reipl_block_nvme->nvme.fid);
 DEFINE_IPL_ATTR_RW(reipl_nvme, nsid, "0x%08llx\n", "%llx\n",
 		   reipl_block_nvme->nvme.nsid);
-DEFINE_IPL_ATTR_RW(reipl_nvme, bootprog, "%lld\n", "%lld\n",
-		   reipl_block_nvme->nvme.bootprog);
 DEFINE_IPL_ATTR_RW(reipl_nvme, br_lba, "%lld\n", "%lld\n",
 		   reipl_block_nvme->nvme.br_lba);
+DEFINE_IPL_ATTR_BOOTPROG_RW(reipl_nvme, bootprog, "%lld\n", "%lld\n",
+			    reipl_block_nvme->hdr,
+			    reipl_block_nvme->nvme.bootprog);
 
 static struct attribute *reipl_nvme_attrs[] = {
 	&sys_reipl_nvme_fid_attr.attr,
@@ -1038,8 +1058,9 @@ static const struct bin_attribute *const
 };
 
 DEFINE_IPL_CCW_ATTR_RW(reipl_eckd, device, reipl_block_eckd->eckd);
-DEFINE_IPL_ATTR_RW(reipl_eckd, bootprog, "%lld\n", "%lld\n",
-		   reipl_block_eckd->eckd.bootprog);
+DEFINE_IPL_ATTR_BOOTPROG_RW(reipl_eckd, bootprog, "%lld\n", "%lld\n",
+			    reipl_block_eckd->hdr,
+			    reipl_block_eckd->eckd.bootprog);
 
 static struct attribute *reipl_eckd_attrs[] = {
 	&sys_reipl_eckd_device_attr.attr,
@@ -1567,12 +1588,13 @@ DEFINE_IPL_ATTR_RW(dump_fcp, wwpn, "0x%0
 		   dump_block_fcp->fcp.wwpn);
 DEFINE_IPL_ATTR_RW(dump_fcp, lun, "0x%016llx\n", "%llx\n",
 		   dump_block_fcp->fcp.lun);
-DEFINE_IPL_ATTR_RW(dump_fcp, bootprog, "%lld\n", "%lld\n",
-		   dump_block_fcp->fcp.bootprog);
 DEFINE_IPL_ATTR_RW(dump_fcp, br_lba, "%lld\n", "%lld\n",
 		   dump_block_fcp->fcp.br_lba);
 DEFINE_IPL_ATTR_RW(dump_fcp, device, "0.0.%04llx\n", "0.0.%llx\n",
 		   dump_block_fcp->fcp.devno);
+DEFINE_IPL_ATTR_BOOTPROG_RW(dump_fcp, bootprog, "%lld\n", "%lld\n",
+			    dump_block_fcp->hdr,
+			    dump_block_fcp->fcp.bootprog);
 
 DEFINE_IPL_ATTR_SCP_DATA_RW(dump_fcp, dump_block_fcp->hdr,
 			    dump_block_fcp->fcp,
@@ -1604,10 +1626,11 @@ DEFINE_IPL_ATTR_RW(dump_nvme, fid, "0x%0
 		   dump_block_nvme->nvme.fid);
 DEFINE_IPL_ATTR_RW(dump_nvme, nsid, "0x%08llx\n", "%llx\n",
 		   dump_block_nvme->nvme.nsid);
-DEFINE_IPL_ATTR_RW(dump_nvme, bootprog, "%lld\n", "%llx\n",
-		   dump_block_nvme->nvme.bootprog);
 DEFINE_IPL_ATTR_RW(dump_nvme, br_lba, "%lld\n", "%llx\n",
 		   dump_block_nvme->nvme.br_lba);
+DEFINE_IPL_ATTR_BOOTPROG_RW(dump_nvme, bootprog, "%lld\n", "%llx\n",
+			    dump_block_nvme->hdr,
+			    dump_block_nvme->nvme.bootprog);
 
 DEFINE_IPL_ATTR_SCP_DATA_RW(dump_nvme, dump_block_nvme->hdr,
 			    dump_block_nvme->nvme,
@@ -1635,8 +1658,9 @@ static const struct attribute_group dump
 
 /* ECKD dump device attributes */
 DEFINE_IPL_CCW_ATTR_RW(dump_eckd, device, dump_block_eckd->eckd);
-DEFINE_IPL_ATTR_RW(dump_eckd, bootprog, "%lld\n", "%llx\n",
-		   dump_block_eckd->eckd.bootprog);
+DEFINE_IPL_ATTR_BOOTPROG_RW(dump_eckd, bootprog, "%lld\n", "%llx\n",
+			    dump_block_eckd->hdr,
+			    dump_block_eckd->eckd.bootprog);
 
 IPL_ATTR_BR_CHR_SHOW_FN(dump, dump_block_eckd->eckd);
 IPL_ATTR_BR_CHR_STORE_FN(dump, dump_block_eckd->eckd);


