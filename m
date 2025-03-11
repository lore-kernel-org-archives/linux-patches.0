Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E5E255E37;
	Tue, 11 Mar 2025 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705764; cv=none; b=denkjKvZ1UDwn4sH8/boYhC38OoHBVyxGXztAWy7CCSYdhT3hhPgBz4pwQVvAA18vA6IrlpjavcCw2h2yricH/03J9c5UKo6e1qXGh/Ng6joF9lgBrtoN2f/iiI/IpnkgTi/dP7phN8AEe1ZlGeTb0ClaBJuwOOo4RfA7rc8SC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705764; c=relaxed/simple;
	bh=uDnRV1TbkKuRzypzHH26Iysd3klGqzK5otNgyOnBLfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyT+tebHwvJLqZs6gzeJTOhBCogz5PvKOajanPiojqJql/JAmAWUnBpC2tSlzz2xaHd8JnotkMPPnZ4pguFLWmCQEv4fF3Ycpjcbx3GpFW5eviW7HcARKFZfgwPYrLcdhKdNDcrBJZVb7a5aruhU6ktu43IuR7GTd3aLNBnxaX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXIHQNRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXIHQNRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBC8C4CEE9;
	Tue, 11 Mar 2025 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705763;
	bh=uDnRV1TbkKuRzypzHH26Iysd3klGqzK5otNgyOnBLfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXIHQNRy6t5QFGL2ZNdWvm6wKxjjOQ2i8xIDk1oQugTdSIoyODtCw6gzP/PavC/tu
	 GmgD7wsIAH04ZIGUnY+yqCs/8iic9Rr0ZrN7OoQ+ubDJcU/lJmA5N+N6bPJC1JUc1Y
	 xTMz8hC2QzaHRDVnRddkXetqr+39Aw6xWwjS2t/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.4 139/328] soc: qcom: socinfo: Avoid out of bounds read of serial number
Date: Tue, 11 Mar 2025 15:58:29 +0100
Message-ID: <20250311145720.427952804@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 22cf4fae6660b6e1a583a41cbf84e3046ca9ccd0 upstream.

On MSM8916 devices, the serial number exposed in sysfs is constant and does
not change across individual devices. It's always:

  db410c:/sys/devices/soc0$ cat serial_number
  2644893864

The firmware used on MSM8916 exposes SOCINFO_VERSION(0, 8), which does not
have support for the serial_num field in the socinfo struct. There is an
existing check to avoid exposing the serial number in that case, but it's
not correct: When checking the item_size returned by SMEM, we need to make
sure the *end* of the serial_num is within bounds, instead of comparing
with the *start* offset. The serial_number currently exposed on MSM8916
devices is just an out of bounds read of whatever comes after the socinfo
struct in SMEM.

Fix this by changing offsetof() to offsetofend(), so that the size of the
field is also taken into account.

Cc: stable@vger.kernel.org
Fixes: efb448d0a3fc ("soc: qcom: Add socinfo driver")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241230-qcom-socinfo-serialno-oob-v1-1-9b7a890da3da@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/socinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -436,7 +436,7 @@ static int qcom_socinfo_probe(struct pla
 	if (!qs->attr.soc_id || !qs->attr.revision)
 		return -ENOMEM;
 
-	if (offsetof(struct socinfo, serial_num) <= item_size) {
+	if (offsetofend(struct socinfo, serial_num) <= item_size) {
 		qs->attr.serial_number = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"%u",
 							le32_to_cpu(info->serial_num));


