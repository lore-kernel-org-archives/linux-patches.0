Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CA82EBB8D;
	Tue, 21 Jul 2026 20:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666054; cv=none; b=b5ea5IGNO5GSTroiCH8SzZgKSMCewLUksie1TPSIGJBSA+h+STCuQn66FbcBhExbKpBePctq5nDKlzKWuG8lMIkEuQ+R9+Rt2TJDuiMqVw0ujCEar1/9RuUBxYi+9/v+k8WGsCgSlkIGMhrNbIPYRoDiAFMok7tEmISzU6+AjvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666054; c=relaxed/simple;
	bh=E2E4HVE3tcDFiciIi+bm01MBMW1Y0ipxWEWheX9eHRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MzOYnBXIeoCoUtS5HOAuyqpRZOOXMirHYoUQ9wrYQPWo8rI8iXUuMLJpEuqWWQD+MDJ3GeDnluYu+34D31tmg8252isg/jWL03qtmQr3YW01AfI4aX1KEv3TVPB2xo0ypWakDYTLTCgTJWgLp4InHSSE+wvz9chZ/LhcaMRrnoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz+ZU7RH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz+ZU7RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1041F000E9;
	Tue, 21 Jul 2026 20:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666053;
	bh=Nzws69jtfslamn97ptAz4ZhfN5fCjU0j477xcLsp4oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pz+ZU7RHQo6tLEiJn1WyswVESGb71bL8oIADvClemW5eFFk2t5HcfkI54cLouRDey
	 AGlY8tOg/QPQxPlMEhQeTmgQ75J0RzZmMMjVioPYbHJxttfl4ivr4S3HMJGXTDSQTG
	 n1Rz1Ub44pb/fxVJo3gZgXSWlQuCJOfPr/602yl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0536/1266] vduse: Requeue failed read to send_list head
Date: Tue, 21 Jul 2026 17:16:13 +0200
Message-ID: <20260721152453.857843301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

[ Upstream commit 373ec43ded742b2f3aecf14731ffe1a57f438f38 ]

When copy_to_iter() fails in vduse_dev_read_iter(), put the message back
at the head of send_list to preserve FIFO ordering and retry the oldest
pending request first.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Reported-by: Michael S. Tsirkin <mst@redhat.com>
Suggested-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260226115550.1814-2-zhangtianci.1997@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 96edccd80663e1..60a63757fcbb58 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -193,6 +193,12 @@ static void vduse_enqueue_msg(struct list_head *head,
 	list_add_tail(&msg->list, head);
 }
 
+static void vduse_enqueue_msg_head(struct list_head *head,
+				   struct vduse_dev_msg *msg)
+{
+	list_add(&msg->list, head);
+}
+
 static void vduse_dev_broken(struct vduse_dev *dev)
 {
 	struct vduse_dev_msg *msg, *tmp;
@@ -353,7 +359,7 @@ static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	spin_lock(&dev->msg_lock);
 	if (ret != size) {
 		ret = -EFAULT;
-		vduse_enqueue_msg(&dev->send_list, msg);
+		vduse_enqueue_msg_head(&dev->send_list, msg);
 		goto unlock;
 	}
 	vduse_enqueue_msg(&dev->recv_list, msg);
-- 
2.53.0



