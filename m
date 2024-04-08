Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546197E772;
	Mon,  8 Apr 2024 13:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582037; cv=none; b=Y3Bzqj2ijvMq9FG/nrYRxuuLj/41+qU4c5e8I8dzd90eFzKY5IbVC8cU8mC2woMkzZT8gGXKNb3YMTEM5Jk2vUiJyPjOcZV0JOOJzaU7IsNRItaWreMFeY//oMRC1D8/j+sZhskvZY035ONnT11WdAXPd4nd5GDGUTVS/dU6rmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582037; c=relaxed/simple;
	bh=v2J71xiz+hiPivYyvZa7MRtATMew/0rG5UlSA6Z8V/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ur0XmfGxcSF/X2PByzuSU64V5qE/r7q6j2IBTDjPgRRFjLE9/jAAfXbNIKQV4RW6qY+qfnd9GiLGAs7aTHWyS0+pqfZKQnCPFGYOgBMkkikA96NQP+XBfBfyGXmOHqICmN/xdWENckLmI+RhGL6sIgxFsT9YFUEa1vngUpf5NH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWdrtV0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWdrtV0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A5DC433C7;
	Mon,  8 Apr 2024 13:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582037;
	bh=v2J71xiz+hiPivYyvZa7MRtATMew/0rG5UlSA6Z8V/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWdrtV0RGxBsX3jEhGystd61hms8K0NESZc0WQxNYw2yQiQyWPlyepDfvzwBZCuRM
	 mNA391ptzPwZ6Re0zNTupw3eWQ+cQHPk+2RDcnQqiUscwpB9FJ9zLfS+FUCKlUAAIp
	 idv77L2XJTDzwA/BiArWN33Not8Ga3F047i9LJHk=
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
Subject: [PATCH 5.15 106/690] net: hns3: tracing: fix hclgevf trace event strings
Date: Mon,  8 Apr 2024 14:49:32 +0200
Message-ID: <20240408125403.340520082@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



