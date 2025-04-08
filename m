Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5D61AAA0F;
	Tue,  8 Apr 2025 12:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113853; cv=none; b=NH8C9MT6S0pj2EDmI+L/QBxa9gwSifaZnXb+Zkf+FqIloqWP32TGg5Te8E5gz7u9DGM9NlOs/pFp1RCKlhHbDsTG7rjKLmrFeBmFbqp77cWdzCfLkigRoqEMfJQ/GFVSto4AtIqza/C3luWRSaREWbT1VMBrFZ7nYfL7PqmE3Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113853; c=relaxed/simple;
	bh=/6equ692udvSl3OrppxMS1O6LM3nEOQoQZGbS7Bd4QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsPYTyOzgXOAcM0wvGY5NilfayQg9RpaBuhqnv6A8ilo0Bp0+leht++rePNxJXVzGWAh8ccdnJKgSxeHJBkA9YZsKIrEAjxrACGx+19AUKFhgYj2jaYIJwwPzEbYaw4h91TUJhlmr/fqoXjwmW6kMIpjz05qlqdcxG6zd2eYV30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGfkfVO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGfkfVO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B701C4CEE5;
	Tue,  8 Apr 2025 12:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113852;
	bh=/6equ692udvSl3OrppxMS1O6LM3nEOQoQZGbS7Bd4QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGfkfVO17wV/NfZWBaJfF4Q6xzZLVMZW8vXUFqhTdhMpmLZ2Wx1lRN7jrGIRIeNMv
	 kQxisCKdRxFDxotnu04nB2IKi9YZY4dk656le366hVvnzVLm1ZVUK44rrbfEkHI0uy
	 DaV8cSrJgYHf9XsvDQ+XtzKIVQF7O+BNASlUI4ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 045/154] qlcnic: fix memory leak issues in qlcnic_sriov_common.c
Date: Tue,  8 Apr 2025 12:49:46 +0200
Message-ID: <20250408104816.719748281@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -455,8 +455,10 @@ static int qlcnic_sriov_set_guest_vlan_m
 
 	num_vlans = sriov->num_allowed_vlans;
 	sriov->allowed_vlans = kcalloc(num_vlans, sizeof(u16), GFP_KERNEL);
-	if (!sriov->allowed_vlans)
+	if (!sriov->allowed_vlans) {
+		qlcnic_sriov_free_vlans(adapter);
 		return -ENOMEM;
+	}
 
 	vlans = (u16 *)&cmd->rsp.arg[3];
 	for (i = 0; i < num_vlans; i++)
@@ -2174,8 +2176,10 @@ int qlcnic_sriov_alloc_vlans(struct qlcn
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


