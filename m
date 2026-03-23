Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7EF3BF698;
	Mon, 23 Mar 2026 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282612; cv=none; b=MBXyqsGDU0/lWQj109QBCh5BXYXFLu7jblubwz3RcxxaaPSBgSL9PDoJzGN+b1lrHoS20v2xn+WCqTB85IL1Vp5OPVbYFoM1An098QoneuhsCv8qeEFhMjLydgotxU90MZg3OvXkkCMrUhbeyWARv/cXhr0mmkHjrg4JdNVfTrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282612; c=relaxed/simple;
	bh=2suOl2UoOHn8QzZZEOGoYpUB/x+VWmbzrvAXwotj9Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IChJQLiVXaVC0c8/Lt6hnIOXncf0fvdlgmMY4WVfK/uYtgqtVgOgYfDyDeYhZlUIFw5RW3MdUNXkACa0FSXu/r05kMCscVzm3Dk1sgVRm12QdS/yYr4tdVxm66ZPKuIv3zyzrafP8qls9Gf42XBi6CMGF7BSvZlnk8gVDdPThYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGk4d/5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGk4d/5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE595C4CEF7;
	Mon, 23 Mar 2026 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282612;
	bh=2suOl2UoOHn8QzZZEOGoYpUB/x+VWmbzrvAXwotj9Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGk4d/5x+k6LTxjd/8rBonGJd7G5qmlG0Dfh3rHWcqmsei0tIiBNTjG4ls6MisZgb
	 yWizk8VfvbZMv8ZBiYPfAek3MtzfNI1ymXwuBWdtmfFtY+wYGFLqbJAMljvxTQaoDD
	 aplmzqrMr74fvQc5Y92mF/PrWDwVL5dM996O+Kqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 220/481] mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()
Date: Mon, 23 Mar 2026 14:43:22 +0100
Message-ID: <20260323134530.514208440@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit af12e64ae0661546e8b4f5d30d55c5f53a11efe7 upstream.

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In of_get_dml_pipe_index(), it does not release the reference.

Fixes: 9cb15142d0e3 ("mmc: mmci: Add qcom dml support to the driver.")
Signed-off-by: Felix Gu <gu_0233@qq.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci_qcom_dml.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mmci_qcom_dml.c
+++ b/drivers/mmc/host/mmci_qcom_dml.c
@@ -109,6 +109,7 @@ static int of_get_dml_pipe_index(struct
 				       &dma_spec))
 		return -ENODEV;
 
+	of_node_put(dma_spec.np);
 	if (dma_spec.args_count)
 		return dma_spec.args[0];
 


