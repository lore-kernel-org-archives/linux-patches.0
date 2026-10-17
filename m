Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669C13B27C9;
	Sat, 17 Oct 2026 17:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256545; cv=none; b=osbAsA41/9cZzSGLVoavBJDVdtrG4fHOsH9ZZXiCpMG/dkDaVKxkT2Ztz4ZycQhH2sfLZyd8U7dqlUp5wXZd9fkI2QUyQ1NChEowDuPgISIvZBJe32Ffs/m8Zl0EliUZ9HRALnjCBKKvqZhBiF6OTTsvuOz9CLSpaUJ9iFs8Psw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256545; c=relaxed/simple;
	bh=7jQbqK2WYX9v1OQW3AoxaZkGVUe2HzWcgZxPTa/zr54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gj1Dn3GmzE832DmjaWpruSRp0fJT/QLGu6/qj3sj37t0kR4dpXMByjKayW1IW6qjFnZu7yZpA9Mp1pBWy+FpHv7TmW4e06Wm9nIcbFlZc8+LFEPtNMrURv6NVrqu/6P1XRv1j0xQFErf67wSfyrD/+OUiZwYUt7RjzgsfxcTEpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW2iBgR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW2iBgR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813311F000C5;
	Sat, 17 Oct 2026 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256544;
	bh=hMYAx/fUpFkV2nxNvvnDU/ao0FvHc7mMUohQaGRNSvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LW2iBgR8P0XZoleOk+rv2xLSsmpcYo4bBKEuZVUHpQDLLiMLutueMdo4K7RGw3UnS
	 HK7Q/DO6uspcXQtDViafkqvWHvELerHzJwU5r4huJ5zqX/pF7hbBVTFylqoRwCIDxv
	 HjWXk7OoSrgzYF/hGzmyTJx8LfRbGNJhwc1ut2H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 0271/1674] usb: chipidea: tegra: disable runtime PM on resume failure
Date: Sat, 17 Oct 2026 17:42:23 +0200
Message-ID: <20261017160438.075147173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit f1d6f7d25fe88ee49aaad96c8649e090fc3a4b68 upstream.

tegra_usb_probe() enables runtime PM before resuming the device. If
pm_runtime_resume_and_get() fails, probe returns without disabling runtime
PM. The later error paths reach pm_runtime_force_suspend(), but this early
return bypasses that cleanup.

Disable runtime PM before returning the resume error. Do not use the
fail_power_off path: the failed resume did not retain a usage reference,
so its pm_runtime_put_sync_suspend() would be unbalanced.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 8b85e11c1a7a ("usb: chipidea: tegra: Add runtime PM and OPP support")
Cc: stable <stable@kernel.org>
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260913041033.25144-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_tegra.c
+++ b/drivers/usb/chipidea/ci_hdrc_tegra.c
@@ -308,8 +308,10 @@ static int tegra_usb_probe(struct platfo
 
 	pm_runtime_enable(&pdev->dev);
 	err = pm_runtime_resume_and_get(&pdev->dev);
-	if (err)
+	if (err) {
+		pm_runtime_disable(&pdev->dev);
 		return err;
+	}
 
 	if (device_property_present(&pdev->dev, "nvidia,needs-double-reset"))
 		usb->needs_double_reset = true;


