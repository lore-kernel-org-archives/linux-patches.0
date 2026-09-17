Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A164F390E;
	Thu, 17 Sep 2026 15:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660193; cv=none; b=VoKKwz57as8dibmNK7bj/fAxEafHPzrSht1TYE3IzW1xpqfhC9k9595ODJUhGmOQlj/MzUVk7/+72ylPk5Ld1N97rOE+p9HYbUVI+UGnh9moqCS1tu2vnA9/fbJUhriZLn7ZM0K88Bb7EyDut9Y+Y7Zddx+fzKOYWR+UL3drtAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660193; c=relaxed/simple;
	bh=GRsX7fNRwcO1XMkJMLycW3CVPXnJ6NgJptY98R+/1yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgZp7zYvITQHPvEyUuASSTyW8q1quhF34Kgp2o70eSAUFhQKhCc9JYTQ4bUy5vQGpsCQXiDzP+lUpSmTqNYhgXq+nzwGTOzcoaD335ZpdUQ+22p475giX/04Aj4no5NhRd2oWGdH2SQH84yiWMgGGduJWD0Aqn5HKKAmlY3LFAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhZ3FcBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhZ3FcBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AB31F000FF;
	Thu, 17 Sep 2026 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660185;
	bh=tQJC9jVPkxcmWhlxQG7S12NDOZW1b9tyliX4G8IR5fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhZ3FcBAUTRzWyPh91X/OmObd7SHjwhUwQh0E0XkT5EZWmAMvzEkVMckuE4k9kbKc
	 vUoLSsl9oiA1k52/pSb/w1mL9j7gxtPYFgI4jyvo7zKvk73u1Y0p7JxrAcuMa3bDAL
	 CdeOwcmmOqEVx4e+LXOrJFNI9p+AhIxaMaNKkNLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 508/733] accel: ethosu: Drop IRQF_SHARED flag
Date: Thu, 17 Sep 2026 16:13:36 +0100
Message-ID: <20260917151404.777484364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

commit 2cbd3691565f7c86c0eaca305f5beb3435b4ba70 upstream.

The IRQF_SHARED flag doesn't work with runtime-pm as the IRQ handler
could run without resuming the device. This could also be fixed with
runtime-pm calls in the IRQ handler, but there is no known need for a
shared IRQ.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260827-ethosu-fixes-v1-2-346f9ea8791c@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_job.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ethosu/ethosu_job.c
+++ b/drivers/accel/ethosu/ethosu_job.c
@@ -325,7 +325,7 @@ int ethosu_job_init(struct ethosu_device
 	ret = devm_request_threaded_irq(dev, edev->irq,
 					ethosu_job_irq_handler,
 					ethosu_job_irq_handler_thread,
-					IRQF_SHARED, KBUILD_MODNAME,
+					0, KBUILD_MODNAME,
 					edev);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");


