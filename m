Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBC71170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45B0C433C7;
	Mon, 11 Sep 2023 14:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442568;
	bh=Tq3iQO4P9Mvl7fP6y9CkZo32FRDj4GbjSPQzJHYow7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pfqya+E4suIiy+Eey7fOVe1MP5tRQ4L9nYMTgrPsJYr1RmD/6sqZGB++O8irJl2+M
	 SIYJK9D8eP5XV4Q0NpMuTb3raAxufbEjlm40BGxQ6UHCyNqYg6STJzcW7AypPr6DC4
	 bQeQUrriQbupVWID0ReQi9iQIBokyuY5EAFQK6fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 071/737] virtio-mem: convert most offline_and_remove_memory() errors to -EBUSY
Date: Mon, 11 Sep 2023 15:38:50 +0200
Message-ID: <20230911134652.498190812@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit ddf409851461f515cc32974714b73efe2e012bde ]

Just like we do with alloc_contig_range(), let's convert all unknown
errors to -EBUSY, but WARN so we can look into the issue. For example,
offline_pages() could fail with -EINTR, which would be unexpected in our
case.

Signed-off-by: David Hildenbrand <david@redhat.com>
Message-Id: <20230713145551.2824980-3-david@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mem.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index ed15d2a4bd96b..1a76ba2bc118c 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -741,11 +741,15 @@ static int virtio_mem_offline_and_remove_memory(struct virtio_mem *vm,
 		 * immediately instead of waiting.
 		 */
 		virtio_mem_retry(vm);
-	} else {
-		dev_dbg(&vm->vdev->dev,
-			"offlining and removing memory failed: %d\n", rc);
+		return 0;
 	}
-	return rc;
+	dev_dbg(&vm->vdev->dev, "offlining and removing memory failed: %d\n", rc);
+	/*
+	 * We don't really expect this to fail, because we fake-offlined all
+	 * memory already. But it could fail in corner cases.
+	 */
+	WARN_ON_ONCE(rc != -ENOMEM && rc != -EBUSY);
+	return rc == -ENOMEM ? -ENOMEM : -EBUSY;
 }
 
 /*
-- 
2.40.1



