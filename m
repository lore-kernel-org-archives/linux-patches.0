Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620584;
	b=H2LmKKtbcKVIhfyhbSNq6W6jPb/bDP9lYNzBjmjbAvLZgXx06EhBIYjB254ZrFg6PlrT
	 +Np4/xjg0azWgQQqW8Qy0qcl8mMANf7Ne9Pg0/3CaIrYgSa/xeFw29edfhSmXEiistTAa
	 8ZzSPNnzSE8dyWeET1bYkJp0zTLuOlhFQms3FQHYjRjmDOCEW8RBRLyjkz+ReYZYhJs/m
	 bZQoSg8Xn6MlXDTVopybeuNTAoc1FoXCzn9nIe4J5dQHngKBh2NQAIdSDrv5epBK0Z4Ek
	 0qJuTC7EeVBNzw+tV2xMU3f6ple+M6xwd/tfTZEbHvXlmeUE6MW6invXA+kqUoGHk7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rab6qhmkTP7dkzzGUTopCq95tD9m5Mv/TUuXP6K7uhI=;
	b=e9WfkjFAPSdZYPSHq6MmLlshBsQsNtXr0LbVbR4wNabRwJQPgriJg3uJNAj6U6D3BPnq
	 o9LI7sUAsUhZvoAFVHA+pJ9M951SW9EPjLsv2H+EU8bnLr7n98MRsxnhacsxNAKUEluuB
	 A81w7Sl/KrAMisJGcz6a7vcM8PyIVXF/eBlFc5CJjtI8/AgHkSPUdKIz9tovMULTSH19l
	 HocIsYLNHecnq2Njd8eXwe9W+SsBt3E78sZ3IqV1638l5abPs7lDQa83un02Cai2O3GOK
	 GLMR2rCmXdKtHVy5xpO/9r1RIOSb0IMP3ZiQ/FYHOflvWYvJHI62/RFU5wmPEogRs9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFvkzksb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3459606A32D;
	Wed, 25 Nov 2026 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFvkzksb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013421F000C6;
	Wed, 25 Nov 2026 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620584;
	bh=rab6qhmkTP7dkzzGUTopCq95tD9m5Mv/TUuXP6K7uhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFvkzksb0wMpJInMEF921rjyOQyHaijRCs3Pr85iJuDJUgSDsbTXxQKMOdqb95onW
	 xW7tS65qwwKEpd9QsybBw3FmiPKVISGeBSWQN8QTBxAfXzbHYZQF3q21YG8GyyoBNa
	 B5m1FB7KEnIQMbpo5RuEkON4dbD/7gWytGN0Dq1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Joshua Crofts <crofts@kernel.org>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0965/1005] iio: accel: kxsd9: Fix potential use-after-free on removal
Date: Wed, 25 Nov 2026 15:38:23 +0100
Message-ID: <20261125143844.272853863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

commit fd7334314f63a3a2a4927f209b2ca0e33d111840 upstream.

Unregistering an IIO device with an active triggered buffer detaches its
poll function. Freeing the poll function first can therefore make
iio_device_unregister() access freed memory.

Unregister the device before cleaning up the triggered buffer.

This issue was found by our static analysis tool under development.

Fixes: 0427a106a98a ("iio: accel: kxsd9: Add triggered buffer handling")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Reviewed-by: Joshua Crofts <crofts@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxsd9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -478,8 +478,8 @@ void kxsd9_common_remove(struct device *
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct kxsd9_state *st = iio_priv(indio_dev);
 
-	iio_triggered_buffer_cleanup(indio_dev);
 	iio_device_unregister(indio_dev);
+	iio_triggered_buffer_cleanup(indio_dev);
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);


