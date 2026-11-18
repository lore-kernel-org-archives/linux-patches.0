Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036940;
	b=3DGGUyJcB/9D7BYRge+GI0w97Fx1UejlLCX8sL3EZdVQhl0cNYq/r7IQq8M+ph+AFju0
	 ZvcLT75qyquzSJJX2q1iuYOxJYIFectrqe7STFoNDKiF2xl9CS0Rv24hV3x7+wUlNSent
	 WX1kOt36FVk9hnJokgk6++n/k8n76+ulJRgeaFV0lLMDeASAv2/ZGmqHd7q0NLm0uH2jy
	 cP+gA0EW+LOfqYkxfSW6RTmT73gz/o3ViwQVG3uChPdb3Mn2nRaipKbLg1/88hRpwNG6W
	 0HkG5OU6G6i+2MvYovNb++bYVVgNMVhg8TQ9EKpi5RR0lKskSs2nkAmm7ZHTNj4jyvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iJtufYOvLLXCOCugS/Ug2iM6SdNKNIJfvMGcldcG/3c=;
	b=PqPMRzMaKG/xGtZPkQler+WNme0oovCA/j5dF3SMWd7x0FVmabFVOo3CrQUbhz5JqnSZ
	 gOhQ7t69BXV8GhvpZi67TOg2nFFoJMOp3piGxiWB/0tXBoycGKi3lhddALLq1BUr/Rt1m
	 meiATS4U5+ps/XZVp3Tn0VgqLQDefUxyhSOQPvNzd371yVkJdKHmFfu++G90zIped63bd
	 bv+YNifAASOyqEG2Su/XCGgULdwgSbNOoeoTutP8+pz4aXjhH4DQPCtgLotnKXMt8ErxR
	 jrWqVHVgGw+qgkh39LmEL1ApMZmvefqoQVSVy4VU5mDfAld8srak1nZpsSoXnwrD2JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHkMIGKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ACD606A31C;
	Wed, 18 Nov 2026 21:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHkMIGKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6211F000C4;
	Wed, 18 Nov 2026 21:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036940;
	bh=iJtufYOvLLXCOCugS/Ug2iM6SdNKNIJfvMGcldcG/3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHkMIGKKeeVRY5ngYF8eqdqZtCreI48cFaO2bwY51dsTER65sKK2ylL86tXVRZd/F
	 R/SM4RmCg1WoMNbA7u+oPP+PFThOVpo1pnOB4v2YaLYspNXPZMi8DvPQQznWlghcjK
	 qkJzUIijmuRD4/GuYvawoW+EL3ZuiPYoIjStgtus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1236/3318] ceph: Fix xattr buffer leak in __send_cap()
Date: Wed, 18 Nov 2026 15:30:58 +0100
Message-ID: <20261118150357.273495856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e51cf76e7275d1bb5ad2d529bb00feade632dadc ]

__prep_cap() takes a reference on the xattr blob via ceph_buffer_get()
and also grabs a reference to the old xattr blob returned by
__ceph_build_xattrs_blob(). These references are normally dropped in
__send_cap() after the cap message has been sent, but when ceph_msg_new()
fails, __send_cap() requeues the cap and returns early without dropping
them, leaking both buffers on every allocation failure.

Release arg->old_xattr_buf and arg->xattr_buf on the ceph_msg_new()
failure path before returning.

Cc: stable@vger.kernel.org
Fixes: 16d68903f56a ("ceph: break up send_cap_msg")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1bf14f16055b6..c7ec3267c0d7b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1550,6 +1550,8 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
+		ceph_buffer_put(arg->old_xattr_buf);
+		ceph_buffer_put(arg->xattr_buf);
 		return;
 	}
 
-- 
2.53.0



