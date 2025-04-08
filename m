Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAC4269B0E;
	Tue,  8 Apr 2025 12:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114926; cv=none; b=UYakWt5g21uKyRn37aLLfZ8KrYgsi1fTYff7ucCKwGqUyFn4ZkuJTLcZT1fEOsTJnCf1JYbaJm1kILyZBWCXGeUuy1f9VzFZ2Dpky6DILdFHO2hBouVq3KVJXoi0TzixF+Cs/4xArZ/O/8uA6GlzgQWc0IQJyK2xg8Jtc5ci5eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114926; c=relaxed/simple;
	bh=EySJhAyWN02jZhszN3QjyB/D4+jo4x0nUAzBi65wew0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3vJ+rhrx/hQeGv2/k4aWH0XIk7Iqc/oF+P0DQSNUBYvMopU2htz6lvAjN5mmQFfQEmfMJ1TSEfvIZ1bvvBigTKys9kYuZ98jEM72TRXJ45ggOnIcR6Ncq2HRPgi1DqIIOxEBDInsgSfbgaj4Kz77Rsa86mrvSgXtiP/X8fbEaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRR/a0kG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRR/a0kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3659C4CEE5;
	Tue,  8 Apr 2025 12:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114926;
	bh=EySJhAyWN02jZhszN3QjyB/D4+jo4x0nUAzBi65wew0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRR/a0kGWbYAkkAZXHDhPcnc9VpPzzpCK2GxyAOWineFjzxVWwPArUgtTQAf/jubV
	 q4Zq5VluIkhOA76ak3FiW8FwHge3i9GIxtrnPp6xGQABTtXvGb15AOznB5J7TQNoAI
	 Fh/zB3miKGn3Pa54GXSuiw6O3ni2ICYJ4MsBjrcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 285/499] ring-buffer: Fix bytes_dropped calculation issue
Date: Tue,  8 Apr 2025 12:48:17 +0200
Message-ID: <20250408104858.325211948@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 2bbc96568a2b9..fb954a8b7a8b1 100644
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



