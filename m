Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7381A00F0;
	Tue, 26 Aug 2025 12:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213087; cv=none; b=PebSidf8MasPzV79bs54JRf/48ZeSJvzVNUhUarY81T2RXzBKC4jbXaeNCQz+9n4/Mu8tw77wkufnUKjynFovSt9SLrPe9UB7qc0oQ0mQO+7aHU8HSc/PddVDqYwYoeJWHktzegh2+PF7r1+Wdc1MwxpMDsrJsEar76274zIiVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213087; c=relaxed/simple;
	bh=itnukO7GY/CRW/XMIX5jr1YE5qSHjweA7x3Ued7hmd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aiHEyv1vysMjSGpV4Gw/k+K1l74ZjDSFjcw7k7Oj5hWFIdXzot7uf/qjn4DP54GFzrx+M3qmBe8Pp2fyDkRMWsw3raMJGTd2CElQHdrduu+u0to+XqhuwmZpkWeBe0a0agxSfTz71dbVTedITHeXlsIK7HRW3VrdJ5nVbAkdgmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3/OvbjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3/OvbjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFF9C4CEF1;
	Tue, 26 Aug 2025 12:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213087;
	bh=itnukO7GY/CRW/XMIX5jr1YE5qSHjweA7x3Ued7hmd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3/OvbjM9aYGCeZOXThxuB2QHikMh6Rsb4ZU4eFy+DDriN51q6bzdd34va8nKzGA3
	 hYqtuO9ONGphXZtauH4WWCNy3uuYp5RZbZLh6C7FRqEuHZj11ytlIyRJpuxgLbQH6N
	 vrgvsKASW7KWBY0ufb28ZP9xwZPHXc28M9u0wWRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/587] vhost: fail early when __vhost_add_used() fails
Date: Tue, 26 Aug 2025 13:06:05 +0200
Message-ID: <20250826110958.431252037@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d0238bd741b0..147cfb64bba2 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2770,6 +2770,9 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
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



