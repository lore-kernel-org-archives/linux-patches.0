Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375337E787;
	Wed, 21 Feb 2024 14:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524437; cv=none; b=A3qKpTxOjLyN0eK2n8BWdUVjy1LLJ6HePwZYVHwPf1Lr9YEjmw04DJ85txneqBI1III/CI0dAwn75/Vc5v3g1I3OvmqoLTBOcY4F1PAAPvW9bUHpjJFp9E4K41VPsIExUFVHTFila0qY9lmIONEmNk+AhXMDDRrJvnhC52EbNN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524437; c=relaxed/simple;
	bh=nWUcs2ZeISJfj/AskPdhOjpJQt6Ppg2kaq+wLFdjOlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFvOPAC5E/kR5IrXC3xKVjgscXsEiMrqmtblnuJwH48UTmJ+fqgOkXjX0SvE0z3zAyssAZSBNxfRi/mjz9sgmc2sTOmJDKQbHK+7Y8sws8co0S1/tRDD947DlY4M67QriZ3ADBLW6hq+cJrBEJpoujwlzG2aYSjV2pog//MKFHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8xGdzt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8xGdzt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A416C433C7;
	Wed, 21 Feb 2024 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524437;
	bh=nWUcs2ZeISJfj/AskPdhOjpJQt6Ppg2kaq+wLFdjOlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8xGdzt2aI8tRw6cC/zxW0yUWmCfhB+/WJx6BW43lv8vyoTOXEredvZxvIgP1DE/G
	 iUF8KK3yDg2LhpWcCzSQX+ZHhhOtlxGirfS0oDX8EmoDv56y491Y2PJesihgqcxosd
	 7Ks4I2diNloQbzrReTn1b/WHgB1dcJVHMZ4prTSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 243/379] bonding: remove print in bond_verify_device_path
Date: Wed, 21 Feb 2024 14:07:02 +0100
Message-ID: <20240221130002.100448835@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit 486058f42a4728053ae69ebbf78e9731d8ce6f8b upstream.

As suggested by Paolo in link[1], if the memory allocation fails, the mm
layer will emit a lot warning comprising the backtrace, so remove the
print.

[1] https://lore.kernel.org/all/20231118081653.1481260-1-shaozhengchao@huawei.com/

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2777,11 +2777,8 @@ struct bond_vlan_tag *bond_verify_device
 
 	if (start_dev == end_dev) {
 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
-		if (!tags) {
-			net_err_ratelimited("%s: %s: Failed to allocate tags\n",
-					    __func__, start_dev->name);
+		if (!tags)
 			return ERR_PTR(-ENOMEM);
-		}
 		tags[level].vlan_proto = VLAN_N_VID;
 		return tags;
 	}


