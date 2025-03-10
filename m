Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65B522D7A6;
	Mon, 10 Mar 2025 17:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629553; cv=none; b=DhLzBBVbI8JBlbPj7pjKmxYaBV9pQDI/dLo00m0BxIwJkUKZSdSKHyQZOqabKEPPhZtMTZsuk627TB7H7acJ6dMNpQxyh22Ly1a2ZrQSQcm6kfNSM/NFTnlABz4ZhcrNtxITaRLPTQ3ZtxNHak3hoLBfqZ/zNBpTgbUZ/A4tEB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629553; c=relaxed/simple;
	bh=wwPeZA6I2zdDQZn/kLb0OJHFtgW5kLb3U8B/y09mV5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lUNCvUuIWWqT9Iyf1quzq1yxJF+KtWi5HpJVE/cEpsMlwSuSQIfv9lNpM2TLSKguOwMLTFIjng1KkzvoIGxpruG72Y2g1+J1M4YtYR4pHeJEhFvE6R91RcqI29YY3L8TsbQwprmkLmFVhyFjgpLk3THaRIBlICccZTTIeYNhRSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UokVtJgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UokVtJgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C35AC4CEE5;
	Mon, 10 Mar 2025 17:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629553;
	bh=wwPeZA6I2zdDQZn/kLb0OJHFtgW5kLb3U8B/y09mV5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UokVtJgLV/o69ZI13ctsYgqkj0Htjg2pm8ke0Ituwbrm1+/YMRcUBNPaVPmm9FyJJ
	 /iplmV1HAweLxkkwzgGyGE0+9TntgWvzS6lR0ZxXVsNk0e5VSY4e1XYDM4Z0SxJj5o
	 di+t84np5XMulxGAclqDesxknwbFri0DWmAkTmNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.15 317/620] vfio/platform: check the bounds of read/write syscalls
Date: Mon, 10 Mar 2025 18:02:43 +0100
Message-ID: <20250310170558.128038258@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit ce9ff21ea89d191e477a02ad7eabf4f996b80a69 upstream.

count and offset are passed from user space and not checked, only
offset is capped to 40 bits, which can be used to read/write out of
bounds of the device.

Fixes: 6e3f26456009 (“vfio/platform: read and write support for the device fd”)
Cc: stable@vger.kernel.org
Reported-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/platform/vfio_platform_common.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -393,6 +393,11 @@ static ssize_t vfio_platform_read_mmio(s
 
 	count = min_t(size_t, count, reg->size - off);
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -473,6 +478,11 @@ static ssize_t vfio_platform_write_mmio(
 
 	if (off >= reg->size)
 		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
+	if (off >= reg->size)
+		return -EINVAL;
 
 	count = min_t(size_t, count, reg->size - off);
 


