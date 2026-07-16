Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D67C3BED2D;
	Thu, 16 Jul 2026 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209133; cv=none; b=G/rMV4QpdG8KckbGCxx/3jbiXNV5qQPsaF3UdS/IzfcMUiK2byOtk2CZnozOwR6CJRH2+z6TB3xzuAExmPyo2vGA1YL4pTXdDxpDe4JEMr423jMI2F8NxzuJVLlLV883T518/7IZwKBHnht7q3JO0mGCgoKaGzf3EFd776CLJYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209133; c=relaxed/simple;
	bh=taqBw2Fi9dbNWI8l+l5Xe+ANGtT44PWPHaBsxztbw+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/4MzXkJSx7K2nY4LN05Nn/6ULrvLrIdutKS68+uy7paZeGFSrvE3lqItWL97vYxWzbHKxOFkGPbfag7cF7PPSBvAshA4jRTrLfD2XTZrG3OWncx60x3hI61K0h9iYTfhst8CD9lT98jR+b/ZmJgBy2J0m1EyQctVlV2QbSoaGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+ljaa9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+ljaa9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717321F000E9;
	Thu, 16 Jul 2026 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209131;
	bh=E0a7lNrItkySJ7h4QKIFUNp/t8lCLnmmhn5S5HEstjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+ljaa9XrrKV2VBjGj7IX1t/M2fcUxY757k1P7+M0jDWHpg6y8hMBkwPm28R9BwZj
	 KBEah9nbASmEpG5mPy5zp7rMOGGeaUsORZ2IizMzbnOLESaEfS2PHG2NioLSS1bdW6
	 ou1R/0SMvNFiX+KAOBKR0N/y2pQ2aOiS+RBYYWbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 067/518] iio: light: opt3001: fix missing state reset on timeout
Date: Thu, 16 Jul 2026 15:25:35 +0200
Message-ID: <20260716133049.251276765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit c123ca6ee26ad98f70a866ff428b08145c5a24fe upstream.

Currently in the function opt3001_get_processed(), there is a check
that directly returns -ETIMEDOUT if the conversion IRQ times out,
completely bypassing the err label, leaving ok_to_ignore_lock
permanently true, potentially breaking the device's falling threshold
interrupt detection.

Assign -ETIMEDOUT to the return variable and jump to the error label
to ensure ok_to_ignore_lock is properly reset.

Fixes: 26d90b559057 ("iio: light: opt3001: Fixed timeout error when 0 lux")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260525-opt3001-cleanup-v4-0-65b36a174f78%40gmail.com?part=1
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -366,8 +366,10 @@ static int opt3001_get_processed(struct
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
-		if (ret == 0)
-			return -ETIMEDOUT;
+		if (ret == 0) {
+			ret = -ETIMEDOUT;
+			goto err;
+		}
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?


