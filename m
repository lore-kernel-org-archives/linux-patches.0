Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029030;
	b=C/bMesEZVPvgM9NkWL13veGpU8ro584Lce5decOOxyK0HNT7S4+3M89Qq77uVqYG2vel
	 edjt4vbONGfetXQVjuUG/ZAY61quimtzoHUKy5xZFXt065wfjxMubIloKwUWR6xsGwUg0
	 yTzq44f5JcJa6AuVBIcDFwiwslEY7+FlWnb6LW3O1pDf/nxkmhfNp4jPB8YaM4dYqVVR3
	 vw7Bl/mHgNCpmbJK70t3acpAE+4dumH1Zb+FUjWZDzlfuC2mgmAb+lOWe7eLcJuqsMCqn
	 xs5QQ/xw2BiuFkOVEaiwkDhATp8JbIfitx1p5AXRJRrwBT6Y1MO9IeviLcTSjOXZKKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ylQl296+gG/yrsX6vhy6ctDeTJuiMAnHj6Cy3j0TSck=;
	b=WlHgenbjSvyBbEI9VQFAdpBVjY5RXmyhPDZxiYVYmCMtfZ9oV9bL+RN85ABQJVBZybmv
	 Ebh0rlkr048KCaBkxdOyyYwOHjVKJ1E3C92Oa0ltIyvfecdSsqPseJqR3ATe2uBDl5E+z
	 cCtXV+dYSy89ZWBhzGyIsKK/mEJh1yZ8ZNPhXAGQMiT0hFfIXkQj1rHvqgxz/QjHgQooK
	 XNBxg4MAX0bitLShtgTKOkMe33AYAHF2/HGGykq3NcsbfIsXhJzrJJJKHn5YxiDYyb4wY
	 1WDD1EK8wuLiRzCzzqSnkfZzWcnQ0dnamxvw1g0L75E1MAOHRjQ6NqGnccZR8SaZsdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMDheKoU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070E7606A32C;
	Wed, 18 Nov 2026 19:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMDheKoU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E2A1F000C4;
	Wed, 18 Nov 2026 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029029;
	bh=ylQl296+gG/yrsX6vhy6ctDeTJuiMAnHj6Cy3j0TSck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMDheKoUfecnXJNMRBRZ7+boAWArt2qUdbEOVh/Wio0J3ubZ+S4zP13behPUAhQCz
	 VSMGYdtVvIFQBPdcV/0dRumEupUNF+/koDWWuiLgwL8YIxus5T9e5bbiCCJu87Gn1k
	 4sYRTFZWQzf6BZ4VcP9zHfrhHhYkDAPP094u8n+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0203/1756] dlm: fix buffer overflow from negative len in dlm_search_rsb_tree
Date: Wed, 18 Nov 2026 15:38:50 +0100
Message-ID: <20261118150016.450569372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit d785f7d92f197b72d496bbcf54a160cd54f00263 ]

commit 080e5563f878c ("dlm: validate length in dlm_search_rsb_tree")
only checks for len > DLM_RESNAME_MAXLEN, which does not catch negative
values. While the input 'len' can be negative and a negative int passed
to memcpy() is implicitly converted to a large size_t, causing a stack
buffer overflow on the key[] array.

Fix this by changing the 'len' parameter type from int to unsigned int.
This ensures negative values from callers are implicitly converted to
large unsigned values that are caught by the existing
len > DLM_RESNAME_MAXLEN check.

Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: b4e6ae7ba711 ("dlm: fix variable key length lookup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 6 ++++--
 fs/dlm/lock.h | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 18c4039058969..431534e956f0e 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -622,12 +622,14 @@ static int get_rsb_struct(struct dlm_ls *ls, const void *name, int len,
 	return 0;
 }
 
-int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name, int len,
-			struct dlm_rsb **r_ret)
+int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name,
+			unsigned int len, struct dlm_rsb **r_ret)
 {
 	char key[DLM_RESNAME_MAXLEN] = {};
+
 	if (len > DLM_RESNAME_MAXLEN)
 		return -EINVAL;
+
 	memcpy(key, name, len);
 	*r_ret = rhashtable_lookup_fast(rhash, &key, dlm_rhash_rsb_params);
 	if (*r_ret)
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index b23d7b854ed46..c75975937331c 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -31,8 +31,8 @@ void resume_scan_timer(struct dlm_ls *ls);
 int dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *name,
 		      int len, unsigned int flags, int *r_nodeid, int *result);
 
-int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name, int len,
-			struct dlm_rsb **r_ret);
+int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name,
+			unsigned int len, struct dlm_rsb **r_ret);
 
 void dlm_recover_purge(struct dlm_ls *ls, const struct list_head *root_list);
 void dlm_purge_mstcpy_locks(struct dlm_rsb *r);
-- 
2.53.0



