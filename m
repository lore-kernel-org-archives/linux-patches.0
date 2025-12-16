Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92F8343D8F;
	Tue, 16 Dec 2025 12:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888732; cv=none; b=sdF3VOIcP+RezfZQ8Pf9pZsl8Qnbq7IlaKnjhOTduH/ftO9xftel/nDRMmYwOCC1g2N0PQG1KQ6Qty2+xeX88WEDPUCm/GgW6Ls+AhVakOsTrQCjj4qAYo+pW6EP48dNvImr35VKk0SJHOPMelkcr0BHHMT5Twogs2gXiKK2Fgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888732; c=relaxed/simple;
	bh=84cMPjpYZqXR8RAyacawY0rrTMqjEEjICIbM70Sgqkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBuahAkosPYsRIGvypzI6/14fOg643R4q/wCcDg8v9WldLmd7yMDJZqav6q3AH+3cdvVdhE1FXFpcAVwgJkKABJjNS15DO+NURWd8OLiAhAvNjqYwQhNPDKDJullXomgfg5EOPj2xHT4jUBOll6jy8ynwvTdW10I2bKOEY/ze/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nC+4adjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nC+4adjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D523C4CEF1;
	Tue, 16 Dec 2025 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888732;
	bh=84cMPjpYZqXR8RAyacawY0rrTMqjEEjICIbM70Sgqkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nC+4adjNITYB6tHUYpfApkYxJ1ZjC2f8vDCdDlx2sGpjjw9CyLxjl4sKDgQdAzPlu
	 4t/wJeseQOgzMJUgGzN5TifhsW1HU4nmuzgwxJRzmUB2UVKfZfAHX+VeZRlrhHO8cG
	 tddLA6RgvzRHs0MHmQN22TK01Y1K9/5BT8ezCZTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Pengyu Luo <mitltlatltl@gmail.com>
Subject: [PATCH 6.18 605/614] usb: typec: ucsi: fix probe failure in gaokun_ucsi_probe()
Date: Tue, 16 Dec 2025 12:16:12 +0100
Message-ID: <20251216111423.314968202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit 6b120ef99fbcba9e413783561f8cc160719db589 upstream.

The gaokun_ucsi_probe() uses ucsi_create() to allocate a UCSI instance.
The ucsi_create() validates whether ops->poll_cci is defined, and if not,
it directly returns -EINVAL. However, the gaokun_ucsi_ops structure does
not define the poll_cci, causing ucsi_create() always fail with -EINVAL.
This issue can be observed in the kernel log with the following error:

ucsi_huawei_gaokun.ucsi huawei_gaokun_ec.ucsi.0: probe with driver
ucsi_huawei_gaokun.ucsi failed with error -22

Fix the issue by adding the missing poll_cci callback to gaokun_ucsi_ops.

Fixes: 00327d7f2c8c ("usb: typec: ucsi: add Huawei Matebook E Go ucsi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Pengyu Luo <mitltlatltl@gmail.com>
Link: https://patch.msgid.link/4d077d6439d728be68646bb8c8678436a3a0885e.1764065838.git.duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
+++ b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
@@ -196,6 +196,7 @@ static void gaokun_ucsi_connector_status
 const struct ucsi_operations gaokun_ucsi_ops = {
 	.read_version = gaokun_ucsi_read_version,
 	.read_cci = gaokun_ucsi_read_cci,
+	.poll_cci = gaokun_ucsi_read_cci,
 	.read_message_in = gaokun_ucsi_read_message_in,
 	.sync_control = ucsi_sync_control_common,
 	.async_control = gaokun_ucsi_async_control,


