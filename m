Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA58B3F7ABB;
	Wed, 20 May 2026 17:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297176; cv=none; b=aB9C6iIAJuxY9li8mjFFmWfXcU3c05TOT1aLroojaDvrX3+qINs6E1L5VvxNkjQyEPDoMb/VE4mzCZzjqpShwRihKbYzOh3rZkc5sY3/kUvCc6qh1Zl+dc0HMRP/HPQYWIaI7NqEqeuo6Cj+Fd1tAe0m/fuBzb61rWwtTupAovY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297176; c=relaxed/simple;
	bh=TRKD74sZvSJyahU+zZ2Pw7bVADN34P8wVYQ3EpbVENY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MLDA1XpX3hHqipzI5aaQfLCaL+bXtfgZqnvG1UWQNnafna+R7iNCHWgn+AHWoCnmuDrY5JSrW5HhV/Er6HhjuNo8qqioRqcvKT+wqFp3jCO2xzuURKAXDrtFgAdu/8mrYIZyofZMiRQBN5lpnsbRploB4GGqQkFX/df7fPhr5b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2MAfrN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2MAfrN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF321F000E9;
	Wed, 20 May 2026 17:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297175;
	bh=clnC9/cbzYVY85JCkkYt1RO+nMsaIA1E+z9NSzWi07A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2MAfrN2whpDu3+6YHV6PrhySkIpNCn8NebRRGwSkUQBWJZ+NUu1izx4b8PfbdiFf
	 tTODiwzDTnbg+5jdRIFYmxGBnJC2cLxz0uI2VkEziMTekqYGwIsjyz5xLPECd3hw8W
	 UslsWyGYQUw6zrRhcyjFzGYsDkk+qSQiyg64Sjtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.0 1078/1146] platform/x86: intel: Move debugfs register before creating devices
Date: Wed, 20 May 2026 18:22:08 +0200
Message-ID: <20260520162212.632373878@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


