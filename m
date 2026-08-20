Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E288737CD5A;
	Thu, 20 Aug 2026 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243193; cv=none; b=lVQTsRJ/KgbwVRCmkyIJdY7JGncojmqNvMxkrhklx+1IWCBG3Ejes5RQBU2WVdnWs8GCLe7WvSwn+0ig2r+s6ky2F9btEcRE+hjWpoXZhVZWFQLDqZ9tBsBFBOg8qtN1a4+FgLNCYblCWevCnuchPkMsIMddYSihxe7VHC3jGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243193; c=relaxed/simple;
	bh=emYYQd0OMiqatBUdL4+qBWhLPNHpzEMs/peoy5rDzB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsN+szbukB66cJpjgExSWo3tTVr/sUDf5S67LfuOUjVPLDNw1s4+Con4rlqU/0UFbXmKaNwGvls2bt9EPUruAJZDQMaInuSj5M1+ueu0Rx5JE8Rj0Ha0lidQsiA/DK2vt0SsadNXW9crHNzigE/a/lzEkLB0Kq/W2dNXUOn1SUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1Uz1bZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1Uz1bZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EDF1F000E9;
	Thu, 20 Aug 2026 16:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243191;
	bh=GhVoT/6LWtUY2vQTyaBhTowpSsf19NYX713gv3LizMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1Uz1bZ/hNTlu9PwF43zjJfyJRs5VkyzivR46GpKTlqPGpnOu2j3zveKJdEKjTGg5
	 9QggHJTPuRFAXo932ub2lTSbLiKLQHZi/DfvqhIeVFfi8reLZOsHOQ4u44ZbfpMudp
	 8/70B0ubcJwmouSc4JuhoeZDMXCwuuePRImrNZqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 010/272] s390/qeth: validate user buffer length in SNMP and ARP query ioctls
Date: Thu, 20 Aug 2026 16:53:14 +0200
Message-ID: <20260820145231.546380188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidayath Khan <hidayath@linux.ibm.com>

commit d141f087b1af656f055d7c5793a3e87817ba0bbe upstream.

qeth_snmp_command() and qeth_l3_arp_query() allocate a buffer sized by
a user-supplied length (udata_len) without checking a lower bound, then
set udata_offset to a fixed non-zero value and pass both to a reply
callback. The callback bounds-checks the copy with

        if ((udata_len - udata_offset) < len)

Both fields are u32, so a udata_len smaller than udata_offset makes the
subtraction wrap and the check pass, and the following memcpy() writes
past the allocation. A udata_len of 0 also yields ZERO_SIZE_PTR from
kzalloc(), which the existing NULL check does not catch.

Reject buffers smaller than udata_offset before allocating, so the
callback subtraction can no longer underflow.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260730142216.218309-1-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core_main.c |    3 +++
 drivers/s390/net/qeth_l3_main.c   |    5 +++++
 2 files changed, 8 insertions(+)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4674,6 +4674,9 @@ static int qeth_snmp_command(struct qeth
 	if (req_len > QETH_BUFSIZE)
 		return -EINVAL;
 
+	if (qinfo.udata_len < sizeof(struct qeth_snmp_ureq_hdr))
+		return -EINVAL;
+
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_SNMP_CONTROL, req_len);
 	if (!iob)
 		return -ENOMEM;
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1415,6 +1415,11 @@ static int qeth_l3_arp_query(struct qeth
 		rc = -EFAULT;
 		goto out;
 	}
+
+	if (qinfo.udata_len < QETH_QARP_ENTRIES_OFFSET) {
+		rc = -EINVAL;
+		goto out;
+	}
 	qinfo.udata = kzalloc(qinfo.udata_len, GFP_KERNEL);
 	if (!qinfo.udata) {
 		rc = -ENOMEM;


