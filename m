Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05911DE4FA;
	Tue,  8 Oct 2024 12:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389619; cv=none; b=u2oGxGPQrVS9IDt/isR5MZVpnc1wdHSm5BUcFjZMRaj51DUiAXtqC/5By49EyKm1/JRzSXSuNzP768whpHLM12fwY1gYmp93ql+wayjFcGMKNsHxZEy+k9yfoyjc/OPdl/4pg2qyiFX/7dXSHu0AfqUM1xrA1r/NF3xaLWPcpT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389619; c=relaxed/simple;
	bh=rKMseqNElhe6blnws2qWPt8H83uQKUXkxr8OQEWnCCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lU5q2mdrH7ghTDBBTJS4KAnVwtbU6Tf6q6DCZbLDEs4M73vSIDtM5aqzZXoMmDP2EoV2mZ0Gesg49OcspZSLBNtNoa8QPH4261jK6zs/z1CYyhBmXXQjNsvxJq8iJe17tffKae97JhYkCe1Lmt4DK1t6S6uWJfiB1DZPAt6yhQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcmreGU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcmreGU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA0AC4CEC7;
	Tue,  8 Oct 2024 12:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389618;
	bh=rKMseqNElhe6blnws2qWPt8H83uQKUXkxr8OQEWnCCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcmreGU3P/WN7vy8iPEKd7RZ6UeGX6OB7uXyTbrPKvieCtwpPYccXxrfVnaY3gI5M
	 mYqpj84AGMkZbQ0Suz2bnwZwf7gkGyE4MH137k5uO0/oKVfi+Tg1S/NJXUldNQmHu8
	 p9EXd+MCUdCw6oru5gobdqA4Eux5cyyCS3O78Sec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 046/482] net/ncsi: Disable the ncsi work before freeing the associated structure
Date: Tue,  8 Oct 2024 14:01:49 +0200
Message-ID: <20241008115650.117155894@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



