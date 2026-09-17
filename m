Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD8C4EB865;
	Thu, 17 Sep 2026 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666880; cv=none; b=ev4aahaADRA6vVLHnNTElrQGq71MS/9vEM0DtFIgLTlQ2Q3T3rgTXx9TCwliLF2tOMVuZrFPuXlTvhAIUJLgIuUPjW9GwPLrhz/bihGrnZXXeKGaHUYelrp6977Z5bp1pn7Iud/yfRqgV4gWKl1ZtOwPmfUaKUrWS0Hq4gSnppQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666880; c=relaxed/simple;
	bh=SckJsMtP//kBHffgU3tTdT2Czykb2dSl7mGDIjxJK1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Plya+WOaS/j8W7D16fsAG44kwaOkDLPyA/E3qPdBvvgutW6mG6Zk00WQkEUkP+c+Wqon+regDbOtMtIIA9tBvHl1IFKAnE4gEJHlzXYxKjCp5h+iX9d3H78pzOZZZ13QziCGGLvj52JXBrDQHliDPp3zzMuWGR+nR2o5/sycbQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VyqOy0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VyqOy0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A695E1F00893;
	Thu, 17 Sep 2026 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666879;
	bh=mGxoqwkiwme00F3ECrr0bz5jkbmEoZ/DyZIrz48iyrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0VyqOy0biSdgTpTCxHF+Oz1S/t/m3OoKh92vhlGz/nKeYnlkhMx1ph1NTY3jKapSX
	 2heq7d05n36dOa6zaTm5ijjSHo5zo/cMhB+vD7LhpoxTocLEfTIWwgtr+iDkWX2Avm
	 PwDXmiC0I8pThGb00NVerm1+/1SUy7SiKz/Z3lJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1156/1250] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Thu, 17 Sep 2026 16:15:51 +0100
Message-ID: <20260917151623.598903535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit a152edab3854f01dd2daf3eaf8f32cbabdb3834e ]

qla2x00_do_dport_diagnostics() allocates the qla_dport_diag response
buffer with kmalloc_obj() (non-zeroing) and, on success, copies the full
sizeof(*dd) back to user space via sg_copy_from_buffer(). The inbound
sg_copy_to_buffer() only fills as many bytes as the user request payload
provides, and qla26xx_dport_diagnostics() zeroes only dd->buf. The
options and unused[] fields are therefore copied out uninitialized,
leaking kernel heap contents to user space.

Allocate with kzalloc_obj(), matching qla2x00_do_dport_diagnostics_v2().

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-54-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ Adapted kzalloc_obj(*dd) to kzalloc(sizeof(*dd), GFP_KERNEL) to match the branch’s allocation syntax. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2412,7 +2412,7 @@ qla2x00_do_dport_diagnostics(struct bsg_
 	    !IS_QLA28XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+	dd = kzalloc(sizeof(*dd), GFP_KERNEL);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");


