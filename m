Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBE7370D4F;
	Thu, 30 Jul 2026 16:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427827; cv=none; b=eKYfAiNgW2RC76mYbAI4PwTdATa8uiGIp8C1NcJmHyc/GXHaPkXSr5yhGGbVluQcHFWWnaF8MJvkmJZ3NQcfkBMugJYH//IdJK+TKCIW7ygkEHPhU2WwaSLGwV+kfc/k0f86T+vyIna8Fd3hoXQ6gwLk/FbTtgpEo/UTwCCKUd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427827; c=relaxed/simple;
	bh=k5t2sMUAHO1lzsnleEIU/hWEi5Pz74qV4F4abzGLfEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcidnb6Fehe5wZoK/AFHT0SeFeZlyfZTVajSW88vsBNQZxksuzpLLFIfGyRSF1aVs8ArV+iMApF5HJPeHgWbnvO8lUjJ8bjCj0Zer6yQ8VWpsfSWGxzVuYcXmC9kG/S9x8GNghi68g12qybhiV+a8HNTvIxB4U9+qASuE/HRizc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIu41gZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIu41gZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBEC1F000E9;
	Thu, 30 Jul 2026 16:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427826;
	bh=TM3pC6+PjtL07pWa7ztIFZIHe0VPahmcxJrkej3yw+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIu41gZjzGMm3ou/t94y2/LoP/R90CZ5lfYZs0n0kV3jyuhsBNuEk5gLofX1FNjs/
	 jx7pzgnE/a9lfPH3sfN/v0X6zs3K2ISOU1nXJnNqexIzo+aidE8dEKGOFAfHBGoTT7
	 +9tbY4RCEaDBWSAU4LZTeLLxJDeDAkVsSUkDzarg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhao Zhang <zzhan461@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 306/484] libceph: guard missing CRUSH type name lookup
Date: Thu, 30 Jul 2026 16:13:23 +0200
Message-ID: <20260730141430.137564406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Zhao Zhang <zzhan461@ucr.edu>

commit bbeae12fda3384a90fbebc8a19ba9d33f85b5361 upstream.

Localized read selection can walk a parent bucket whose name exists in
the CRUSH map while its type has no matching entry in type_names.
get_immediate_parent() then dereferences a NULL type_cn and passes an
invalid pointer into strcmp(), causing a null-ptr-deref.

Skip such malformed parent buckets unless both the bucket name and type
name metadata are present. This keeps malformed hierarchy data from
crashing locality lookup and safely falls back to "not local".

[ idryomov: add WARN_ON_ONCE ]

Cc: stable@vger.kernel.org
Fixes: 117d96a04f00 ("libceph: support for balanced and localized reads")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -3060,8 +3060,11 @@ static int get_immediate_parent(struct c
 			if (b->items[j] != id)
 				continue;
 
-			*parent_type_id = b->type;
 			type_cn = lookup_crush_name(&c->type_names, b->type);
+			if (WARN_ON_ONCE(!type_cn))
+				continue;
+
+			*parent_type_id = b->type;
 			parent_loc->cl_type_name = type_cn->cn_name;
 			parent_loc->cl_name = cn->cn_name;
 			return b->id;


