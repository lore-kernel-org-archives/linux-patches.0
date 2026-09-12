Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797AD37EFE5;
	Sat, 12 Sep 2026 19:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243025; cv=none; b=GRzuDkDiEw0P8DpEe+i3im8yD2YE0LvST5zxe+aYDSVgaBiGICZtvJQoGWXXQKZbhBTeKj/yjC6AQ3xbH/H+MEvjTQ3B3VAfbNLW/0fPr6p4sjAJ/FCxMQ+TbU5YSoBt2AmNoslwmQ8M2HksaYL016MCXW3A3YSxlW4tj9X4tt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243025; c=relaxed/simple;
	bh=hNXqZ/XDRXvUitv0ZBuLZofETxmo+3aKl15nPaxViGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbPGtIV0JC0GoW7pPOKyI6qfgH6Qu37DnlGTxpCTA5RNmrAbf5gPxyaixEJ2lDEzCn3u9eKyp2RNBzNtiRCfRFn9N9asMhlK/wP4LkKQoVsy5xwFH3R/fJ6oHWlPaB9kSBfRQDpfYMFV3LDA9x5oKNdEzMp04oVb/CtXv/g+9FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLZStVmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLZStVmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0BC1F000FF;
	Sat, 12 Sep 2026 19:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243024;
	bh=kraZgJUlD28K2dKqAFyR6ng3DZQ0ygntqCe+3UQZR9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLZStVmtPErNlAKRoGa2ISKRS2rPKp5Hqp83kQrH6OwyqTOQpYdF7rPbJhOLRXPBS
	 iZc6zUWk0An53oNYUDRhONYZ0oEysi17sDXtX1HCdVU5r2/bHd93l1hj4JWOawh40x
	 UjqQLyEtKRYCGfEuJufoZpVLQceuVDnjRhpuQqjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Arnaud Pouliquen <arnaud.pouliquen@st.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 603/798] remoteproc: Add new detach() remoteproc operation
Date: Sat, 12 Sep 2026 09:03:51 +0200
Message-ID: <20260912065530.946330590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Poirier <mathieu.poirier@linaro.org>

[ Upstream commit 7f3bd0c019cb813448d867c17c9b9dad205a13eb ]

Add an new detach() operation in order to support scenarios where
the remoteproc core is going away but the remote processor is
kept operating.  This could be the case when the system is
rebooted or when the platform driver is removed.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Link: https://lore.kernel.org/r/20210312162453.1234145-9-mathieu.poirier@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: bb840ea69347 ("remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/remoteproc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 6b38be3a53932..0e4dccbaa2cad 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -362,6 +362,7 @@ enum rsc_handling_status {
  * @start:	power on the device and boot it
  * @stop:	power off the device
  * @attach:	attach to a device that his already powered up
+ * @detach:	detach from a device, leaving it powered up
  * @kick:	kick a virtqueue (virtqueue id given as a parameter)
  * @da_to_va:	optional platform hook to perform address translations
  * @parse_fw:	parse firmware to extract information (e.g. resource table)
@@ -385,6 +386,7 @@ struct rproc_ops {
 	int (*start)(struct rproc *rproc);
 	int (*stop)(struct rproc *rproc);
 	int (*attach)(struct rproc *rproc);
+	int (*detach)(struct rproc *rproc);
 	void (*kick)(struct rproc *rproc, int vqid);
 	void * (*da_to_va)(struct rproc *rproc, u64 da, size_t len);
 	int (*parse_fw)(struct rproc *rproc, const struct firmware *fw);
-- 
2.53.0



