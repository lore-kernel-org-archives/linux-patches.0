Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC42A1DFF4;
	Mon,  1 Apr 2024 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990991; cv=none; b=lRdsJJGu5hGBnPFVxwppH+jSCc1r2v5V/Eifhf6pU2jC3uLjbeCeA0ZRKy9YCqNd96lYCycJjx2GtMxnKJtStTaE5EEBwsXYfLnjJ4gRSlMyyU+YsGC7Zbyx1DWdJsI6bJVFJoiAEYJUUwu4TsbMWDIp7UvE17ed7MgaaPgWo8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990991; c=relaxed/simple;
	bh=HmqDDls9qGsvbfLCwXl5le3uMoNioT0sYPR6NhZXzow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oFBnxDgjZlalrRt4D4OhcFZOEM7QJoSKKDA8DmY/is48IKaS+BckeyzPxzQuweN/F2tnSEpPQz11z1drIoVJ3gwZwJjw5sTtm67kXiizrZ2CRW0riPriZdJnwtRLG3WExwebv8s8aEHqnUGowFkyH02ajVlI/gMP5j1X08iJWLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTLkK3ar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTLkK3ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFC3C433C7;
	Mon,  1 Apr 2024 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990991;
	bh=HmqDDls9qGsvbfLCwXl5le3uMoNioT0sYPR6NhZXzow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTLkK3arb/ALQVilWxKRar48AN/IYYDrZ3mYYjpoNEj0aAImayUyCeO94Q5L3X6Hy
	 TXCGrdkEHhiHRGlbipRkqaaz3b9B/3JHmIekUUAkKmUVFIzNpE+Y5yF2TstCPB+cgs
	 F4FBbO9RVrugTMmyNhRUGdXzdsDXx+b2u4XShCZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	netdev <netdev@vger.kernel.org>,
	Yisen Zhuang <yisen.zhuang@huawei.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Yufeng Mo <moyufeng@huawei.com>,
	Huazhong Tan <tanhuazhong@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/272] net: hns3: tracing: fix hclgevf trace event strings
Date: Mon,  1 Apr 2024 17:45:20 +0200
Message-ID: <20240401152534.735879555@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 3f9952e8d80cca2da3b47ecd5ad9ec16cfd1a649 ]

The __string() and __assign_str() helper macros of the TRACE_EVENT() macro
are going through some optimizations where only the source string of
__string() will be used and the __assign_str() source will be ignored and
later removed.

To make sure that there's no issues, a new check is added between the
__string() src argument and the __assign_str() src argument that does a
strcmp() to make sure they are the same string.

The hclgevf trace events have:

  __assign_str(devname, &hdev->nic.kinfo.netdev->name);

Which triggers the warning:

hclgevf_trace.h:34:39: error: passing argument 1 of ‘strcmp’ from incompatible pointer type [-Werror=incompatible-pointer-types]
   34 |                 __assign_str(devname, &hdev->nic.kinfo.netdev->name);
 [..]
arch/x86/include/asm/string_64.h:75:24: note: expected ‘const char *’ but argument is of type ‘char (*)[16]’
   75 | int strcmp(const char *cs, const char *ct);
      |            ~~~~~~~~~~~~^~

Because __assign_str() now has:

	WARN_ON_ONCE(__builtin_constant_p(src) ?		\
		     strcmp((src), __data_offsets.dst##_ptr_) :	\
		     (src) != __data_offsets.dst##_ptr_);	\

The problem is the '&' on hdev->nic.kinfo.netdev->name. That's because
that name is:

	char			name[IFNAMSIZ]

Where passing an address '&' of a char array is not compatible with strcmp().

The '&' is not necessary, remove it.

Link: https://lore.kernel.org/linux-trace-kernel/20240313093454.3909afe7@gandalf.local.home

Cc: netdev <netdev@vger.kernel.org>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Yufeng Mo <moyufeng@huawei.com>
Cc: Huazhong Tan <tanhuazhong@huawei.com>
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Fixes: d8355240cf8fb ("net: hns3: add trace event support for PF/VF mailbox")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h  | 8 ++++----
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h    | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
index 8510b88d49820..f3cd5a376eca9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
@@ -24,7 +24,7 @@ TRACE_EVENT(hclge_pf_mbx_get,
 		__field(u8, code)
 		__field(u8, subcode)
 		__string(pciname, pci_name(hdev->pdev))
-		__string(devname, &hdev->vport[0].nic.kinfo.netdev->name)
+		__string(devname, hdev->vport[0].nic.kinfo.netdev->name)
 		__array(u32, mbx_data, PF_GET_MBX_LEN)
 	),
 
@@ -33,7 +33,7 @@ TRACE_EVENT(hclge_pf_mbx_get,
 		__entry->code = req->msg.code;
 		__entry->subcode = req->msg.subcode;
 		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, &hdev->vport[0].nic.kinfo.netdev->name);
+		__assign_str(devname, hdev->vport[0].nic.kinfo.netdev->name);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_vf_to_pf_cmd));
 	),
@@ -56,7 +56,7 @@ TRACE_EVENT(hclge_pf_mbx_send,
 		__field(u8, vfid)
 		__field(u16, code)
 		__string(pciname, pci_name(hdev->pdev))
-		__string(devname, &hdev->vport[0].nic.kinfo.netdev->name)
+		__string(devname, hdev->vport[0].nic.kinfo.netdev->name)
 		__array(u32, mbx_data, PF_SEND_MBX_LEN)
 	),
 
@@ -64,7 +64,7 @@ TRACE_EVENT(hclge_pf_mbx_send,
 		__entry->vfid = req->dest_vfid;
 		__entry->code = le16_to_cpu(req->msg.code);
 		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, &hdev->vport[0].nic.kinfo.netdev->name);
+		__assign_str(devname, hdev->vport[0].nic.kinfo.netdev->name);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_pf_to_vf_cmd));
 	),
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
index 5d4895bb57a17..b259e95dd53c2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
@@ -23,7 +23,7 @@ TRACE_EVENT(hclge_vf_mbx_get,
 		__field(u8, vfid)
 		__field(u16, code)
 		__string(pciname, pci_name(hdev->pdev))
-		__string(devname, &hdev->nic.kinfo.netdev->name)
+		__string(devname, hdev->nic.kinfo.netdev->name)
 		__array(u32, mbx_data, VF_GET_MBX_LEN)
 	),
 
@@ -31,7 +31,7 @@ TRACE_EVENT(hclge_vf_mbx_get,
 		__entry->vfid = req->dest_vfid;
 		__entry->code = le16_to_cpu(req->msg.code);
 		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, &hdev->nic.kinfo.netdev->name);
+		__assign_str(devname, hdev->nic.kinfo.netdev->name);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_pf_to_vf_cmd));
 	),
@@ -55,7 +55,7 @@ TRACE_EVENT(hclge_vf_mbx_send,
 		__field(u8, code)
 		__field(u8, subcode)
 		__string(pciname, pci_name(hdev->pdev))
-		__string(devname, &hdev->nic.kinfo.netdev->name)
+		__string(devname, hdev->nic.kinfo.netdev->name)
 		__array(u32, mbx_data, VF_SEND_MBX_LEN)
 	),
 
@@ -64,7 +64,7 @@ TRACE_EVENT(hclge_vf_mbx_send,
 		__entry->code = req->msg.code;
 		__entry->subcode = req->msg.subcode;
 		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, &hdev->nic.kinfo.netdev->name);
+		__assign_str(devname, hdev->nic.kinfo.netdev->name);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_vf_to_pf_cmd));
 	),
-- 
2.43.0



