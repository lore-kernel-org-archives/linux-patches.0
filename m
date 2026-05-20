Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC31A4F5E0;
	Wed, 20 May 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299843; cv=none; b=UsAPH/Ml44ez9d+wKIKlTVYeIjnDGZ3cRUO1ljvPFw2t7//jwqYV+51Dt/jIdZSgSRsZxMb6ZtNnedfBkiGwMf03luOg2D7aE5pMNXb9XuGgTw/sbzAZ45USI2x81GJvl1N9P1e9hJ/q9bdGtAMhtphiSoLLcwGrBhsc7q7ByU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299843; c=relaxed/simple;
	bh=cBxETxeNmIaith0p66lxEsIPu4ieKTRrdFEATUH42jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D25oSnmJOzXG2vN9mj6s1acxRdR4l+TXH7WPZhmzlJEwfZ4IO5oj2Ta+WcXYqUaMmXIu98LRmJ1hLoVSyLc57CYGwPNtOk8DmT4L8/o54CzuGt8v4C0qjgKzik0oA/pZQyur0PQdeqZDqgfwbxlxiR7+hQrjlOjgmyxpwAwIlPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSdzHsOg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSdzHsOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD7C1F000E9;
	Wed, 20 May 2026 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299841;
	bh=PFYg6fiTJiV6o3VOt0NJhuo7BdtKziosddAJ0G2rd3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSdzHsOgzbciLbZBw/qJ/6g0SDAxL70+zpcFr9PgkE2h17xnj9CzFQsvnTZnY1tRi
	 Sq69+HVnA7yHAUeUW0YhmNOWDBDrnS+KzgOhiMuJA3BJ5wvvU8E+kRfbdpVZVlFM+5
	 ph4bWviLnharPPg9yKaC/3F1i17frBRPJNkuHzO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 907/957] platform/x86: intel: Move debugfs register before creating devices
Date: Wed, 20 May 2026 18:23:10 +0200
Message-ID: <20260520162154.246854389@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit ad3bff944c0f4f2e913298a9664391af32f87491 upstream.

It is possible that the driver handling device is enumerated before
registering debugfs. If the driver wants to access debugfs by calling
tpmi_get_debugfs_dir(), this will return error in this case.

Hence register debugfs before creating devices.

Fixes: 811f67c51636 ("platform/x86/intel/tpmi: Add new auxiliary driver for performance limits")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Stable@vger.kernel.org
Link: https://patch.msgid.link/20260430151103.1549733-2-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vsec_tpmi.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/intel/vsec_tpmi.c
+++ b/drivers/platform/x86/intel/vsec_tpmi.c
@@ -813,10 +813,6 @@ static int intel_vsec_tpmi_init(struct a
 
 	auxiliary_set_drvdata(auxdev, tpmi_info);
 
-	ret = tpmi_create_devices(tpmi_info);
-	if (ret)
-		return ret;
-
 	/*
 	 * Allow debugfs when security policy allows. Everything this debugfs
 	 * interface provides, can also be done via /dev/mem access. If
@@ -826,6 +822,12 @@ static int intel_vsec_tpmi_init(struct a
 	if (!security_locked_down(LOCKDOWN_DEV_MEM) && capable(CAP_SYS_RAWIO))
 		tpmi_dbgfs_register(tpmi_info);
 
+	ret = tpmi_create_devices(tpmi_info);
+	if (ret) {
+		debugfs_remove_recursive(tpmi_info->dbgfs_dir);
+		return ret;
+	}
+
 	return 0;
 }
 


