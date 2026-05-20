Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DDF3F1AD9;
	Wed, 20 May 2026 17:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299990; cv=none; b=hB92JGHaDkFgqgWW5+VGUec0t37f6xVEipeb6Sb4Ku8p2zk+kcAVoTsnyKNM/oD7p1fYVR8q7e1u7tCCB6TIS+ho9vvxcSja54mu0v7aO66h16ThXSpVxuQwSdZXSy5/Vrk69YT6rJhSVizcZ4o5B3XRQZCvldCkibjxBzUffLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299990; c=relaxed/simple;
	bh=1R10FNG2UcPpI5EKzFEBCXbt2poj7R7jy6v86Sngeio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJjb96obbpbmKxMx3cODqUwW9jZ7pjgdGpcIfHwuOqlybuXMyDqKFXvpVRHXeg6sd7tNnt4wgyCDE3kM0KKlFyYhpOdYatqGhJI9oReTfNgd2UnknmwkHrCL4mCP+I3Jd7PUp3DZuL7x6GI+XJGlErc9VT9B2lKXPjWzbfGIGN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7jY2T82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7jY2T82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF7C1F00893;
	Wed, 20 May 2026 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299989;
	bh=e798+27n5Iho2VuWM18WG7O8UsXPnv/XujqklrWqb7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7jY2T82DmCDwG1BLBi5X1jFf05xIP0PLaxZWPlhiPECSYf1P6HH73r1laW6WqKlW
	 53vQptCBzUxR/X5OH/+R6xyhtYbYlLt6SXSQVH29+33ans4m07B8NIEYEw4ZH02Q0h
	 PTKLr7nEQHY2LsO3dhD98nvHm/dHZFKavxNeqN2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 936/957] libceph: handle rbtree insertion error in decode_choose_args()
Date: Wed, 20 May 2026 18:23:39 +0200
Message-ID: <20260520162154.890638059@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit d289478cfc0bcf81c7914200d6abdcb78bd04ded upstream.

A message of type CEPH_MSG_OSD_MAP contains an OSD map that itself
contains a CRUSH map. The received CRUSH map may optionally contain
choose_args that get decoded in decode_choose_args(). In this function,
num_choose_arg_maps is read from the message, and a corresponding number
of crush_choose_arg_maps gets decoded afterwards. Each
crush_choose_arg_map has a choose_args_index, which serves as the key
when inserting it into the choose_args rbtree of the decoded crush_map.
If a (potentially corrupted) message contains two crush_choose_arg_maps
with the same index, the assertion in insert_choose_arg_map() triggers a
kernel BUG when trying to insert the second crush_choose_arg_map.

This patch fixes the issue by switching to the non-asserting rbtree
insertion function and rejecting the message if the insertion fails.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -395,7 +395,10 @@ static int decode_choose_args(void **p,
 				goto e_inval;
 		}
 
-		insert_choose_arg_map(&c->choose_args, arg_map);
+		if (!__insert_choose_arg_map(&c->choose_args, arg_map)) {
+			ret = -EEXIST;
+			goto fail;
+		}
 	}
 
 	return 0;


