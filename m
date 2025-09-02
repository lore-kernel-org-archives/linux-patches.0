Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCBA30FF01;
	Tue,  2 Sep 2025 13:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819835; cv=none; b=f2UJzoJOaPL3ZMoBtMdW0XJ3AjGDNFI+7bkDlhthrHQcCH6XEZRUcK1voDuJi6WvMn0f97ShZKYRrLDXL9y9qGQm4MdEOjDAPsEtokJVCc4tYYH+2m2boSwrAhhNU8d3JcFty6lurjpoRY79+cydYnGHbR73OqkCEXMA5Z8vF3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819835; c=relaxed/simple;
	bh=/pBT0uhmxSxgRrH0p4fKz4ndokTrIKF4i2ErwqIKJVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SeC+1HnKu8OMf496HpVjYW/M+08PFfFpbiBZ4s1Ty5eAnFAZLF3zgD65qccIs46ymDXx4ZRtfF0bSoyZgcUQKW4FjpvUUhjozi9CS3ENPNagGktKFnSMo75wumna2TONIUqPmK9MuniOGjgd9JNVFnXkWiTQHvui6gx245aXxEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2u6pd83W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2u6pd83W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13933C4CEED;
	Tue,  2 Sep 2025 13:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819834;
	bh=/pBT0uhmxSxgRrH0p4fKz4ndokTrIKF4i2ErwqIKJVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2u6pd83WUCkpYHVCy2LCdDD0ruNuEYZBvYyY9kamr1QPCAlMNrvVpVd3Wb/Oz0nSb
	 P8YWIUQwtIpwxUOCE2pjF9YPnn373uTRUogzfoS7gYCzEfCaGQb6RljXXgzgp8HfN3
	 zdlWNccn52NKXMQDDr8Y9v99wgd5jxWwAQxRJJiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 11/95] vhost: Fix ioctl # for VHOST_[GS]ET_FORK_FROM_OWNER
Date: Tue,  2 Sep 2025 15:19:47 +0200
Message-ID: <20250902131940.048257046@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 24fc631539cc78225f5c61f99c7666fcff48024d ]

The VHOST_[GS]ET_FEATURES_ARRAY ioctl already took 0x83 and it would
result in a build error when the vhost uapi header is used for perf tool
build like below.

  In file included from trace/beauty/ioctl.c:93:
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c: In function ‘ioctl__scnprintf_vhost_virtio_cmd’:
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:18: error: initialized field overwritten [-Werror=override-init]
     36 |         [0x83] = "SET_FORK_FROM_OWNER",
        |                  ^~~~~~~~~~~~~~~~~~~~~
  tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:18: note: (near initialization for ‘vhost_virtio_ioctl_cmds[131]’)

Fixes: 7d9896e9f6d02d8a ("vhost: Reintroduce kthread API and add mode selection")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Message-Id: <20250819063958.833770-1-namhyung@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/vhost.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 1c7e7035fc49d..96b178f1bd5ca 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -254,7 +254,7 @@
  * When fork_owner is set to VHOST_FORK_OWNER_KTHREAD:
  *   - Vhost will create vhost workers as kernel threads.
  */
-#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x83, __u8)
+#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x84, __u8)
 
 /**
  * VHOST_GET_FORK_OWNER - Get the current fork_owner flag for the vhost device.
@@ -262,6 +262,6 @@
  *
  * @return: An 8-bit value indicating the current thread mode.
  */
-#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x84, __u8)
+#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x85, __u8)
 
 #endif
-- 
2.50.1



