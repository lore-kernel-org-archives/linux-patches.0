Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BEB18FC67;
	Tue, 10 Sep 2024 10:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963044; cv=none; b=nOCnoHlPu5tk8B04e8aJNJMXhZpoz6h49s8QO22gs4ZpD/3vlInYum0joeq7i0pJ6KbBweK5td39GCyNmzaUcH+ZPXOAiqP9euKgDpDbnAIuHyJptCxzEw/qSIO5rmmLGl0tZdNYABSUojnlaxw23R0Kdiiwai4GyPYksJ1T304=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963044; c=relaxed/simple;
	bh=StKbsjty1QVzwDYRbn/6f1cNZWseJ9pMEFL3VnHpk8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/GWygCMI891FPz0AV6Fqp2x+W24Q71pUFlyJTjToebk+WMAj78p9V+NOi8PZkpywtlGNQR8txopJwL6X5GCgikGvQLLyLJV6qENkKMyKudpwq/lFSkes5CFHzrfbS7B1E85bRE/iTBqoCcCOqWBc5wpEB6wpMsmd3S6odg900I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tK9FeY1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tK9FeY1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D9BC4CEC3;
	Tue, 10 Sep 2024 10:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963044;
	bh=StKbsjty1QVzwDYRbn/6f1cNZWseJ9pMEFL3VnHpk8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tK9FeY1NI+vunrNgjGPl+igZopHEdlFLdC5XTyEErWPS1ZrrH0BO7Hwzt8ev5N4CE
	 35xG04Fr9fS/SqGPE85mZoGWpVt/0Xiqt1GABUjU/w4pbQfoaJnDq0APfOEbVYZp0J
	 ++WtsHxQN0ap18NMzcqRY+srvsIGT4K+6EHilJc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/192] kselftests: dmabuf-heaps: Ensure the driver name is null-terminated
Date: Tue, 10 Sep 2024 11:32:21 +0200
Message-ID: <20240910092602.842525806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit 291e4baf70019f17a81b7b47aeb186b27d222159 ]

Even if a vgem device is configured in, we will skip the import_vgem_fd()
test almost every time.

  TAP version 13
  1..11
  # Testing heap: system
  # =======================================
  # Testing allocation and importing:
  ok 1 # SKIP Could not open vgem -1

The problem is that we use the DRM_IOCTL_VERSION ioctl to query the driver
version information but leave the name field a non-null-terminated string.
Terminate it properly to actually test against the vgem device.

While at it, let's check the length of the driver name is exactly 4 bytes
and return early otherwise (in case there is a name like "vgemfoo" that
gets converted to "vgem\0" unexpectedly).

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20240729024604.2046-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
index 890a8236a8ba..2809f9a25c43 100644
--- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
+++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
@@ -28,9 +28,11 @@ static int check_vgem(int fd)
 	version.name = name;
 
 	ret = ioctl(fd, DRM_IOCTL_VERSION, &version);
-	if (ret)
+	if (ret || version.name_len != 4)
 		return 0;
 
+	name[4] = '\0';
+
 	return !strcmp(name, "vgem");
 }
 
-- 
2.43.0



