Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DF52D7380;
	Sat, 12 Sep 2026 10:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208150; cv=none; b=lAbCqX8nljkK+BtHLfDD49EquoM0JHzZBpUWopu5S7qhNkz/a/v+6zqcnIu3KFHSGhyvQrvcczTUo5DVPTGS/LKk0Q/L7I9vEUEbyRClsVGkTiulgSaEX0kR6IxOIkKUVCT0rDlfMBW9xAKChsVMQDbj7cNLq/4ySnpUz8NXGAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208150; c=relaxed/simple;
	bh=79hzkFmXP0sOztQy5B1a2oMVCWGwqbVkMhA1q6UF+CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPzwGbA3ehFHtyGAzokmzCWq3oNq93wW2gEsQ2QiWEmKnexJAYXTP42sdbMEoUNxHcpVVn5pwqfXaq57Bi8r14ogayl2TUvcHhM2H2Sc8ciW9eY2hEaj2RXGFz9hT59EfPZauogrp5m7b08dOLTMVDdiY8zTmNHN0JzXsA2vY80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AB2xcZC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AB2xcZC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F384C1F00893;
	Sat, 12 Sep 2026 10:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208148;
	bh=Aqp2jiKiCqlTp/QPMElUzG4KzFzejsPeIu5fEN26PTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AB2xcZC24fwVTqGY2NVAHCXh9Qh82sTH9+3LciS998tvGu+PENH3/U1xaIsUJ0M2h
	 R2TIR66GfePzaIkQ0vqqbdM2q4PJCi+grJpkAHcgYjSqEWruSqWEZWo9aCqpqAtx2E
	 a2OJH6H5QQKgIlGyYuj0q7UeNEWyETZzXWEcecXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Brian Geffon <bgeffon@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0560/1518] PM: hibernate: Fix memory leak in snapshot_write_next() error path
Date: Sat, 12 Sep 2026 08:45:29 +0200
Message-ID: <20260912065636.103262987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit 21d5c4cee31c5ce78f6decc7fafc7e7759af391f ]

When memory_bm_create() succeeds for copy_bm but fails for zero_bm,
the function returns without freeing the resources allocated for
copy_bm. This results in a memory leak that includes radix tree nodes,
zone structures, and page lists.

Fix this by calling memory_bm_free() to release copy_bm's resources
before returning the error code when zero_bm allocation fails.

Fixes: 005e8dddd497 ("PM: hibernate: don't store zero pages in the image file")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Link: https://patch.msgid.link/20260711145246.8625-1-malayarout91@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/snapshot.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index e249e5786fbcd..b691e2a047b57 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2798,9 +2798,10 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			return error;
 
 		error = memory_bm_create(&zero_bm, GFP_ATOMIC, PG_ANY);
-		if (error)
+		if (error) {
+			memory_bm_free(&copy_bm, PG_UNSAFE_CLEAR);
 			return error;
-
+		}
 		nr_zero_pages = 0;
 
 		hibernate_restore_protection_begin();
-- 
2.53.0



