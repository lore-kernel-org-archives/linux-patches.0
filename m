Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEDD20A5C3;
	Tue,  8 Apr 2025 12:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116704; cv=none; b=VslhtG7B0nZmRtRSWF25cqMLW9xRblPJUvEBbSPTKD1cMGHAs0WNdl2wur7/6VbLo8DKsWciX3U+IA8F2Mo25B9qDyM3k/OM46XQ6aKSYBPSzmqzlVfd/MCS4nGz+bcpKKidrTYLpWiRnXeb9bo2wHZXsAPLepCEdSJMRQXuy8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116704; c=relaxed/simple;
	bh=1/HxVuoe1tLjMzLI/Wwj8NKUigYMSVzY+AghLZ1h+dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN3iAbNuZZMTWaKDXwNY/RoPYAgUrfqwDeD1Jj0hSKfEkRQ5Ph7UjmXVWs1LOWN/51bWY8hu1ONde/oMwoetYSnUOeRzFW2awuxNeLSsLgfO2RzPywkBjuzXKh91TQeUjFTx2EsSPCxQDY2AzF923sVLn/beecI352NXJtDBRoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JW+MZWOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JW+MZWOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A60CC4CEE5;
	Tue,  8 Apr 2025 12:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116704;
	bh=1/HxVuoe1tLjMzLI/Wwj8NKUigYMSVzY+AghLZ1h+dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JW+MZWOegBY+82m/FL5yxwDGK3tsoTrBo0KdA//DBBYzATmYfF8wxs+12l4mQVOad
	 nt8ZTSmbizzlhmDA5FzIjZVgqUFRlrggDNOtcNGKEnFFA93aQYPfcRIf0amvi04gME
	 L1FBrncrY4G275rNfGgDm1pu2J+KP9m1OFWsS6Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/423] ring-buffer: Fix bytes_dropped calculation issue
Date: Tue,  8 Apr 2025 12:49:24 +0200
Message-ID: <20250408104851.269150826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit c73f0b69648501978e8b3e8fa7eef7f4197d0481 ]

The calculation of bytes-dropped and bytes_dropped_nested is reversed.
Although it does not affect the final calculation of total_dropped,
it should still be modified.

Link: https://lore.kernel.org/20250223070106.6781-1-yangfeng59949@163.com
Fixes: 6c43e554a2a5 ("ring-buffer: Add ring buffer startup selftest")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ea8ad5480e286..3e252ba16d5c6 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7442,9 +7442,9 @@ static __init int rb_write_something(struct rb_test_data *data, bool nested)
 		/* Ignore dropped events before test starts. */
 		if (started) {
 			if (nested)
-				data->bytes_dropped += len;
-			else
 				data->bytes_dropped_nested += len;
+			else
+				data->bytes_dropped += len;
 		}
 		return len;
 	}
-- 
2.39.5



