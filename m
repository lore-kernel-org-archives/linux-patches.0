Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C868D1E98EA;
	Wed, 15 Jan 2025 10:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938502; cv=none; b=PZiE0eKp9GlAGQTrwez9YBykmCMLb3aVZ4+E3qtcGpXKwhJWTJfrw8pSFYQOUzb6Wikd1bP4Wh17Nenln/kv4xJg4D9t2M1gva2a/ZWGC0yCO8CReA2XSHijICYM8PvwFL3DODii1YrPiJbUxtXqJWtUkbeba0w75Sm51wTgF7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938502; c=relaxed/simple;
	bh=pzNtzX83mi0JVvz4Ga7AQGLRsUL0pR5/FmpHvJN8/Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3dfYqtrhj8q/Hq3lgWp3YxBmjW6TSXfZisGikIZXhyfgbNSpJScqvRgFeGp7ItUSWyUANARYRButj3Ci+b4nzQ+WTYJNXrj+etr1pXzwc7bdGe55/xJcs6VtdyRt2br+yIVYvV1HjkjLNk3g7Uy6g36B4qEdNGa58Yv5xWZ+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSmBudnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSmBudnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F4BC4CEDF;
	Wed, 15 Jan 2025 10:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938502;
	bh=pzNtzX83mi0JVvz4Ga7AQGLRsUL0pR5/FmpHvJN8/Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSmBudnSQJ9QpgKgztL+N3i9Al8wVWad8XmHXGHMbEBvelThOvhE3d6RE7UUz2Eai
	 yqFMjrr2WombCOPnpQNpHVyRfR4qs9pNKAjYrhn/ti8pZdIsgK0PgObVgvFsxHxtx5
	 vLrkTiDI125whayVlVrHKtRFZ+Y5x2bnbeZOjp7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/129] jbd2: increase IO priority for writing revoke records
Date: Wed, 15 Jan 2025 11:36:18 +0100
Message-ID: <20250115103554.499797469@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit ac1e21bd8c883aeac2f1835fc93b39c1e6838b35 ]

Commit '6a3afb6ac6df ("jbd2: increase the journal IO's priority")'
increases the priority of journal I/O by marking I/O with the
JBD2_JOURNAL_REQ_FLAGS. However, that commit missed the revoke buffers,
so also addresses that kind of I/Os.

Fixes: 6a3afb6ac6df ("jbd2: increase the journal IO's priority")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20241203014407.805916-2-yi.zhang@huaweicloud.com
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/revoke.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 4556e4689024..ce63d5fde9c3 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -654,7 +654,7 @@ static void flush_descriptor(journal_t *journal,
 	set_buffer_jwrite(descriptor);
 	BUFFER_TRACE(descriptor, "write");
 	set_buffer_dirty(descriptor);
-	write_dirty_buffer(descriptor, REQ_SYNC);
+	write_dirty_buffer(descriptor, JBD2_JOURNAL_REQ_FLAGS);
 }
 #endif
 
-- 
2.39.5



