Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E751487EC;
	Thu, 11 Apr 2024 10:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831835; cv=none; b=EuLK4LcRqS0gQHDK0ViTBrKv6gvND6q+laxIHrpPBF9yyZOcdojIXfK1sPpSZvOriy8lXgO0EQG1khjHZeP0qaoeaKwzYZdvWsSvGm5l/neTuwnBZt3et07/4DVNVB/6AJI9agzQO9cMdyqCLBmUJGcHwNnpsH/SQDfGGNuQr6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831835; c=relaxed/simple;
	bh=6VyIgE7HbWACAIWAWQZQj53VAuWwnE+wus+UjkCCOW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQObp98iSrW9pPnwVyDh1u2oazszRVA5AKcvTGTMRgVjD1F+PyDSXaxATJPHxcbFCy0kXEEFWBAIUk9TaErArLNUlqG9M49AFSYvBARO56ekRmHUdZjATiAH9ctLklUeKceAH6W1uvvtNcFBnM+g/nA3tZDUj1lvz0hn/n2+Ypc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JFBi55e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JFBi55e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197D2C433C7;
	Thu, 11 Apr 2024 10:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831835;
	bh=6VyIgE7HbWACAIWAWQZQj53VAuWwnE+wus+UjkCCOW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JFBi55eQGYN0FwaIm32pbupvhZP8zVeLY3MjCHZcZYnDlJUjR3dsHBQl8FVpjmTH
	 cOazB0AGD+qusGSZPjP73dI0AmwGWvGUOMoSXBVJwCHy7e0vljK7nbyCDNmQANT1OV
	 lekZn4aVQpmLgmhPOajwjBQD9fgEDOXChs6M+H2g=
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
Subject: [PATCH 5.10 105/294] net: hns3: tracing: fix hclgevf trace event strings
Date: Thu, 11 Apr 2024 11:54:28 +0200
Message-ID: <20240411095438.833423565@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5b0b71bd61200..e8e67321e9632 100644
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
 		__entry->code = req->msg.code;
 		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, &hdev->vport[0].nic.kinfo.netdev->name);
+		__assign_str(devname, hdev->vport[0].nic.kinfo.netdev->name);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_pf_to_vf_cmd));
 	),
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
index e4bfb6191fef5..a208af567909f 100644
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
 		__entry->code = req->msg.code;
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



