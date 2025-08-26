Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6F13451A0;
	Tue, 26 Aug 2025 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217829; cv=none; b=u/xChX2faRSOMVZXYQc6htccj1Bt93eikJsTRgvM/GTK9ZuO9zZSXu7xUHDKxMdpekyOixEZKcWmR3HV9UMAYcwtjbJgNQ1nb4ELDrN++KpJzFDb8rfX2FsFYE+MbwGjlp/esMq2JPhlQxH0iuW0C6l0cn7Fxo1qsG/J3Jp38bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217829; c=relaxed/simple;
	bh=K2caPgsdkjx22tZEcp5vxKIl6xUE2gAOR28lb15p+qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/Jc79sdDtAaYDdSXZ1N02b9i+eqrSdf+2Dh7mTKX3Q8x1wy3RN463dMD/qa5mWXdj0CI7zSSG7T/GUtJ+76wf9qiHe9vACIJd3cViOD21IVgPUI86v4akpLbet0BBwJ6ezx8poEEJIcsre0K7bGUQrv1Vc6NnEakKh0ggflVu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM4fXQys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM4fXQys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2129C113CF;
	Tue, 26 Aug 2025 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217829;
	bh=K2caPgsdkjx22tZEcp5vxKIl6xUE2gAOR28lb15p+qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM4fXQysJzSyUomAuYu11f4OSl0dMuTUeFPxL3HydWf0xQ+Zda8mW1NBUthHpVSJu
	 qZh6mdiokEKi+ubJiPJYbc1pG8JJj0W/1pJKbXSqR7zIJ/eZQPpsxoYP+Iw9ft55Hw
	 ozvm+v7KCe5+Ok8sYxuBQIN9jiMtOSpLg3vud0E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/523] vhost: fail early when __vhost_add_used() fails
Date: Tue, 26 Aug 2025 13:08:20 +0200
Message-ID: <20250826110931.600109910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit b4ba1207d45adaafa2982c035898b36af2d3e518 ]

This patch fails vhost_add_used_n() early when __vhost_add_used()
fails to make sure used idx is not updated with stale used ring
information.

Reported-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20250714084755.11921-2-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 8ed9c9b63eb1..97e00c481870 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2416,6 +2416,9 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	r = __vhost_add_used_n(vq, heads, count);
 
+	if (r < 0)
+		return r;
+
 	/* Make sure buffer is written before we update index. */
 	smp_wmb();
 	if (vhost_put_used_idx(vq)) {
-- 
2.39.5



