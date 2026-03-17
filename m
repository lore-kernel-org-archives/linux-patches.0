Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87386146A66;
	Tue, 17 Mar 2026 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767791; cv=none; b=XKPD03HZ9chBU4ry7253iqG2DNkl45QThxp/DR+2EPm9cYttEt2ECQKhSrFphGqdYkzM4zfzycWGIOOKjglIIn8OjPoRleIY1uvdBMEl2lRpbqWx+Q1fTaob6ST3Ga3rPRsaH55mpqyDs+1DcQ6zyKCWAlgOublHjVH1bv8/ulQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767791; c=relaxed/simple;
	bh=Tyj/5lrbfoNVIgbvLiMonC0nzxlug6KZ/aF4U4wqkdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmQqI38NVdeKu8lQsDAJyF+Q06XE08aJPTf8RRes6seruBoapQR8sDc2Dn+C0Sp9tYkNDYTE1t6SW6EyhIYyH4dTTmVIsxeOLsf+cHtO70OQ8rtlRTefNmeo1tK6SE+DDwxVTVJSqAs73x5E3ccvRyH7g226FW14e2r8lZnUOTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNvQQtpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNvQQtpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0485C4CEF7;
	Tue, 17 Mar 2026 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767791;
	bh=Tyj/5lrbfoNVIgbvLiMonC0nzxlug6KZ/aF4U4wqkdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNvQQtpULZp9ig+Z5KrXBcpMgqWobUFn9cVxAwS2xIfGMgP5wXKpt31pk4h2SQna2
	 Fj4G9Rd1wTVSIqPj2lLHfeRqxWUOPYy7Go2MlGbCfbQRPTyscraWem1D3KcruayGG1
	 L30BlBHOTirXYMj5z5+H94GnlUr1c3pQYkSUrMtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 158/333] mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()
Date: Tue, 17 Mar 2026 17:33:07 +0100
Message-ID: <20260317163005.220224788@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


