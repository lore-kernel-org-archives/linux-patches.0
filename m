Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7DB18C024;
	Tue, 10 Sep 2024 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961999; cv=none; b=GdE0l/x8XRw69vHFwuc+R4p0nVRiAfNg3mUKQN7Y7T5zCR6Eiy4sJntujXsoliTCMs4vAw975LLAjirUdU5v50qHKdjH+1qIMd5fK11DSyxJaoyadDKmsLbcoY76XjAd2KZh5lrxuHCU5V8Qh6NlLe4Lhy58d5wCt1r1pKIyhP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961999; c=relaxed/simple;
	bh=Z9nZU2mXJg5yk0y/sfTVG4hbk5+4xnIQyIXl4jLLfjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+1hoK+tbHrH77TDnx0eJ25vZV3w91yLr64l+LXAle01oyEHFJwt2PHLnHXRWegxz3aZkv2gVFEzNw/Gmssc00haLivJfSHiRvBdf9rPmjqDJL9wtSp+A1T6Ekw1GYMxiCKIdngqScsMnaLsC1Sa0kHb8OGAOWatOrQu043aNMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wRNVfpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wRNVfpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050B8C4CEC6;
	Tue, 10 Sep 2024 09:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961999;
	bh=Z9nZU2mXJg5yk0y/sfTVG4hbk5+4xnIQyIXl4jLLfjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wRNVfppLqeQ7brAVrCL2Nzi4RQItdzt6o+NTHzJK7G8zzP2IMg2Kb+y1RTWboLeG
	 w/G/0li4MSMUVrh6/8I0Qjez6BsuokBKT+KODNYj4uyl6ZAwzKN8F6UaBfAro1u0iO
	 EJxjy8YLu5AHBDC6uOxI1Q25N+dH6PpURo9u4Lpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 261/375] kselftests: dmabuf-heaps: Ensure the driver name is null-terminated
Date: Tue, 10 Sep 2024 11:30:58 +0200
Message-ID: <20240910092631.327774295@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5f541522364f..5d0a809dc2df 100644
--- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
+++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
@@ -29,9 +29,11 @@ static int check_vgem(int fd)
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



