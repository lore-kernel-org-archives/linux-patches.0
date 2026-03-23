Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED4323AB9D;
	Mon, 23 Mar 2026 14:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277214; cv=none; b=kW3FiVyAAH8wTI0juK+Ct93uI3BQQxh/3AOn0eevkVySoHrLKhnwWI9L7wikIP5o+Vi8maLLDn7Rb8bDKOGgKJ8/5rAU2UkkxBhlMAWwnxvINySZFskhsoU0C1upn5rs1NV8Cjh65qSsbDhaw3NqMhKjAwvNdZkzw8uxbrr3TV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277214; c=relaxed/simple;
	bh=pYnlgfgrmqspE6eYJFps3cEJE2aN0zNFiNC4f8CpE6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Twa8g5wwsMSTp8rXBZeLIK43/cXAPRGkwXNk5yoNJyMIju/mcrOkOM+mghAG4ttVM1RJ9QCqRcBECS+pQfX0SaSbEDr9CdXw5GvE4vwYa51ajp4q5GHYgog8qvMcpZcMCsbMCAzf3FuVtzUtxwZ0DvACpxOO0JwtsrC6nUxSfVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzBj2Z5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzBj2Z5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B83C4CEF7;
	Mon, 23 Mar 2026 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277213;
	bh=pYnlgfgrmqspE6eYJFps3cEJE2aN0zNFiNC4f8CpE6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzBj2Z5uinqzetvJMBu0Swgkc//iO1sp8SC771+gwygw6FwWZVv0h3OsRAY9vQxbb
	 izZIfMy80DOZii1g+2QjGmziHHqFk1hXjvyZwX5PSYqvvYMgq5qXfp74eR2Id5ZGrp
	 PpW+Zusj6Sdq/IiUJj+W+PnRjdGyobooJRs+MFJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 357/460] drm/amdgpu/mmhub4.1.0: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:45:53 +0100
Message-ID: <20260323134535.326775043@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3cdd405831d8cc50a5eae086403402697bb98a4a upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 04f063d85090f5dd0c671010ce88ee49d9dcc8ed)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
@@ -102,7 +102,8 @@ mmhub_v4_1_0_print_l2_protection_fault_s
 		status);
 	switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
 	case IP_VERSION(4, 1, 0):
-		mmhub_cid = mmhub_client_ids_v4_1_0[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_v4_1_0) ?
+			mmhub_client_ids_v4_1_0[cid][rw] : NULL;
 		break;
 	default:
 		mmhub_cid = NULL;


