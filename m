Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A972E8E10;
	Tue, 17 Jun 2025 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179014; cv=none; b=PwWE+yR9YqBF41ZD1jyioGVsktiFL13TIldAxdgCCaOvKsHPvwb4K4jz3sBurfKhNN+SCeGstit8cx19DvRm9G9Aydqzk/Qu+2QmPKpajhjVFpZwrKMqbSh5eT4oV0TrahoisVc1KpZ1Q24qGYOymFVjjFzsOtjdFuW4L8j6u60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179014; c=relaxed/simple;
	bh=Rcj9EEZqkNB/aPUrca5lJ3wIWKQKHSs+TaXgikqA4aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqssLnB2fvEYLZ9jeca663Zs3qsx+U5yGNuJNq98svAs4hSqtqwykjwYcEzhBEoMtcm4l805etiZ+i261ivCpTtbve3TFXNS7BxmKyEqu1d2T4Q4iWoSpMAV9SfgmKNxXGaG+hC/JtOVcyYWOS2gNsaL5oWpjQw+lM4tZVfL3/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMsIrwtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMsIrwtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A740DC4CEE3;
	Tue, 17 Jun 2025 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179014;
	bh=Rcj9EEZqkNB/aPUrca5lJ3wIWKQKHSs+TaXgikqA4aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMsIrwtEkJ/RLylKKtpgqe38Cd+Sne6PdnfuLZQSnW9Gc407ITjPuovykWzji5uhe
	 OMgWgEjnAnEbo7w0fnr4Yol9/yaTxfc3yzYutIcPUHOERmmETuew8P9yDimwljiJ9z
	 gNLwobz0WXHE6DFyCZLowUtQqTX1DdSzWvu1NrrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 622/780] selftests: drv-net: tso: make bkg() wait for socat to quit
Date: Tue, 17 Jun 2025 17:25:30 +0200
Message-ID: <20250617152516.806730985@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e6854be4d80ea266a7be64a65a0322bcdfa72807 ]

Commit 846742f7e32f ("selftests: drv-net: add a warning for
bkg + shell + terminate") added a warning for bkg() used
with terminate=True. The tso test was missed as we didn't
have it running anywhere in NIPA. Add exit_wait=True, to avoid:

  # Warning: combining shell and terminate is risky!
  #          SIGTERM may not reach the child on zsh/ksh!

getting printed twice for every variant.

Fixes: 0d0f4174f6c8 ("selftests: drv-net: add a simple TSO test")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250604012055.891431-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/tso.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/tso.py b/tools/testing/selftests/drivers/net/hw/tso.py
index eec647e7ec19c..3370827409aa0 100755
--- a/tools/testing/selftests/drivers/net/hw/tso.py
+++ b/tools/testing/selftests/drivers/net/hw/tso.py
@@ -39,7 +39,7 @@ def run_one_stream(cfg, ipver, remote_v4, remote_v6, should_lso):
     port = rand_port()
     listen_cmd = f"socat -{ipver} -t 2 -u TCP-LISTEN:{port},reuseport /dev/null,ignoreeof"
 
-    with bkg(listen_cmd, host=cfg.remote) as nc:
+    with bkg(listen_cmd, host=cfg.remote, exit_wait=True) as nc:
         wait_port_listen(port, host=cfg.remote)
 
         if ipver == "4":
-- 
2.39.5



