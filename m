Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C253AC0FA;
	Sat, 30 May 2026 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160374; cv=none; b=CQqkJoU+u0tNtCApycoeZz70SA6/YZeyVQyuJumtR7AMfiQEtfyqog1uhAXm6zdRBq8S/kq/8GKdKMIMGCjBvHlaOmKtFtKQmMu7FyvBg8pRCRdDTdleGbh6ZVXqpCCNTXXc2MdJraHovW7qDklg5Kw6B3DCmurdeSmIurMpwtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160374; c=relaxed/simple;
	bh=UAA+rEuk84FyPRCdxtA9/GlESnkoUjTbyvEyevTK3Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHyGq6AMMzgnwwKzcqtep2wdU1GRF/aSgVkZHjlRBuDr8I+D9gePaBORmy0hK+2sbqayWbf6wwjQ5e9Uplp5GLGcFuNFPy+DkisCpOy+/QKaruJ6NdXipYECBA4exkJ4b/B3tcK8M1lV+6G7Alfw7MTIt+JA/++00u76RHyuHsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6zSGHLL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6zSGHLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B321F00893;
	Sat, 30 May 2026 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160372;
	bh=N7b/YeyD0+3miIOQatF3bXt+NXrWxKzwyzZ+JwRV8EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6zSGHLLugBCJQemB75waaJ0EaLHFDJM0rfeSQrvZfrN9j9gpmKEnpBvs5ZrYkHPl
	 NOaT5m1CuugrxxaCA0EH6SQXj7B7jA+WumYB9P2VA5iEMN/Q0fXcWIAtLNuW+fjVma
	 VndU+tqRKfa5SAOtfaITML68YL/orI1JiH1dIWQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martyn Welch <martyn@welchs.me.uk>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 321/969] staging: vme_user: fix root device leak on init failure
Date: Sat, 30 May 2026 17:57:25 +0200
Message-ID: <20260530160309.266615389@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 32c91e8ee039777d0b95b914633fc6a42607959c upstream.

Make sure to deregister and free the root device in case module
initialisation fails.

Fixes: 658bcdae9c67 ("vme: Adding Fake VME driver")
Cc: stable@vger.kernel.org	# 4.9
Cc: Martyn Welch <martyn@welchs.me.uk>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260424104910.2619349-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vme_user/vme_fake.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/vme_user/vme_fake.c
+++ b/drivers/staging/vme_user/vme_fake.c
@@ -1242,6 +1242,8 @@ err_master:
 err_driver:
 	kfree(fake_bridge);
 err_struct:
+	root_device_unregister(vme_root);
+
 	return retval;
 
 }


