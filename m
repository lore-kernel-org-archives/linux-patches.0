Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D17192594;
	Tue,  8 Oct 2024 12:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391236; cv=none; b=hvrbp/bUozic/mdumvc6Eep3sjL76JyKC8kZzvKJ77niMInV0qDKdpYVGZzCP7ALxwjCSVFPmLdlvhxEyOMCSUMWwhSH6N2T2GN2FDO5fxq85H27n1LwM0+Y2H1mODo6icCJT1Hjj1sb1D8qioGvA+juZidtDIaNUzhU9bC0Grg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391236; c=relaxed/simple;
	bh=HmZ6ry0l4sg3fd7KC8jtOIywsGGtnD17HeWBQWjmlcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5yKKQCxfEy2IPiD9SfKGBkMU4Sg5a3/3GwquxZrs1s1KL8BF7ta1NCuD/Wv+xR8FG4QWqibSIFea9RWkr6lI/4dHKzobVSumLtE85B7NwqTviY/TSdMuyqW+nfqzfrW37wwMJrwkWT9MTLz2+uV/WeLvCNU+9Gdzxamc5MMOQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGdq3qxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGdq3qxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF24C4CEC7;
	Tue,  8 Oct 2024 12:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391236;
	bh=HmZ6ry0l4sg3fd7KC8jtOIywsGGtnD17HeWBQWjmlcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGdq3qxZ7P150sMKHisfqfXdokifqo2QLqpkdvr45KbZ5sFJmmiwBakxuhRxfIGxc
	 ISbSH5/TOZnlNeE3fz6JGkhJfkSM9y1EzCGF3lPljcxxek97X7KRsOJZhqdxuo4+2U
	 KRdLIw41EjP5npbQAbMtpH4H+s7SUPY5/i1t4yIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 051/558] net/ncsi: Disable the ncsi work before freeing the associated structure
Date: Tue,  8 Oct 2024 14:01:21 +0200
Message-ID: <20241008115704.229812407@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit a0ffa68c70b367358b2672cdab6fa5bc4c40de2c ]

The work function can run after the ncsi device is freed, resulting
in use-after-free bugs or kernel panic.

Fixes: 2d283bdd079c ("net/ncsi: Resource management")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://patch.msgid.link/20240925155523.1017097-1-eajames@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-manage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 5ecf611c88200..5cf55bde366d1 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1954,6 +1954,8 @@ void ncsi_unregister_dev(struct ncsi_dev *nd)
 	list_del_rcu(&ndp->node);
 	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
 
+	disable_work_sync(&ndp->work);
+
 	kfree(ndp);
 }
 EXPORT_SYMBOL_GPL(ncsi_unregister_dev);
-- 
2.43.0



