Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFB215820C;
	Tue, 11 Mar 2025 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706997; cv=none; b=bHHlCE2IvvXKjEKLGxgTVQ5mxQBVE2QDMy/A1AO83geZYuXFre1KkuenfqeOvSpVGub3SLIwvUKCFsIKqJgBWW0+/9UbqkZfdBDsTrBUO931qk1z4xyu+NfpmxJ+H+9Aag4PD5MssomZ0lRrnwCVVUOjmsWq5yrwKQVY9N03cT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706997; c=relaxed/simple;
	bh=lH0MFtMsYtpHSV8NkdWUpc0jz+aWFec1s8xYysQ4j3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hEaTXLZ6WYzQcIY40UNfamEOlbHEKTpoXpk+7Q2ISyHnkHedvlAY1b2LKCLE+teRTp1WTJJXtonFa+LN7NlL+eFErvqUuj5xUL87PUXHLE5Nhz7TPJlVaPIcIZ/cqhEh1m4ZwBZTzRaUtewiea8cFuS1vcXKlSjELGw04EKiWsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xH/HNPea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xH/HNPea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C979CC4CEE9;
	Tue, 11 Mar 2025 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706997;
	bh=lH0MFtMsYtpHSV8NkdWUpc0jz+aWFec1s8xYysQ4j3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xH/HNPeabGjdhATzcYKwZsqoZjsDn5F6fJvC6k15mPfytWyn2ViFdlcNgpPix3gVK
	 SVYbhkMerskOEVPKslFW8KUeou+ZDYs9FhT0a9oY67Vfd5eA6DBZ039Zq+XZDQMG8s
	 nr84o999K7khfQVaLos8kQHeaQzUr1d2PxREtVjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.10 212/462] vfio/platform: check the bounds of read/write syscalls
Date: Tue, 11 Mar 2025 15:57:58 +0100
Message-ID: <20250311145806.738255109@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -410,6 +410,11 @@ static ssize_t vfio_platform_read_mmio(s
 
 	count = min_t(size_t, count, reg->size - off);
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -489,6 +494,11 @@ static ssize_t vfio_platform_write_mmio(
 
 	if (off >= reg->size)
 		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
+	if (off >= reg->size)
+		return -EINVAL;
 
 	count = min_t(size_t, count, reg->size - off);
 


