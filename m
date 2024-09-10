Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B20218DF8F;
	Tue, 10 Sep 2024 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964511; cv=none; b=mEaYnw2J0LxPPk8VVgP9oNslKo7A2bAr2WsorNFPwUW7U7Y9rkrgQ/8OIv+SlbJudm1Q5ezj0Z23cdhp+gGhou/5UZntYFSFLiJwACs+mxlIR9Y7tzvKMrapYvvyg5emEWr1Jgn5dYyfqjwI5ayWrw/BMijm1jpQmF+DFpzjAts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964511; c=relaxed/simple;
	bh=UBuGAmxdE6ko61bykb+3PCtpEmXSLHIV682uxAr+7Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvUWnH/A2rejairq3PxeyoUCTrrtpK/h7OE9kzXfyVFmpeJ47vRSiDck8zKnQvj4idveb/vzZrnLu8Ivl4I+V/+ynVErMc2glMCijF17y2C7xser550wfX9pzAiKKOMuI7V03Uw7rhRNQgc47nNiIMBiiXqV4Jkh3wg36ES+htI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcCgieGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcCgieGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49D9C4CEC3;
	Tue, 10 Sep 2024 10:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964511;
	bh=UBuGAmxdE6ko61bykb+3PCtpEmXSLHIV682uxAr+7Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcCgieGlzz2y3A21ObpJQhOa6MfkhwEu2KHIfRhCXPHkATeUL3vF4agaeiNW1CRCL
	 IVpaGrN8eULAM39ldZKSxpnl94JjRfo/uRheaQzAyJr45Vtg/7fTH1AUTpfm+d7eo6
	 mu6nooi8YUILy77QIfI3gvfmic7nhSpcYEDSTxUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/269] kselftests: dmabuf-heaps: Ensure the driver name is null-terminated
Date: Tue, 10 Sep 2024 11:32:47 +0200
Message-ID: <20240910092614.570640880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



