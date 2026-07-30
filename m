Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F8D358373;
	Thu, 30 Jul 2026 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426494; cv=none; b=ZL9Y/IRCJnM6uaBF8T6g8/7YhsSTRJMq2WqzAT3QxIyyHAA/Wad1o5semOwCNT/TCm4KmMOCzxG8Y3AqtdvvS4eh2qD667vP7Z7Zjczf9YWEDSrED1AJkS0byLcoOL/dl9G9xs4ii0ovYz6RfuCP+oeNd44lnI/GrYmfKxov4Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426494; c=relaxed/simple;
	bh=qglDAOB7VJwHJLlbx3tcmvsTShD4ZhQjH22yp4TmEVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lx3W9gRNxCEFB+R+rmA49/LE0dQDOVd84OsojWELift7K523ErMicM59ZYjgyIV31oc/qCNYR9Bbn0SuTB0lZbQR8+OsB2DXQnnvu227aY9CTprFmtfM5NmD6/+yEG4dTpsejlNQs/25iPsa2WMcQiO/KXDD5ldDbva16ktUjgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryUsKdeO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryUsKdeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C631F000E9;
	Thu, 30 Jul 2026 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426493;
	bh=Jfgfuo3Rk+juR6qKmC4u/81N/F9E/+8XdZ3BV+AGrb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ryUsKdeOtu+zf+CgLYmEOte2LsujUrkswd4qpICx8fMl4Q+EHcTK/uMM75PnpiJsF
	 vwOxla8GWvPXeJdaFkkFcpih9UVMKdOTRFxDe/Fao7egX50Lj4itbu5/5zTVjMg3LL
	 AKO43tV9J103U+TfQ3Aq8+du7DnqJukAWuYw0720=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 422/602] ice: reject out-of-range ptype in ice_parser_profile_init
Date: Thu, 30 Jul 2026 16:13:34 +0200
Message-ID: <20260730141444.832486685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

commit 59abb87159c53605c063f6e2ceb215b5eba43ee6 upstream.

set_bit(rslt->ptype, prof->ptypes) operates on a DECLARE_BITMAP of
ICE_FLOW_PTYPE_MAX (1024) bits. Nothing prevents a malicious VF from
providing ptype >= 1024 through VIRTCHNL, resulting in a write past
the end of the bitmap and a kernel page fault.

Reproduced with a custom kernel module injecting a crafted
VIRTCHNL_OP_ADD_RSS_CFG on E810-C QSFP (8086:1592),
FW 4.91 0x800214af 1.3909.0, ICE COMMS DDP 1.3.53.0,
kernel 7.1.0-rc1.

crash_parser: ice_parser_profile_init @ ffffffffc0d61b60
crash_parser: setting ptype=0xffff (max valid=1023)
crash_parser: calling ice_parser_profile_init -- expect OOB crash!
BUG: kernel NULL pointer dereference, address: 0000000000000000
Oops: Oops: 0002 [#1] SMP NOPTI
CPU: 56 UID: 0 PID: 165011 Comm: insmod Kdump: loaded Tainted: G S U OE 7.1.0-rc1 #1
Hardware name: Intel Corporation S2600BPB/S2600BPB
RIP: 0010:ice_parser_profile_init+0x2d/0x1d0 [ice]
Call Trace:
 <TASK>
 ? __pfx_ice_parser_profile_init+0x10/0x10 [ice]
 crash_init+0x127/0xff0 [crash_parser]
 do_one_initcall+0x45/0x310
 do_init_module+0x64/0x270
 init_module_from_file+0xcc/0xf0
 idempotent_init_module+0x17b/0x280
 __x64_sys_finit_module+0x6e/0xe0

Bail out early with -EINVAL when ptype is out of range.

Fixes: e312b3a1e209 ("ice: add API for parser profile initialization")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-12-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_parser.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_parser.c
+++ b/drivers/net/ethernet/intel/ice/ice_parser.c
@@ -2368,6 +2368,9 @@ int ice_parser_profile_init(struct ice_p
 	u16 proto_off = 0;
 	u16 off;
 
+	if (rslt->ptype >= ICE_FLOW_PTYPE_MAX)
+		return -EINVAL;
+
 	memset(prof, 0, sizeof(*prof));
 	set_bit(rslt->ptype, prof->ptypes);
 	if (blk == ICE_BLK_SW) {


