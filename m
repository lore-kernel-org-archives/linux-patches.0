Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C9913AD09;
	Tue, 10 Sep 2024 09:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962031; cv=none; b=jL9/w7/q7vb1/KpNL6jVIRosrnmFCIHMt23dxwWKz0URKWNsM+t0WcXJwovZeLEktV8NzA5vecNVE8DAHFwUHN3rAAnT18krJ8EVqFf71J1fD9r+XP0q8i/mmXYZQObVfmDJ1nXgx/LuYrI7hAlD5CkbslMrtgit68bJe2vrHeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962031; c=relaxed/simple;
	bh=J2/plzXgtWu/azeChDFNU+KenuK8dLokwqNMvSq+tdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R33quh7CSE7BwqJSctN4aLjbRQkgv0pqa8huDUT2yNxbDoYLqLjOPeC0K77LyG5FHoYap/Y8hGc3IQA8Ms7vFzavLqBDBTjGz+B5uXFicnF5RLy1hZESY2JQCadW7RtUKQdpP2x8W7x1ZAauG3QQTyRRhfehmTyRz2a7hUAbBBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQJD3fhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQJD3fhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CEDC4CEC3;
	Tue, 10 Sep 2024 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962031;
	bh=J2/plzXgtWu/azeChDFNU+KenuK8dLokwqNMvSq+tdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQJD3fhDdIFzceK4XrPliovzF9rX6lRp+UDT47N4RW06SO7a8Ofo3ZqyBvIMFSTR4
	 oa/I2LQCoL933FbARNZWbq0WI3yDkYit30XrODLtOuZVFEMraYyE6lLQJC1/pSzRgq
	 B6C0Mx74JOXZhlG1DUOJEuXOj50lyUnzd8Cd9yzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 271/375] lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc()
Date: Tue, 10 Sep 2024 11:31:08 +0200
Message-ID: <20240910092631.662841779@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit b2f11c6f3e1fc60742673b8675c95b78447f3dae ]

If we need to increase the tree depth, allocate a new node, and then
race with another thread that increased the tree depth before us, we'll
still have a preallocated node that might be used later.

If we then use that node for a new non-root node, it'll still have a
pointer to the old root instead of being zeroed - fix this by zeroing it
in the cmpxchg failure path.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/generic-radix-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index aaefb9b678c8..fa692c86f069 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -121,6 +121,8 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
 		if ((v = cmpxchg_release(&radix->root, r, new_root)) == r) {
 			v = new_root;
 			new_node = NULL;
+		} else {
+			new_node->children[0] = NULL;
 		}
 	}
 
-- 
2.43.0



