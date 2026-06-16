Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C8E37C912;
	Tue, 16 Jun 2026 15:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625310; cv=none; b=R6BZFECET1ppF9VCBY5YfpThKOB9VHeMO3ZRPSuezPOm2KKr06R4K2JFDEaGkOJ2fdFT4tVpRxu7/jrWljnPht3TW8T8uAzWWfQ3ROae4mxNPkRzvBi5muv/d1MouCxVtDc9A48QcWhYH0oXb42tqWJl7WmqSLsK4E+zrozPiXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625310; c=relaxed/simple;
	bh=TMfacGjU1xSp6Bq9Yu/iBtXjJ4PEdvxPHKUvpPMttH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWYC3orvu9rFMGEwFIeHFyN+FNZ5Nhdow8ObGY+ChfhdfIaRi63pkrZEgbqQJ/dcZPpPM2jMT3+8EhbOijEa3yP58hABUBnuRSMnapaxA331bcuxx1HBQpPm2649NxoeRqVy3hqXEt0f9hgpmWPHzR7SFEt2dQLE9FB1+GO9ucs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+etDSrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+etDSrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4451F000E9;
	Tue, 16 Jun 2026 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625309;
	bh=H+hXO1212TCNSef5GeYVhSKLcOb1ynPJ507YonxZ2EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+etDSrTp0066DMf7MS5CX9mEV2OBAb4wWtPIwQgkPML2slX30I2DDyav56Sda8r9
	 zDwyA6M9kLKFUE0NDaTLZ7LC3Gok6ueFndKOus7aNP9ZRdz7oGmyKcLWbc755kSeeG
	 YHBuj1SSJ5JpHz0Qn1hK2wCTBlPIoggm5j605vt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/325] verification/rvgen: Fix ltl2k writing True as a literal
Date: Tue, 16 Jun 2026 20:28:00 +0530
Message-ID: <20260616145101.904258908@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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



