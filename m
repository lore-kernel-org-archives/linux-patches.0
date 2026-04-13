Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08E73093B2;
	Mon, 13 Apr 2026 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097469; cv=none; b=cXrz4ZWhmEYUhqo3Xhy7qck1UoaigAUJl3DSgPxiDxClEzXYaSl4+YyCj2XcypektJu1tSAPk378xsX2tF6LaB6agdMQnnfDcBuKLiRnI6pCyPHAJ73K8VB4F0biGGJsUHyzpRdj0PT06H4YnD9aMSGMO+ybGibITmzX0XZvj78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097469; c=relaxed/simple;
	bh=k1A6dXVdmnExaIZZzF5BdrvoXruakdLcrT2cFjTpn/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAILNKwXrEBmZJ1YIZMbOsDMwfttvERPnPD9KBlCKfexZIO4zbg2vLohJqUk9vHecg/u7Qw9np2kgHF9K2lHe9Ro2qjvHpv1RMYGv3H/W4GGvVm/Wgq1QuzGQXit+oOYpg4AxGxFD4zNGBruF4qsUYhNO+7bnsbXAImEQlrhhmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMGr5mQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMGr5mQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756A7C2BCB3;
	Mon, 13 Apr 2026 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097468;
	bh=k1A6dXVdmnExaIZZzF5BdrvoXruakdLcrT2cFjTpn/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMGr5mQQcH8vSWnU5U4pej2+rqDx9ktmV1ujrxblcgVmeVDpYJdW5JrXTWx1kOAPz
	 un0kSh+hyVbRwCJgfzw7JR1jJ7Azy5wfUBvXsetELo0fN6HcooUXb6zAzOf490RwvI
	 z4AjNR2X7yZzFOOmHL8IS8mRcBxUYYwMWgq5Bgn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 148/570] mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()
Date: Mon, 13 Apr 2026 17:54:39 +0200
Message-ID: <20260413155835.995557439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


