Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958431487FA;
	Thu, 13 Feb 2025 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459109; cv=none; b=Nvg+zNbEqDVMjkkXaiOWasqFEb4nkmIaTNYbmg4/1o/8L3w5lwBw8fUyobFOfqTNWMesZFU2Wph8f3ZMORjqLWUUDFsh/g/IfD3ogMg/jbms8S2agPekdP2ImUrdz8AQM9yxaNVyGluiLFGj9j78z0MgJEt4RWIU1JDjbxFnnqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459109; c=relaxed/simple;
	bh=RqW2aCIabCdVje3s7UK/cunJAZgoLEE7LH/UrxslUm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkQpYazOh2YiI7x/sW41BU3dZ2T/pq085AZewr6fq29ys3Qz5xvPVcyuxO/hGTAcWFpNUtKcz0u43UMqOZ0/uqBs+ADKPzL04nZahMqZAfviEkbOpItmVgC4WgH4nXfBFO59PCW3ZYPQAk4SXyl5rSU30M+pG4RCLoQryC8xLf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwvN0m3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwvN0m3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E69C4CED1;
	Thu, 13 Feb 2025 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459109;
	bh=RqW2aCIabCdVje3s7UK/cunJAZgoLEE7LH/UrxslUm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwvN0m3SVqUt6a9UxBQCnrkdSTFI6u6xnYuWXXFSj7567qNFmsymHeGNTRZpI+0Mo
	 whjjlerVnehPT+rUQYCRELddynaZow5plQ86KsxFplEyNMkiRBVln3mWqw+MQcahqc
	 JSWklfXfzByduW6IbsBNzHXaiGY7wpKgheuwAl8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Stas Sergeev <stsp2@yandex.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 138/443] tun: revert fix group permission check
Date: Thu, 13 Feb 2025 15:25:03 +0100
Message-ID: <20250213142445.926283539@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit a70c7b3cbc0688016810bb2e0b9b8a0d6a530045 ]

This reverts commit 3ca459eaba1bf96a8c7878de84fa8872259a01e3.

The blamed commit caused a regression when neither tun->owner nor
tun->group is set. This is intended to be allowed, but now requires
CAP_NET_ADMIN.

Discussion in the referenced thread pointed out that the original
issue that prompted this patch can be resolved in userspace.

The relaxed access control may also make a device accessible when it
previously wasn't, while existing users may depend on it to not be.

This is a clean pure git revert, except for fixing the indentation on
the gid_valid line that checkpatch correctly flagged.

Fixes: 3ca459eaba1b ("tun: fix group permission check")
Link: https://lore.kernel.org/netdev/CAFqZXNtkCBT4f+PwyVRmQGoT3p1eVa01fCG_aNtpt6dakXncUg@mail.gmail.com/
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Stas Sergeev <stsp2@yandex.ru>
Link: https://patch.msgid.link/20250204161015.739430-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 28624cca91f8d..acf96f2624887 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -574,18 +574,14 @@ static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return ret;
 }
 
-static inline bool tun_capable(struct tun_struct *tun)
+static inline bool tun_not_capable(struct tun_struct *tun)
 {
 	const struct cred *cred = current_cred();
 	struct net *net = dev_net(tun->dev);
 
-	if (ns_capable(net->user_ns, CAP_NET_ADMIN))
-		return 1;
-	if (uid_valid(tun->owner) && uid_eq(cred->euid, tun->owner))
-		return 1;
-	if (gid_valid(tun->group) && in_egroup_p(tun->group))
-		return 1;
-	return 0;
+	return ((uid_valid(tun->owner) && !uid_eq(cred->euid, tun->owner)) ||
+		(gid_valid(tun->group) && !in_egroup_p(tun->group))) &&
+		!ns_capable(net->user_ns, CAP_NET_ADMIN);
 }
 
 static void tun_set_real_num_queues(struct tun_struct *tun)
@@ -2782,7 +2778,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		    !!(tun->flags & IFF_MULTI_QUEUE))
 			return -EINVAL;
 
-		if (!tun_capable(tun))
+		if (tun_not_capable(tun))
 			return -EPERM;
 		err = security_tun_dev_open(tun->security);
 		if (err < 0)
-- 
2.39.5



