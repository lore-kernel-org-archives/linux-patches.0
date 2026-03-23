Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09CD3BB9F8;
	Mon, 23 Mar 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278374; cv=none; b=aHiSbH0RrgISbusxeYTeV5z6ESNmifQBJFqGViv/L50Ws70/5lqAKEG6bOGX/LwC1VfaM+c1BNFUlGwq6F1Hyw0CAVICZOqep3tDS+CDBftzc5WQmOcLgVnB9HJPbVTM/X+lKsPQZFpJroKBC1JVCslASb6xgW7vvYv2Si14iEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278374; c=relaxed/simple;
	bh=I47/3KP1FBWsyIbAJSyIEhjk8dtSW7vza8zE+WiclVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUNLpT7bD/73WyECZMJdTsPZtWs8NV9MUKU0jJD2p4zibejcbB+T94jAvhijebdoxzqrZj2fDq+HB/1xJ51sMNSsJ3s2tVqT49ap4YrsJeQ5zhDNNzrQDbI5GaGRW+qI0a4x2c7j4iSGPoooZlM59cr6FUPnvC1TRM/2U0yUffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhypzANw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhypzANw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151A8C2BCB1;
	Mon, 23 Mar 2026 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278373;
	bh=I47/3KP1FBWsyIbAJSyIEhjk8dtSW7vza8zE+WiclVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhypzANw6jf2uOvu9ahYCA/diRz3SmOqAjqUEuyqjodW/xHqhK8WaVNHhwdAMnd5N
	 z6YFuPd4C9t5ijhgN1W+veoZHgZiS4di+uK0Czjl4SqyGLS/XNbVSBeCq8LLK046RA
	 636N2fzxikSAWmshfEdHnsvjWFyooQihPu2Nsvrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 288/567] mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()
Date: Mon, 23 Mar 2026 14:43:28 +0100
Message-ID: <20260323134540.950773417@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
 


