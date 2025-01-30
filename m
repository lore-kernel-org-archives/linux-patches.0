Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF621B4243;
	Thu, 30 Jan 2025 14:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245737; cv=none; b=ohnF8RRQ+9iGEJ6cMoTaenurxMMkrL+l9IF0HKQDhUl6USzb3EDnIdM6iGMQEDDWXYAkjaTGKx32Wis9501nZB5qUsSgCce75qUP4nSR9KdljUKQSBhtfetbqdtB29Ioj7kViM8xgavacooLjlVWw4EKpcQTRJVP01hnQgDVowU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245737; c=relaxed/simple;
	bh=9zgAwHjrtpQgTHqU+D2XG4eNND46YZgo5p1E3vDLJP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g+nYQiwFlhC/N/ztwJR4vqNsRVrdZUoxSf1peMd/H4VsqYq0+EDYjfu1k+TU9C6QYj5AoD6rYyiKx8NjCvL2Qrkfjiiy/3GlJ6aaVTZ+nShdDsb18B5tdKVgbVU39jkEUsInrLHQ67BrzUAsN6qEEqq/0pBfJxUVUdEQzZGrK3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeNJm5Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeNJm5Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BBAC4CED2;
	Thu, 30 Jan 2025 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245737;
	bh=9zgAwHjrtpQgTHqU+D2XG4eNND46YZgo5p1E3vDLJP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeNJm5HnWGVAepYNQVuIm1f2Q2UrByEeCIVAi95Pu4qgjv9voyotYnjhMwCLo3ptw
	 cSCAe1QhOpzdIUbVal9eDTipta9GuZ1bpgrwrH3HsbDobAXhh82M9j1yzr6tkMX/HQ
	 YdWvGe4W79P5Pr16ARi5Jy8BAgHDMYFpBjDm2Uj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.12 27/40] vfio/platform: check the bounds of read/write syscalls
Date: Thu, 30 Jan 2025 14:59:27 +0100
Message-ID: <20250130133500.792837595@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -388,6 +388,11 @@ static ssize_t vfio_platform_read_mmio(s
 {
 	unsigned int done = 0;
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -467,6 +472,11 @@ static ssize_t vfio_platform_write_mmio(
 {
 	unsigned int done = 0;
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);


