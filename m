Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87682590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67327C433D2;
	Sun, 22 Jan 2023 15:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400587;
	bh=FPLbrvIr0sJlCYZ/5az/WTaLEeHg/wZDDnYcNICvEGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izAJE7DS2bfXSj0q+kS3kX6Qy/cHa63tJqVXuDf1Xfys/H0Avyy01I4SU+xMRNKj9
	 V+YiotBlWT2dCkbLW3uIgrplXOrnztaHeA+WEEREl8IMpI3FgdjhViFBRvvOg0Y0Vi
	 ghw+o0F4Cwju9PPDadjzebCz2CAZqR4sAxs3d4Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/117] tools/virtio: initialize spinlocks in vring_test.c
Date: Sun, 22 Jan 2023 16:03:14 +0100
Message-Id: <20230122150232.921690825@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Cañuelo <ricardo.canuelo@collabora.com>

[ Upstream commit c262f75cb6bb5a63828e72ce3b8fe808e5029479 ]

The virtio_device vqs_list spinlocks must be initialized before use to
prevent functions that manipulate the device virtualqueues, such as
vring_new_virtqueue(), from blocking indefinitely.

Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Message-Id: <20221012062949.1526176-1-ricardo.canuelo@collabora.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/vringh_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index fa87b58bd5fa..98ff808d6f0c 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -308,6 +308,7 @@ static int parallel_test(u64 features,
 
 		gvdev.vdev.features = features;
 		INIT_LIST_HEAD(&gvdev.vdev.vqs);
+		spin_lock_init(&gvdev.vdev.vqs_list_lock);
 		gvdev.to_host_fd = to_host[1];
 		gvdev.notifies = 0;
 
@@ -455,6 +456,7 @@ int main(int argc, char *argv[])
 	getrange = getrange_iov;
 	vdev.features = 0;
 	INIT_LIST_HEAD(&vdev.vqs);
+	spin_lock_init(&vdev.vqs_list_lock);
 
 	while (argv[1]) {
 		if (strcmp(argv[1], "--indirect") == 0)
-- 
2.35.1



