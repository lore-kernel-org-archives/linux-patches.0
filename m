Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E0F222590;
	Mon, 23 Mar 2026 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275487; cv=none; b=gkzxFayEJp5ktADHACG8WBBzF/PKg4sdXkhJrIX+4BcqRb4XOGbvQd7An/mMZy7rif46bL4Sy/Tmmv7wrNOtY3+06opF6xJVzcBYAvh4+T4iJKIsV+Jyjmxlh7Ycapw0DN46nKz+p1VBZ7SXGpb2lBWTL6ZlGPBiMSHOj2fjjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275487; c=relaxed/simple;
	bh=dePbpKolQMWlBS6SR2D8gaVm3h788Ut73I5JRvaxBI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbnqHx5r+DXUN1GpqFhqqPcZKF3sPTsK8Levmg0osA4Rzmj0YZvzoOdD2igKmC0ddvyxSi+/xLszlIUz2JcgbzrKLgzo7cE6lHdix3PqSJF/0/3L7K33RXxoiyE4IMkc+VAiPBzlBlIQYoogV0+v0n7VlYvIxshoaIJfZriWCxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=godD2V5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="godD2V5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C264C4CEF7;
	Mon, 23 Mar 2026 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275487;
	bh=dePbpKolQMWlBS6SR2D8gaVm3h788Ut73I5JRvaxBI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=godD2V5B7R9LHaO20aCN0MYYP+HJ5axzfvklsemqbVpMvk5WGt5tIQKXA03yYif9k
	 0EjXPf9MtjeJplGYGBKeUaNgWc65OXlIlTOtWyk6+zt2jMyQWHr959Iu+Y2AWawfVn
	 N7Pu3mmhm9SR8FlXg0Or707eiHJTr88AwfW8R8ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 119/460] mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()
Date: Mon, 23 Mar 2026 14:41:55 +0100
Message-ID: <20260323134529.553444965@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


