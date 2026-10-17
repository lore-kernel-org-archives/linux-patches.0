Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4780356A12;
	Sat, 17 Oct 2026 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257741; cv=none; b=FQfA18b+e9PGAa/USIzwek4a6R3O/oK5iOit1UNz33X38z//HfSPhseFQY0SR67TnQkO8Zc5LD1sL6Tq9ql7ZDKnUqxbv7Xvp6ZeK2Imed0NjBYseZ9pAmuY7Yytpr0gViXl/yrgoPWQONUHmEmEHig4J7rDac6B54Lm5hHMwu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257741; c=relaxed/simple;
	bh=Ay2gPq9pdGlZKZWP6xy9sr5SuFyyfgQbpIAcyT5UVFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VB6ZiYdt7EiAAgZAPmVtUBod2e2Mn3orYRQY9N8dPqjkDyp4d8AYry5GXsmO+qR1H/VEXjCO4nhIlBSX+NejI4iSNiT8rt2+hDf1OvdBViJvjsNX3nI6DR1vfKNjbg1U1hSSBd8tneisjwJ0tB/pwVNd5vIDUrDXr6uf1/Hs7Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjCvov8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjCvov8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F000F1F000C4;
	Sat, 17 Oct 2026 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257739;
	bh=EQxMtoUlBS+gSXyoN4pX8+JhUTWIuebROLQUW/alcWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjCvov8zfkdeuc+G8zBTUToHvnbkexgyxq+D3WBy23ELkCTKxQhO5Ws6ntAU4LAKO
	 aErT1H8uhiPSFblSYbcLLpy0Z2xDMkQiBj8FCtAL4beW9qhsa1/CmYWRi9iSwN5AOQ
	 5uqSK0zkS1BT4JdSdF5eP1XjP43Kn2VLPvJARq8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0653/1674] net/ncsi: Disable the ncsi work before freeing the associated structure
Date: Sat, 17 Oct 2026 17:48:45 +0200
Message-ID: <20261017160447.872448406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a5d3615d7996e..16a44079cda16 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1967,6 +1967,8 @@ void ncsi_unregister_dev(struct ncsi_dev *nd)
 	list_del_rcu(&ndp->node);
 	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
 
+	cancel_work_sync(&ndp->work);
+
 	kfree(ndp);
 }
 EXPORT_SYMBOL_GPL(ncsi_unregister_dev);
-- 
2.53.0



