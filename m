Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7A05381A;
	Tue, 10 Sep 2024 10:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963767; cv=none; b=ModW2xZbpV5h3LCBwl9Jj26BY6ZLZxh1Sb8APwIAL3fhDQh54V7ArxArzTaqeJhLOIvaGxw4yG1NG6IMy+240/qy2EeMlttZFdRiXMRU8T24LjXR1QfTwjORo2B8cz1zCPViUbaIWqHywAMgkCdcTk6LDKVeAU08LqhrI1onWHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963767; c=relaxed/simple;
	bh=nuh0Guvya6VhP5DOZWsMNIVkXwuhkeAcYFgJtGXxTVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNreYynciCWhgnokiXtjqKxokYVC0uIAdw/lCZuTynuTfWs5O3Ko/3xxAXcuAHTvPKxjdGbLaPvwJDMN6LGgNhNNWW5V7iF9/gJc55bBR2gsKThFJrPuVvbYkSbuWVaelrhmJddFpYndJwuhxFRD+yKXmNTR4OfbRbBNeh5bpu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhRq2piQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhRq2piQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B85C4CEC3;
	Tue, 10 Sep 2024 10:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963767;
	bh=nuh0Guvya6VhP5DOZWsMNIVkXwuhkeAcYFgJtGXxTVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhRq2piQudBwxu27bHjDlogq94GDfVu85mbd4bTSEgWBxtDWs4Xr6LjLaQ3uP0DsD
	 K0vvnczQ/aW9XuUOr9BlsPaLVKJC5iDz19Zc9vHi0PwQza2EU9Rc4VR2BJAjgg2KIM
	 LfL5fYP5ykdC24mlnZqpO+6OfEvBQqllc7gDcm2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/214] lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc()
Date: Tue, 10 Sep 2024 11:33:11 +0200
Message-ID: <20240910092605.599769283@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f25eb111c051..34d3ac52de89 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -131,6 +131,8 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
 		if ((v = cmpxchg_release(&radix->root, r, new_root)) == r) {
 			v = new_root;
 			new_node = NULL;
+		} else {
+			new_node->children[0] = NULL;
 		}
 	}
 
-- 
2.43.0



