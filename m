Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590372;
	b=Q9hq6c6N7ODSZvV5BYG4TXMSo82aLkwYHhm9pBRjrazB0h6fSU2nwBFuIdBU3CCZD5ls
	 0BDk2izLtSG1At7o/ylD0gyYd8HkUwjl5G3RI+GEFuijIUeedxleDDPV4b9INayFv3brD
	 6fCzgaaw0ZT4bgE2OfPm0qAjpjtiTGjiDaCzG0mUSSJ0HM/+zIz4EAVBUlMby2oNKzLDM
	 T8iQWtFxgjD6VI1TsdeBDLN52Ej02XytqDmmYBpafqxULG81oNljZ06yRugbxcxiwYnH3
	 7yLBvG8DwzxRUQHc3uhRpwUr9ybvsECsr7Dmy8IrPWrNJVkDg5hzb0VUNnC+ctSX6pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u+x0gGEBfv2f/QNyFQeuMNAzRVzDxFoc5s+iLiDwoyk=;
	b=OyXI5dpiBJ1MFDDswoZqL/+R5ZLi1XE3t+LrykpDvoeUzwL+PD4M+MLoQc9Jdk7yrHkF
	 kGc12fkJk8L9d5lyX/DfNwb7d3UqpXVU43vEkMStn6o1FHPysRc9rEsdWF+T04/I+j9Vo
	 4mpMZ43WjjGc25fX+4v/kjLqpnsUhCE0ew8zsifPjbvL0WJhHQVkRVuy3QpYrmNzMZcBO
	 4L0xFu8ysX1J+uk5UW6v/0he07r0hjcgqrMaASXqC/IVrPNSAHhVLnZuYRShe+Nyx67R5
	 /ZyO4JV+lLUToTpl2tUUIYjDIOjwEBqky3TlUUQcAIz9mAMRLEEHLcauwwVNnzvarEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTXwsxry;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C4606B340;
	Fri, 13 Nov 2026 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTXwsxry
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9711F000C7;
	Fri, 13 Nov 2026 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590372;
	bh=u+x0gGEBfv2f/QNyFQeuMNAzRVzDxFoc5s+iLiDwoyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTXwsxryI+5TiMRCqfAXUQY9jVlfckxJqaENRaN1dMQy8+gfQOYADWg3aAW3tcXYv
	 bgnskOiylNPBNfdwlrW+iyudDoGZxInlg/LRVDToakIoOkXOy3XjEYf7rljvr1rJMO
	 ydVwUFo1YO4yv13RI0+vBs39wPVSefKT2p9obn3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 6.18 345/686] hwrng: virtio - prevent use-after-free after a failed restore
Date: Fri, 13 Nov 2026 10:47:58 -0500
Message-ID: <20261113153832.617538255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 0f7bf47f5a0cc26320aa4b14f4504d03a07f4b74 ]

remove_common() frees the driver data during freeze, but does not clear
vdev->priv, which points to freed memory. If probe_common() then fails
during restore, a later remove or freeze can dereference the dangling
pointer.

Clear vdev->priv on the probe_common() error cleanup path and before
freeing the driver data in remove_common(). Also reset the device and
return early from remove_common() if vdev->priv is already NULL for a
safe teardown after a failed restore.

Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261016103640.4989-2-blum@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 2933f8cb769e4..fcb60d4deaacd 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -187,6 +187,7 @@ static int probe_common(struct virtio_device *vdev)
 err_find:
 	ida_free(&rng_index_ida, index);
 err_ida:
+	vdev->priv = NULL;
 	kfree(vi);
 	return err;
 }
@@ -195,6 +196,11 @@ static void remove_common(struct virtio_device *vdev)
 {
 	struct virtrng_info *vi = vdev->priv;
 
+	if (!vi) {
+		virtio_reset_device(vdev);
+		return;
+	}
+
 	vi->hwrng_removed = true;
 	vi->data_avail = 0;
 	vi->data_idx = 0;
@@ -204,6 +210,7 @@ static void remove_common(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 	ida_free(&rng_index_ida, vi->index);
+	vdev->priv = NULL;
 	kfree(vi);
 }
 
-- 
2.53.0



