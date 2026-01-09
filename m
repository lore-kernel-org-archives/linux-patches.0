Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC9632F748;
	Fri,  9 Jan 2026 12:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960666; cv=none; b=T5yyFIi66LdmvnP6wo8SYyLvXIK+giMKY+kZ60nGhII7ZtIOeTarj94hDsrEwm8RLRdERdBr7G5RboK1m1es5ziT51I8Zh+QsuOwjRuUrssQ5i8+zW+nAp/WK7U53m57xB/fDUxYoTZgO3td+VIA3qErFuSwocvyBdTGpQ+2tdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960666; c=relaxed/simple;
	bh=zJupx4jlLo4pbF8Bowfyj9Js6ktFXWL1RG4lirtaMq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIMcc3vsLdYtuFkkI2BunAb3sOl8nShESo8Hq/ss6bZLNIS4+Pq2LSuqQjrfwGiWcq7d8bncWeaOibb/zSeKfy3kRShQjr0Bs3RDeoNd9gsMXQX3GNkIWadqIJgQzt9U9/DwIdfjWJUL9JmZZDTd3vSmleSY9rVpGGTVdy5CuLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgkAvaFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgkAvaFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2970C19421;
	Fri,  9 Jan 2026 12:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960666;
	bh=zJupx4jlLo4pbF8Bowfyj9Js6ktFXWL1RG4lirtaMq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgkAvaFb7Bh+KbiH/nB5aIJYm884hB+3OsTP18OzFDJhrx+xdoxV36VZ9ssIBY06q
	 Q7jyVKNXjlT22SSfGmeqkeK+UjZ7rcMCkj7KpVQrujjLDH3Q3xtQeOnWzeyh35nS3P
	 ozn2fntEsNYoDv8332VFVwy/948qQpQ9rfJVgBPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH 6.6 482/737] s390/ipl: Clear SBP flag when bootprog is set
Date: Fri,  9 Jan 2026 12:40:21 +0100
Message-ID: <20260109112152.118267756@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -260,6 +260,24 @@ static struct kobj_attribute sys_##_pref
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
@@ -824,12 +842,13 @@ DEFINE_IPL_ATTR_RW(reipl_fcp, wwpn, "0x%
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
@@ -982,10 +1001,11 @@ DEFINE_IPL_ATTR_RW(reipl_nvme, fid, "0x%
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
@@ -1112,8 +1132,9 @@ static struct bin_attribute *reipl_eckd_
 };
 
 DEFINE_IPL_CCW_ATTR_RW(reipl_eckd, device, reipl_block_eckd->eckd);
-DEFINE_IPL_ATTR_RW(reipl_eckd, bootprog, "%lld\n", "%lld\n",
-		   reipl_block_eckd->eckd.bootprog);
+DEFINE_IPL_ATTR_BOOTPROG_RW(reipl_eckd, bootprog, "%lld\n", "%lld\n",
+			    reipl_block_eckd->hdr,
+			    reipl_block_eckd->eckd.bootprog);
 
 static struct attribute *reipl_eckd_attrs[] = {
 	&sys_reipl_eckd_device_attr.attr,
@@ -1641,12 +1662,13 @@ DEFINE_IPL_ATTR_RW(dump_fcp, wwpn, "0x%0
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
 
 static struct attribute *dump_fcp_attrs[] = {
 	&sys_dump_fcp_device_attr.attr,
@@ -1667,10 +1689,11 @@ DEFINE_IPL_ATTR_RW(dump_nvme, fid, "0x%0
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
 
 static struct attribute *dump_nvme_attrs[] = {
 	&sys_dump_nvme_fid_attr.attr,
@@ -1687,8 +1710,9 @@ static struct attribute_group dump_nvme_
 
 /* ECKD dump device attributes */
 DEFINE_IPL_CCW_ATTR_RW(dump_eckd, device, dump_block_eckd->eckd);
-DEFINE_IPL_ATTR_RW(dump_eckd, bootprog, "%lld\n", "%llx\n",
-		   dump_block_eckd->eckd.bootprog);
+DEFINE_IPL_ATTR_BOOTPROG_RW(dump_eckd, bootprog, "%lld\n", "%llx\n",
+			    dump_block_eckd->hdr,
+			    dump_block_eckd->eckd.bootprog);
 
 IPL_ATTR_BR_CHR_SHOW_FN(dump, dump_block_eckd->eckd);
 IPL_ATTR_BR_CHR_STORE_FN(dump, dump_block_eckd->eckd);


