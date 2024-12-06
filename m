Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D823253A7;
	Fri,  6 Dec 2024 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498398; cv=none; b=K0UzSjTZrSnuXqnkt+zZHqqADJY7fL57qcFVA5ofBfQhQ2NHKvWEdRNNcPcHAXsQsDmarHmOfzpcCMrwTwpzLZStT6GkGXhe4pocXiUceYvEQ8+4ZuG0JRFN4ENJp6ecgGRxe8o2odOZpfZu3x6maCsAFPEJJkWQLDAOz7JJW/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498398; c=relaxed/simple;
	bh=1w1IwtgAqa9NRqlISEjVy2hebqCtbuX4pKgMKzsTncA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0J/GUrEYgxNeEYcmc4r+d/otzV/79mQGy2ZLxrFDriGGwPYmvvVjECcpkXnmJijp3X/J2SAF41nUrB1Ok6FxCZfZZZCp+MVfIocbbtedytDOmneUs6T4iWNFPsNJe/iVv4klDIj+ugHvijByb/8KQMny6dSJLz0eVJsQK40oUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dC+qLAsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dC+qLAsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CD6C4CED1;
	Fri,  6 Dec 2024 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498398;
	bh=1w1IwtgAqa9NRqlISEjVy2hebqCtbuX4pKgMKzsTncA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dC+qLAsTnNQ346SZrhdVrWmJhENoK1eOLP+NSCU6RT6NcZwRsP3JbL39UtM3Qp1yt
	 5h2ZxDhCz1mjYEhJ6usxmNlaI/3hF36rd5JEbj3uypcsHKOEsxnwo3TEJq7XmdjAKn
	 Q7llp56n7oxE1NWx8Fom+D0UfWEColIzLNPBqn6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Alexander Merritt <alexander@edera.dev>,
	Ariadne Conill <ariadne@ariadne.space>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 573/676] 9p/xen: fix release of IRQ
Date: Fri,  6 Dec 2024 15:36:32 +0100
Message-ID: <20241206143715.739266048@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Alex Zenla <alex@edera.dev>

[ Upstream commit e43c608f40c065b30964f0a806348062991b802d ]

Kernel logs indicate an IRQ was double-freed.

Pass correct device ID during IRQ release.

Fixes: 71ebd71921e45 ("xen/9pfs: connect to the backend")
Signed-off-by: Alex Zenla <alex@edera.dev>
Signed-off-by: Alexander Merritt <alexander@edera.dev>
Signed-off-by: Ariadne Conill <ariadne@ariadne.space>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241121225100.5736-1-alexander@edera.dev>
[Dominique: remove confusing variable reset to 0]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 308dae05aa9a1..6387ee924a2d6 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -287,7 +287,7 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-			unbind_from_irqhandler(priv->rings[i].irq, priv->dev);
+			unbind_from_irqhandler(priv->rings[i].irq, ring);
 		if (priv->rings[i].data.in) {
 			for (j = 0;
 			     j < (1 << priv->rings[i].intf->ring_order);
-- 
2.43.0



