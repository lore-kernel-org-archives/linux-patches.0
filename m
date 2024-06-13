Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79301143878;
	Thu, 13 Jun 2024 12:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281492; cv=none; b=A5IKZezSHComnD1JVcEB9JSsvBIOOpenqSjOaWQbrFmBCVkX+XUuDYxJWl6xS+c0ocLN7461hBNIxzdNRN7gCYO0Kelp6X5g9MiYCBQnUplFo2MSXPyr07S/4M2I7sW/WulJeFYN8N7NLuG3diNPQ/azRj+U2fLa5696VwkdwEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281492; c=relaxed/simple;
	bh=l41t01N4e6t1dN7Jghc0EceU6tSjQp1X/RCtidh73zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0OEEnNZs655Om4z5EY3tH8QM9cPEk1Hz7Hgcj1SInCbwOSHrWNdztrlB4OZSBEYFiN8zJDwEb6HuQHnzAWIRhBZGFNETQd8eQSAbWdY2FfmSH0zfRTuLL5eQ6u6bxblmMPl2sB3GIhNzxiPMX01/bSWhBlGbZpxwB9dTB5d71A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPwiRMpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPwiRMpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CD1C2BBFC;
	Thu, 13 Jun 2024 12:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281492;
	bh=l41t01N4e6t1dN7Jghc0EceU6tSjQp1X/RCtidh73zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPwiRMpBL4mVpoFrFPvaR6ybEzUelksd3dxM8elYZWwx6lVlc0mgHBSWpmOoe2rMD
	 8/ZxzFox5wnccEhOsU2IhY9ZdIUYKnqz+EAL1zHfTLvx/PPE5uZzF/vtnx5JBIE2bW
	 43Admqo1nTkuwSUyAUuab1lyT49wyHpFcT+NK5gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH 5.10 274/317] netfilter: nf_tables: Fix potential data-race in __nft_obj_type_get()
Date: Thu, 13 Jun 2024 13:34:52 +0200
Message-ID: <20240613113258.151889766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit d78d867dcea69c328db30df665be5be7d0148484 upstream.

nft_unregister_obj() can concurrent with __nft_obj_type_get(),
and there is not any protection when iterate over nf_tables_objects
list in __nft_obj_type_get(). Therefore, there is potential data-race
of nf_tables_objects list entry.

Use list_for_each_entry_rcu() to iterate over nf_tables_objects
list in __nft_obj_type_get(), and use rcu_read_lock() in the caller
nft_obj_type_get() to protect the entire type query process.

Fixes: e50092404c1b ("netfilter: nf_tables: add stateful objects")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6238,7 +6238,7 @@ static const struct nft_object_type *__n
 {
 	const struct nft_object_type *type;
 
-	list_for_each_entry(type, &nf_tables_objects, list) {
+	list_for_each_entry_rcu(type, &nf_tables_objects, list) {
 		if (type->family != NFPROTO_UNSPEC &&
 		    type->family != family)
 			continue;
@@ -6254,9 +6254,13 @@ nft_obj_type_get(struct net *net, u32 ob
 {
 	const struct nft_object_type *type;
 
+	rcu_read_lock();
 	type = __nft_obj_type_get(objtype, family);
-	if (type != NULL && try_module_get(type->owner))
+	if (type != NULL && try_module_get(type->owner)) {
+		rcu_read_unlock();
 		return type;
+	}
+	rcu_read_unlock();
 
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES


