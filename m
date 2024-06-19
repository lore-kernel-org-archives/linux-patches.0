Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27212FB31;
	Wed, 19 Jun 2024 13:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802597; cv=none; b=j8uZDA9kLnc47esdmWrNNKyguKevldPu0eJC7nfByAI/3XdjVjBUHmgw2PpHyC+lveNjkycfAUw+pznLwcI/nWVDNJKWkwFiYmcg/OVHD5ynehFu4k092/zKLpuEM3fGWBzQMnjNsyf5Jqq7/jXjD3u9qhBqE6jqTOmpzaL0j/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802597; c=relaxed/simple;
	bh=ozDu2eVXejd5SDD0eI3Oj6N0wD0nMnAQnyrPnXODm/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOd0PgPjCJQXAIpS423siKJQJjVX4bhq9Z4HBmKjQP3BnONEBWigaLzgiTLnmihbTMO4DBxJe6MEq/4OiS3lHOwGCDLwVF76oTtjrpjIViuVZ+ptucXaVbbsMr2ZsyqxkSt5pmMx0lJILEJkyytF+qdERJdrHEDsC4VkAQ/TlSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLGeL3Ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLGeL3Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAEAC2BBFC;
	Wed, 19 Jun 2024 13:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802597;
	bh=ozDu2eVXejd5SDD0eI3Oj6N0wD0nMnAQnyrPnXODm/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLGeL3PsDteA1RydNXvHcRsDeWLdxp995xvN0SCYo8wk8pAgC4jsMHW9DLXM5voCP
	 F0QOUf3aci49j4+/xgrOhzW5jPxc/fnFZMVONm6ZWfOFZFsZordhlZKyUG/odjLH66
	 tbv5RnlgVigvGVw5yOBR5DkyJvwP9IZ5R46VY6Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 249/267] remoteproc: k3-r5: Jump to error handling labels in start/stop errors
Date: Wed, 19 Jun 2024 14:56:40 +0200
Message-ID: <20240619125615.877003646@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beleswar Padhi <b-padhi@ti.com>

commit 1dc7242f6ee0c99852cb90676d7fe201cf5de422 upstream.

In case of errors during core start operation from sysfs, the driver
directly returns with the -EPERM error code. Fix this to ensure that
mailbox channels are freed on error before returning by jumping to the
'put_mbox' error handling label. Similarly, jump to the 'out' error
handling label to return with required -EPERM error code during the
core stop operation from sysfs.

Fixes: 3c8a9066d584 ("remoteproc: k3-r5: Do not allow core1 to power up before core0 via sysfs")
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Link: https://lore.kernel.org/r/20240506141849.1735679-1-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -580,7 +580,8 @@ static int k3_r5_rproc_start(struct rpro
 		if (core != core0 && core0->rproc->state == RPROC_OFFLINE) {
 			dev_err(dev, "%s: can not start core 1 before core 0\n",
 				__func__);
-			return -EPERM;
+			ret = -EPERM;
+			goto put_mbox;
 		}
 
 		ret = k3_r5_core_run(core);
@@ -648,7 +649,8 @@ static int k3_r5_rproc_stop(struct rproc
 		if (core != core1 && core1->rproc->state != RPROC_OFFLINE) {
 			dev_err(dev, "%s: can not stop core 0 before core 1\n",
 				__func__);
-			return -EPERM;
+			ret = -EPERM;
+			goto out;
 		}
 
 		ret = k3_r5_core_halt(core);


