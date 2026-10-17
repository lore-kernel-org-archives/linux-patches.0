Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD4A321445;
	Sat, 17 Oct 2026 16:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253750; cv=none; b=bHss46wppw8PjlFMAowz+pK0AiktwbjET6XQm39S+N06UHXXNjl7fwtYzJYmAFQZbvi3PDAoVAcvVfEHELMy6GirIgqpZW3vZhkBlig6lJxha43uYpshpsmXFJN8VeOOTEPd7mGR9cLbdSN3szqhHhsnqvABiJTXHB7+AaiqwHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253750; c=relaxed/simple;
	bh=K8bexj9uUeCUeAvbXHeZ0GO4+49jlbs+S5SMAwk6xWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdVbIuXeYadnkihSyNifxaQtFXq1KB+rbiyJ74Au7OHM3RElKCWEM9NIcRtBBOmIJFawUCAebfaChhb4w07xqR1InSGA2mP9ZDKO1beokgFsNRd68u5mRiw8LgR5OdaoNT6d9egcYA8Mq52AVZZENheQ/YYEslE0fF2+8Noxqcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+D3+DV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+D3+DV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8393C1F000C4;
	Sat, 17 Oct 2026 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253749;
	bh=H5Ntum0vNfyV88+t1Hv4bM0NwYRk4JWvu04VEvYVZpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+D3+DV25aA2ih80+DYKyPboGo5FsTv/9M2F7SgqvDjxRK5NT7h05btgLAWzMgKDp
	 1xuQI9bzk7vDzkwb+C/UKqGWkxTujcftb+7qV472ixyR+UPz9y3K8m/8RBp4ZyOfii
	 vT/IXdSlc75gwyv8+EiUHyMNfaT2fgBt9LXH7Xzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/869] mpls: Unify return paths in mpls_dev_notify().
Date: Sat, 17 Oct 2026 17:51:01 +0200
Message-ID: <20261017160042.692866900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 451c538ec067e84c1bf1c2b99ebc2b1ca0a09090 ]

We will protect net->mpls.platform_label by a dedicated mutex.

Then, we need to wrap functions called from mpls_dev_notify()
with the mutex.

As a prep, let's unify the return paths.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20251029173344.2934622-4-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 629ec78ef860 ("mpls: add seqcount to protect the platform_label{,s} pair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 7e38c71f7212c..65fc18eaf4171 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1619,22 +1619,24 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 
 	if (event == NETDEV_REGISTER) {
 		mdev = mpls_add_dev(dev);
-		if (IS_ERR(mdev))
-			return notifier_from_errno(PTR_ERR(mdev));
+		if (IS_ERR(mdev)) {
+			err = PTR_ERR(mdev);
+			goto err;
+		}
 
-		return NOTIFY_OK;
+		goto out;
 	}
 
 	mdev = mpls_dev_get(dev);
 	if (!mdev)
-		return NOTIFY_OK;
+		goto out;
 
 	switch (event) {
 
 	case NETDEV_DOWN:
 		err = mpls_ifdown(dev, event);
 		if (err)
-			return notifier_from_errno(err);
+			goto err;
 		break;
 	case NETDEV_UP:
 		flags = dev_get_flags(dev);
@@ -1650,13 +1652,14 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		} else {
 			err = mpls_ifdown(dev, event);
 			if (err)
-				return notifier_from_errno(err);
+				goto err;
 		}
 		break;
 	case NETDEV_UNREGISTER:
 		err = mpls_ifdown(dev, event);
 		if (err)
-			return notifier_from_errno(err);
+			goto err;
+
 		mdev = mpls_dev_get(dev);
 		if (mdev) {
 			mpls_dev_sysctl_unregister(dev, mdev);
@@ -1670,11 +1673,16 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 			mpls_dev_sysctl_unregister(dev, mdev);
 			err = mpls_dev_sysctl_register(dev, mdev);
 			if (err)
-				return notifier_from_errno(err);
+				goto err;
 		}
 		break;
 	}
+
+out:
 	return NOTIFY_OK;
+
+err:
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block mpls_dev_notifier = {
-- 
2.53.0



