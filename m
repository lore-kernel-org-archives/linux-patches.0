Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D862D376;
	Wed,  5 Feb 2025 15:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767626; cv=none; b=BiwdblQL0SbCUOt7GTW9M31C1inNxN4F9ZFUtkFjhY1Lb/z1m8xB4VSw4vgd9Yg31hJhCC5YyaQ7qjJ++blpq+HCkkepmmnftHRM0YyQaFBK4DUUrwS0PuW9BvFOUZhPYdZ+y8ut+e0VScPue7LudvZXoVcjEwsjofN22/eZyZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767626; c=relaxed/simple;
	bh=P3QMvz9x5syHWQjM/dprXPweVJ7yXkm47KvPcW3Q0rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qShAiBlILWQvuWlROVKuCGcFMb7qSQxQBms63bY89XUmYdVqId6KqA73RCYXzFD9dBrOzF73AalnkHRyWX3oM+klYmlekxkNQKEOsDJoJ+Nt3h66BgyAHuzvYi/FuHmzVA9KL6iMP8w55l2r29oUyGRoSUF3TlbI0CEaiMk3vDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaTLZYkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaTLZYkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A32C4CED1;
	Wed,  5 Feb 2025 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767626;
	bh=P3QMvz9x5syHWQjM/dprXPweVJ7yXkm47KvPcW3Q0rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaTLZYkvo2+kZFJEP34qg8bU4btpPvqxqYaKh2vN5MN6DFozR0jrcZWbup2qZTYXg
	 UyEl3yjDv8R8jR3SdbSBZanmtvOJQRacu/OJht2HK3RvbNiWUGSDasqZqgxPSGNcFG
	 8iJvwhwXU+6bzniSPz+N4zfhXIwKFTOq1I4r8hKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manoj Vishwanathan <manojvishy@google.com>,
	David Decotigny <decot@google.com>,
	Brian Vazquez <brianvv@google.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 484/590] idpf: Acquire the lock before accessing the xn->salt
Date: Wed,  5 Feb 2025 14:43:59 +0100
Message-ID: <20250205134513.778400292@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manoj Vishwanathan <manojvishy@google.com>

[ Upstream commit d15fe4edd7decdf14d8ad2b78df100ea23302065 ]

The transaction salt was being accessed before acquiring the
idpf_vc_xn_lock when idpf has to forward the virtchnl reply.

Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Signed-off-by: Manoj Vishwanathan <manojvishy@google.com>
Signed-off-by: David Decotigny <decot@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 7639d520b8063..99bdb95bf2266 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -612,14 +612,15 @@ idpf_vc_xn_forward_reply(struct idpf_adapter *adapter,
 		return -EINVAL;
 	}
 	xn = &adapter->vcxn_mngr->ring[xn_idx];
+	idpf_vc_xn_lock(xn);
 	salt = FIELD_GET(IDPF_VC_XN_SALT_M, msg_info);
 	if (xn->salt != salt) {
 		dev_err_ratelimited(&adapter->pdev->dev, "Transaction salt does not match (%02x != %02x)\n",
 				    xn->salt, salt);
+		idpf_vc_xn_unlock(xn);
 		return -EINVAL;
 	}
 
-	idpf_vc_xn_lock(xn);
 	switch (xn->state) {
 	case IDPF_VC_XN_WAITING:
 		/* success */
-- 
2.39.5



