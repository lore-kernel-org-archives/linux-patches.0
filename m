Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36DC3446C7;
	Tue, 21 Jul 2026 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669440; cv=none; b=S/Pqg0vmo61MFAVROzZMbm3zX2P2eUokjekvZJu0HqX/NpcyuxQ9ZOsXfIGLn0/uyrNLyEjCJQOhc8uvg9hSU9wkpRuhFUn5ac/d7whYh59dOLHFBXpcGcRCp5Gv1G+dmpY9r8IZQB8498yhd8OQ8BSYCh6wRlr+RXFBL5JLTCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669440; c=relaxed/simple;
	bh=vBjQgw1vrtMJarX/8YkMW1WD7j59HN5DVV886T0JE8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3LmJHzyGhbvU7PCU0lcQcpvpbFJS7t1zgOrqWsbF4Pyox+ya+n7W6ySXCyjBPrLnjN47V/lcsZ5QteC5DpjfJrDijQKEAm95vkwOTn/4xFXAgInJckFilJNOw9S22cw74m/TfmCWLeHXMlcZ4K3SRQvzefM1IHBhhT0/P7teuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nhcmjq1W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nhcmjq1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2191F000E9;
	Tue, 21 Jul 2026 21:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669438;
	bh=1ucDsBPc+j/ueNd2GRUZLnl3xO9TOFJ6m2iqFvJvXk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nhcmjq1WS/O6nWmN954iOfDphFq9F7c4WYq9O3MfUuseDePuuZ+rtFhj6t8Pms83d
	 NDl4j1ATQJixzfF5A1nQT1WUVf2o0GJ/A8cXxqEycVaO02xl9kCYfA/AeItq+nTUiq
	 N6SdqAWgT+lVWXZ5jt02nwFAyVP3EqweFF4W/DzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0554/1067] apparmor: aa_label_alloc use aa_label_free on alloc failure
Date: Tue, 21 Jul 2026 17:19:15 +0200
Message-ID: <20260721152437.002342761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit 654fe7505dc6889724d4094fa64f89991afabfc3 ]

aa_label_alloc() allocates a secid before allocating or taking the label
proxy. If the later proxy step fails, the error path only freed the label
memory, leaking any resources initialized by aa_label_init().

Use aa_label_free() on the failure path so partially initialized labels
release their secid and other label resources before the backing memory is
freed.

Fixes: f1bd904175e81 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index c57c5d296b5199..dc12488b5b3da1 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -452,7 +452,7 @@ struct aa_label *aa_label_alloc(int size, struct aa_proxy *proxy, gfp_t gfp)
 	return new;
 
 fail:
-	kfree(new);
+	aa_label_free(new);
 
 	return NULL;
 }
-- 
2.53.0



