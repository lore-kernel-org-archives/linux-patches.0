Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F2A266EF3;
	Tue, 25 Mar 2025 12:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905706; cv=none; b=ZBlXbtaLmN9GxtUvqKqQeYEjUU8zWZRNHvY0FuFFcK/CR4MMdlno6MsN55OvzK9mlK1bSkPVSKmJfPXRsO8dL42f9jBKYdeVnTLeFXiXF1nHl3EP4Kj9Vdbt7hiJET/LOLZhrJNRmwqbPfbAwlIpqQuMSCcE6yZXgrSzLtfd2yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905706; c=relaxed/simple;
	bh=XxV1pgqI5+VCskBM3NYfxzKS8yh2fQh1vDUcG7WMKzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6ch7aDJHLlm2+Ym4mqE12RlVgJjmUe3YBCWLEAV4tq+zWF2eh21ssNJL6FFyoQMdfOH7O0/5uRqBoBC+DUz1dN7HN4H2byDsf23VaEy/o9DtFYl7AJsB/8O5nN9o1oFJyg+Svn9z8/2NVyzy7NkvXbSkeneGDhFwoAG1camTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMk6uRPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMk6uRPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3156AC4CEED;
	Tue, 25 Mar 2025 12:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905706;
	bh=XxV1pgqI5+VCskBM3NYfxzKS8yh2fQh1vDUcG7WMKzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMk6uRPPljZCUMS6zCSjdUqP04b3c2mImB9zBBSSgpiZl4YCpjBXGQF5VMq2uuej2
	 OTVvXJ4TUbYLyjvXzsVfCl2tCeTpe3UzT8JPtPiAhDtuSyMyddg+GIOlfyjybivCwO
	 EJdxIhNKIB8T8zP1zXBGPZ2rL2m6b1EcR/8a1Ez0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 120/198] qlcnic: fix memory leak issues in qlcnic_sriov_common.c
Date: Tue, 25 Mar 2025 08:21:22 -0400
Message-ID: <20250325122159.803335499@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d2b9d97e89c79c95f8b517e4fa43fd100f936acc upstream.

Add qlcnic_sriov_free_vlans() in qlcnic_sriov_alloc_vlans() if
any sriov_vlans fails to be allocated.
Add qlcnic_sriov_free_vlans() to free the memory allocated by
qlcnic_sriov_alloc_vlans() if "sriov->allowed_vlans" fails to
be allocated.

Fixes: 91b7282b613d ("qlcnic: Support VLAN id config.")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20250307094952.14874-1-haoxiang_li2024@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -454,8 +454,10 @@ static int qlcnic_sriov_set_guest_vlan_m
 
 	num_vlans = sriov->num_allowed_vlans;
 	sriov->allowed_vlans = kcalloc(num_vlans, sizeof(u16), GFP_KERNEL);
-	if (!sriov->allowed_vlans)
+	if (!sriov->allowed_vlans) {
+		qlcnic_sriov_free_vlans(adapter);
 		return -ENOMEM;
+	}
 
 	vlans = (u16 *)&cmd->rsp.arg[3];
 	for (i = 0; i < num_vlans; i++)
@@ -2167,8 +2169,10 @@ int qlcnic_sriov_alloc_vlans(struct qlcn
 		vf = &sriov->vf_info[i];
 		vf->sriov_vlans = kcalloc(sriov->num_allowed_vlans,
 					  sizeof(*vf->sriov_vlans), GFP_KERNEL);
-		if (!vf->sriov_vlans)
+		if (!vf->sriov_vlans) {
+			qlcnic_sriov_free_vlans(adapter);
 			return -ENOMEM;
+		}
 	}
 
 	return 0;


