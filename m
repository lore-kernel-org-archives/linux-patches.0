Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE93F43C05C;
	Tue, 16 Jun 2026 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623144; cv=none; b=uJf9hntdSa1EXzhWYNkU1+gapmTGU3jGPfXqejKvh4YZzIZoRLQmUBQY1fxmE5vbCf5rr10CyRHEM1dRtFzdaKKmbTyR3WmyntgeogIWJ+Nf6CbOxWpM9vEAuUDpbwboTbbrxXDAawNgNPQyBalEGZ3xKqPM8EuXUWS9Me7dcas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623144; c=relaxed/simple;
	bh=pFz25esQru+2zYgtdSWBDAZrYgPsCkcLZ2Wa44RRsn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLWbDhu2B9l4e8NJoFZ2nZKRn7Tq9IKlBz4Ie52tZbMYxBWqWnS5Fsuf/mpRavyEF85bBnzgOvH0bhQfTHtSb7bKYjbez171CmN3xcTzW3XLnGg9Z2V+BFWK4czK430vJB1S0yHwpgiWU6UMPGWjBOg/QD3e0rxmuMmOfNYWUFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twsS4onr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twsS4onr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AF51F000E9;
	Tue, 16 Jun 2026 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623143;
	bh=tu08nH1X7DXQArVZZgn0bAPRnoSjW7jrDMdail15UnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twsS4onrGxpa+gHpu0YxnMJKLhsd+klIr+blA+30wxE+qvoreMNYhwCtBBCqXNakH
	 /VLj8KDTHzcqzt0MhUw7feGsKPIxjInc9l5FVXzVUmSgu0kLAzpz9FWKxkYL0imJfF
	 PcRE6/mdf3Bqs3vG46Sda/2S9SNtRVX9MHFHv6Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 095/378] verification/rvgen: Fix ltl2k writing True as a literal
Date: Tue, 16 Jun 2026 20:25:26 +0530
Message-ID: <20260616145115.292148638@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit df996599cc69a9b74ff437c67751cf8a61f62e39 ]

The rvgen parser for LTL stores literal true values in the python
representation (capitalised True), this doesn't build in C.
The Literal class should already handle this case but ASTNode skips its
strigification method and converts the value (true/false) directly.

Fix by delegating ASTNode stringification to the Literal and Variable
classes instead of bypassing them.

Fixes: 97ffa4ce6ab32 ("verification/rvgen: Add support for linear temporal logic")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20260514152055.229162-8-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rvgen/rvgen/ltl2ba.py | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/verification/rvgen/rvgen/ltl2ba.py b/tools/verification/rvgen/rvgen/ltl2ba.py
index f14e6760ac3db8..aada15ec83a3c2 100644
--- a/tools/verification/rvgen/rvgen/ltl2ba.py
+++ b/tools/verification/rvgen/rvgen/ltl2ba.py
@@ -121,10 +121,8 @@ class ASTNode:
         return self.op.expand(self, node, node_set)
 
     def __str__(self):
-        if isinstance(self.op, Literal):
-            return str(self.op.value)
-        if isinstance(self.op, Variable):
-            return self.op.name.lower()
+        if isinstance(self.op, (Literal, Variable)):
+            return str(self.op)
         return "val" + str(self.id)
 
     def normalize(self):
@@ -381,6 +379,9 @@ class Variable:
     def __iter__(self):
         yield from ()
 
+    def __str__(self):
+        return self.name.lower()
+
     def negate(self):
         new = ASTNode(self)
         return NotOp(new)
-- 
2.53.0



