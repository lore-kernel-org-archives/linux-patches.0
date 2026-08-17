Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AF52DC783;
	Mon, 17 Aug 2026 14:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977078; cv=none; b=rQMWrkw0LmLhcmf5d9HSViwQYmMgfKmxS+orxr1A9VYFXvwOoKb29DCSBMBHqIe8KLJq2QwkAhcGfY5V3EmiCcEuY0ArOaLPX1Ugvd/N5Ov4/Xx5U7IDjgKA/AtdZxUQAyKEifp68X+CLa6NCvnBVBTxdlrTTF5PB2JtTKT16kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977078; c=relaxed/simple;
	bh=7lUapkBDwjSSrNpoer2EFJs5+EZOhQtXSJpMWG4M9Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3WcmYDbe7vYzxfn8qFzgUn8OWG+uqeU7IcEPlQWfKuYOvdgsi3SWEyK81dlRxUNs9sLdFNMStK66fflmoXTfwo4z/IIg2tTFl7LWiNeC/bkgDPI1CXfnmjtfZwMrtSzmSIE0Ec3+xSjpeSlDEbmotXpUFwMO31l8AjFkG1cFbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6NPb2Cc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6NPb2Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6021B1F00A3A;
	Mon, 17 Aug 2026 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977076;
	bh=otLM65eCeUIU663obFNPvGKqen7H6T8slIKKVHP80rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6NPb2CcEtx/20Fjvv1aa2KbvsE7cVud9R+dTiAmGMCsFug9KvcMhRBtHzRqt26a3
	 DBqWyy7rgtqDiDMLC6PepPq6FAycO0YzacgPLP8xP7FyUH2n9OwwRpxJVYa+vBWgOA
	 2cjk5je1jYk2DKc40K+8F8KO1inKfbKJUJ5qArdQ=
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
Subject: [PATCH 5.15 204/456] libceph: guard missing CRUSH type name lookup
Date: Mon, 17 Aug 2026 15:29:54 +0200
Message-ID: <20260817132548.118154496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3040,8 +3040,11 @@ static int get_immediate_parent(struct c
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


