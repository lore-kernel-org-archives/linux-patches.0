Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D575472F6C;
	Sat, 12 Sep 2026 11:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213105; cv=none; b=t5PdR+8iwsMi7rpm/crOn8KHuh8FByO5CXZM5ZHi2nc85c0SSIfdeVkxI1jPoM/ix6u8s8MQAButIiuCnzHWjEsjEokr9hckbYaH26Zjuev0BV2Zx74LBtwc9ct2H6JLqMCc3yQUMK3HBqrQG9od478ewW7zauztebVESvpr+Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213105; c=relaxed/simple;
	bh=Sm41zE/4PaRpX8s4ugvlvuBU4pNXqxcrajrsjKY4lkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpK4E1spvNzkyJHO9mb78WF/hptoybKYAn8to2Bz1SzDxnQQrE3RNxQ8SzeuxI9lFtgLfKrQwDfc7yWNvFcbHlUWc3GJE3DPWKQbV+c+Qd94OC4fBZ04zOjstFKJWvqyvr92shrEMLYpbGn+Iyv1RuGcXL2qtSrv7kvD5eNZlFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTyR8szu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTyR8szu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB721F00893;
	Sat, 12 Sep 2026 11:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213102;
	bh=e7/Yxxmr9tzxBcvwOFP8Geu+R7C66+HtM7NXpYHlGYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTyR8szuGVXh1XbHuYhmuLyyvTsVEojryNdjFtPCu6l66u3Zz/lZjdcGcnxM3RwW7
	 oxo2ZG0ZXB1qQ+lrZIJo4bABsb2xdhk5f1zaHbOj4CFB4KYy42RcG7Lfg23WfGQnUy
	 YnrOUGOa5sgz/P0/3ltE52Lt8MxaxKcZoaTlZ/64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0046/1376] mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Sat, 12 Sep 2026 08:41:12 +0200
Message-ID: <20260912065608.581506604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit f3ec3271210781c255e737498b84d5790e8176b4 upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme region directories by adding kobject_del() calls.

This issue was discovered [1] by Sashiko, though its analysis was
partially incorrect.

Link: https://lore.kernel.org/20260628220121.97360-5-sj@kernel.org
Link: https://lore.kernel.org/20260517205828.6204-1-sj@kernel.org [1]
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -197,6 +197,7 @@ static void damon_sysfs_scheme_regions_r
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}


