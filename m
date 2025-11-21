Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404D434C990;
	Fri, 21 Nov 2025 13:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732935; cv=none; b=KwP/G0wCClkWHH28xttdzpH7GwYsAzDaMbbqDvxr9csX6rBeQrSgfdwwrU0U4o8oYNnnWLLmiocYwA/kp7BWPxBPBzhmSsvKEsOny6O92BeMlr6rf7OOU4/7n98AQTF0v2akyrLUAJe+rrMX+YlL/UOtdhFoRhjrn+fTqOiN2+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732935; c=relaxed/simple;
	bh=GLFhhwoQ3c6L1ge/k+suuxfBtWB5MlWg0/sjjB/8V9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM/HADXYTj9KGpH3r+yyNK0Mdxw8IyXGpvdN0bv47h3u3B3XiXnnKhfMbeMkUcwYIwjhi1hJRX5UN52h11uXrmC8WRbyy3xq2Bu3jCQ8lmuL1vtpy7GhRSnoEN5w1PUVVYQ6II5fs/jm66p/0k+AeydFlY7Sa/zRX6jnxAoDSs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Inima+ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Inima+ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10C3C4CEF1;
	Fri, 21 Nov 2025 13:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732935;
	bh=GLFhhwoQ3c6L1ge/k+suuxfBtWB5MlWg0/sjjB/8V9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Inima+ns1B7lw6XoMMs8S04wLbTh57+A5eNMpKufr+YUUGU/3iquEQAbQDdeu816E
	 MJW8zWyrdG2ZvCeEBXoO6MM2yjY6r7wQlHcI6eoN3JxnQ9PAn/5AeTapmm7j4kBsJQ
	 sPxW7wRReEs3z2bK7lbkAFFNjKCBP/B7VURYNw8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Sinyuk <konstantin.sinyuk@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/529] accel/habanalabs/gaudi2: read preboot status after recovering from dirty state
Date: Fri, 21 Nov 2025 14:09:36 +0100
Message-ID: <20251121130240.886306321@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Sinyuk <konstantin.sinyuk@intel.com>

[ Upstream commit a0d866bab184161ba155b352650083bf6695e50e ]

Dirty state can occur when the host VM undergoes a reset while the
device does not. In such a case, the driver must reset the device before
it can be used again. As part of this reset, the device capabilities
are zeroed. Therefore, the driver must read the Preboot status again to
learn the Preboot state, capabilities, and security configuration.

Signed-off-by: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/gaudi2/gaudi2.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2.c b/drivers/accel/habanalabs/gaudi2/gaudi2.c
index 31c74ca70a2e5..01df5435d92c4 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2.c
@@ -2985,7 +2985,6 @@ static int gaudi2_early_init(struct hl_device *hdev)
 	rc = hl_fw_read_preboot_status(hdev);
 	if (rc) {
 		if (hdev->reset_on_preboot_fail)
-			/* we are already on failure flow, so don't check if hw_fini fails. */
 			hdev->asic_funcs->hw_fini(hdev, true, false);
 		goto pci_fini;
 	}
@@ -2997,6 +2996,13 @@ static int gaudi2_early_init(struct hl_device *hdev)
 			dev_err(hdev->dev, "failed to reset HW in dirty state (%d)\n", rc);
 			goto pci_fini;
 		}
+
+		rc = hl_fw_read_preboot_status(hdev);
+		if (rc) {
+			if (hdev->reset_on_preboot_fail)
+				hdev->asic_funcs->hw_fini(hdev, true, false);
+			goto pci_fini;
+		}
 	}
 
 	return 0;
-- 
2.51.0



