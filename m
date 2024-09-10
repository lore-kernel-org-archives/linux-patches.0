Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562D518C025;
	Tue, 10 Sep 2024 10:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964458; cv=none; b=MoxrPoxasiOXkeMxavDFag2DQeucexXyS+0c7zKTKpZhy2UTXFiNx30JyCsGvxsvCqqj2qYcLnkgz+CZ3Tx7BJ0DO8cAZUi3XmaojQzpormK+FHM5hWzKHwdFof7a4usHHS09xO8f/foX/5Z9NKjJMazS54nIzGI1b0D9W19euM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964458; c=relaxed/simple;
	bh=GS6yjkC7vGI2EbL57ftD/uCzoK9xia6+p86yOB9Xpn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogCRLqEkCbMcsvkqxf9nW02zy/S/CFBYeOkUFR9XcipVuyCehyYsoto7LB6bhyNRdQA32R/s5RHuYgWDLgjhmBzAd1Cc9b+rB1Wksbfwv7+dCl8GiCUGddwVBXE5QzjeKk0mJjf0gW2OFcAAg1Xsb/YueE5vGAY+vUuxGvdiIWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fe3ysJFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fe3ysJFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DEFC4CEC3;
	Tue, 10 Sep 2024 10:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964458;
	bh=GS6yjkC7vGI2EbL57ftD/uCzoK9xia6+p86yOB9Xpn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fe3ysJFvz9cPfSBWwxD5OXaHz1bNrcEUsWoBMxwCwVKR2/KIb/9CY+voW6FwcqIDD
	 r/jD8d4nl3drxlrB4hKCWSwdee6x/zErmq4pDsHfOm1wwdZQW7R4xOwgy3+55Vh7A2
	 C753pxPPYrY4BMg6wFzxBrg4adi6xV+gLb/yBJuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/269] lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc()
Date: Tue, 10 Sep 2024 11:32:57 +0200
Message-ID: <20240910092614.892752960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7dfa88282b00..78f081d695d0 100644
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



