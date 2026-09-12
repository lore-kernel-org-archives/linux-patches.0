Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B1334252D;
	Sat, 12 Sep 2026 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216141; cv=none; b=mLw8ifr0YhpxsnPUy7PnxPS9W/VFKrfY4qNLrE9HXPgeE/4mQSPLZJ+9TqHwo4A/165pD45zx3MLid7GHTYKMzsQAt1YiN3G6KNzkPv0XM6jcb/5sdH50B3+W9gtKI9tA2n83IwO6t3ULVMwMupKDcsZfc9CXEKqerhFpgeA7Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216141; c=relaxed/simple;
	bh=NEi2OHqUwjzURwfNZlraQ820yagQN2fLLmzlAyAowu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unBJxNIoDRc6rBqsxApxx53bQ2dverjTlW276/zwVRXDEbtQkBiVBupVF3v+6jobBJQGEoftB1RdekClXstu6WNl8QQCy4MUMfVSRWYqSWCA/ZUAuRYdVJnqG6G5ryYY+O5O2JHVPLoTlhrwC/1/sz2X1QK4SWSVMHj/ybX9tQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftxG7C8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftxG7C8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16A31F000FF;
	Sat, 12 Sep 2026 12:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216139;
	bh=82JtWm8Q9YfX3Kku6r0HRQ0qciWvWDFdtMTGsgOr31U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftxG7C8CWTaoNlqroFi1M060gSe5JLwS/5yFIYPbRzHUmPgIjQ4lQrTVd2BaczRVW
	 C8YyKLjgUooHG4Cia82d7D6WSlBfUJoFcPyQlJLIbT8WTNtpWVHC3WC7bFN/bqFg9m
	 /IokxiDqEwBgUXrAUaWd2YxFzKF/z4IyPkhCB67A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Brian Geffon <bgeffon@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0676/1376] PM: hibernate: Fix memory leak in snapshot_write_next() error path
Date: Sat, 12 Sep 2026 08:51:42 +0200
Message-ID: <20260912065622.613216035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c56b08121dbc5..38bab282d1b1f 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2803,9 +2803,10 @@ int snapshot_write_next(struct snapshot_handle *handle)
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



