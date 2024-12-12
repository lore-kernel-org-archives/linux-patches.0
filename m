Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F212210CF;
	Thu, 12 Dec 2024 16:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020706; cv=none; b=JIGe83Z9c3Ee6C+3MUVwocNp/XJH/AKTb9Tua1ceUvRw02L3E4DUlO0ncoFjD0LJ5/8mVyxXTfKEZkuQxyo2crigJQD79wGL+eJG4YaJzohbrulLaLnOoE9jdPzp/MnsuOW4AwHpb7JmSlz7i+RwGW03SPqDz7Cu7I/hwolPmNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020706; c=relaxed/simple;
	bh=cW3mELHWN0wvuVhQ378pq5VggEExipWpcJmTb9v7Owc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lz2UPbm0tEulKWVGq9tuxxSeLGfdyZeF3qivHrhAZwsPMIDtyC7m9N1G3Bbsr6txbKZskUiM4wm9pFlQUrNMSWjqpjtqAN1qM+fPg+/MkbstU113AIgTmKEtsub7LMmHmCM1nDVVGvsu7seDnuOM7Gh/uRDoKjjNIvJGpjAN2yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBYIiQwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBYIiQwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64653C4CED3;
	Thu, 12 Dec 2024 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020706;
	bh=cW3mELHWN0wvuVhQ378pq5VggEExipWpcJmTb9v7Owc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBYIiQwVe0TzWnOdDWcIrvo1KBOGmKcJ6dIDElY6IMCqKKdIB5XjYXJNuZXctRnRj
	 TPosmYL+36g7q3V2RAGgVh6s6Ep2w38Kj5MBhkfzccIwit1K8BHOYdRHYDNhuxTcQY
	 /vzRMZyujyUBFX9xpJG3OioM4rj3tNMQBkQa6Wvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 538/772] ixgbevf: stop attempting IPSEC offload on Mailbox API 1.5
Date: Thu, 12 Dec 2024 15:58:03 +0100
Message-ID: <20241212144412.201170697@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit d0725312adf5a803de8f621bd1b12ba7a6464a29 ]

Commit 339f28964147 ("ixgbevf: Add support for new mailbox communication
between PF and VF") added support for v1.5 of the PF to VF mailbox
communication API. This commit mistakenly enabled IPSEC offload for API
v1.5.

No implementation of the v1.5 API has support for IPSEC offload. This
offload is only supported by the Linux PF as mailbox API v1.4. In fact, the
v1.5 API is not implemented in any Linux PF.

Attempting to enable IPSEC offload on a PF which supports v1.5 API will not
work. Only the Linux upstream ixgbe and ixgbevf support IPSEC offload, and
only as part of the v1.4 API.

Fix the ixgbevf Linux driver to stop attempting IPSEC offload when
the mailbox API does not support it.

The existing API design choice makes it difficult to support future API
versions, as other non-Linux hosts do not implement IPSEC offload. If we
add support for v1.5 to the Linux PF, then we lose support for IPSEC
offload.

A full solution likely requires a new mailbox API with a proper negotiation
to check that IPSEC is actually supported by the host.

Fixes: 339f28964147 ("ixgbevf: Add support for new mailbox communication between PF and VF")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbevf/ipsec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index 9984ebc62d787..74c121d7abc90 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -623,7 +623,6 @@ void ixgbevf_init_ipsec_offload(struct ixgbevf_adapter *adapter)
 
 	switch (adapter->hw.api_version) {
 	case ixgbe_mbox_api_14:
-	case ixgbe_mbox_api_15:
 		break;
 	default:
 		return;
-- 
2.43.0



