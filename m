Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D39E3C3C0F;
	Wed, 30 Sep 2026 19:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794973; cv=none; b=KhwQUHFhsRlFrVVAWxu/rbWBBumzvVZsUVv5hs8pBLh76otQzslEdfRPOqYPfXSAby8af00BxkJGTNUw9snQnsL2k+nD2rP8glXoXnkmgbS/pjKax5XLgj/GpdkTiVt36jRY100F7CoeBlfTcvfxND1pMKIWDyCExlbrleYU3Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794973; c=relaxed/simple;
	bh=g+ocqURIlLoOtpTDPNw2KQx3d0W+O621yjnCatdV6ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byOiEiOAilqHsFyT3NxU7IJ4VIXFjY7GdQEWM38XTjZPAFMVqNQPlV9eDcfmtjhUOzkjrwgGXqNm1jnJaRJMIlLKgjxv6aUoX5JlB5AbqC4kJPMoUNYphtukHsh9aCBO41euMAq3j9oIsj2nAMdZvdLwBBEBJQ40FulUn5vkKRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rg7EmA0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rg7EmA0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A74C1F000FF;
	Wed, 30 Sep 2026 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794972;
	bh=RlhlNCC+17PcUDi8nSpW3o+9bFaXimpfV+UzJOuk/Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rg7EmA0QKnkAwh7xgXJjuwwk1zXcHbfkdWMq8hoXFmR8cuaydtQxsbdZw4At4zgeg
	 KbT4XEeQ7wWILaFXjx4RRwhUrr8AgwddZDYDVYkWXAhuuKxYjWp5PIHPeyOX5AZxXy
	 2y6zTJ24+0GVyYUkf+XbEvCqb+oeR+fERjN31FTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0398/1193] smb: client: transport: Fix debug printing in __release_mid()
Date: Wed, 30 Sep 2026 17:18:02 +0200
Message-ID: <20260930152443.034612120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d83a21bb26015bfdd79b0440fe816b271b8bbab3 ]

Long time ago during upgrading printk():s to the respective pr_<level>()
calls one misconversion happened and nobody has noticed that. So,
previously printk(KERN_DEBUG) + printk() worked as one long debug print
since the trailing '\n' is only present in the followup printk() format
string. The culprit change missed that and split the message to two on
the different levels. Restore the original behaviour to make users be
less confused in the most likely never happen cases of partially getting
that message.

Fixes: 0b456f04bcdf ("cifs: convert printk(LEVEL...) to pr_<level>")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index a47242a0f5c6d..8d28b594b4173 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -143,12 +143,11 @@ void __release_mid(struct kref *refcount)
 		trace_smb3_slow_rsp(smb_cmd, midEntry->mid, midEntry->pid,
 			       midEntry->when_sent, midEntry->when_received);
 		if (cifsFYI & CIFS_TIMER) {
-			pr_debug("slow rsp: cmd %d mid %llu",
-				 midEntry->command, midEntry->mid);
-			cifs_info("A: 0x%lx S: 0x%lx R: 0x%lx\n",
-				  now - midEntry->when_alloc,
-				  now - midEntry->when_sent,
-				  now - midEntry->when_received);
+			pr_debug("slow rsp: cmd %d mid %llu A: 0x%lx S: 0x%lx R: 0x%lx\n",
+				 midEntry->command, midEntry->mid,
+				 now - midEntry->when_alloc,
+				 now - midEntry->when_sent,
+				 now - midEntry->when_received);
 		}
 	}
 #endif
-- 
2.53.0



