Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEF420CCD8;
	Tue,  8 Apr 2025 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113462; cv=none; b=csNZBQ6nVQwJkHDKITgFZcqD4TCGeN8XNvER28KY2g/yWoO+Q40NG0skdXa+RRymq5ID2IISBvZpWPPmIuL/Oo/K0tIAy45igXxrLZygvIb+634rJzvSxdjf7CgXF/jwnGi6eIibzUo5GGHICjynp5pnz9EER3200L5+utEaW3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113462; c=relaxed/simple;
	bh=NuNJYyJam0EvmmUqmRDv/Eu9h4Nh/D3NEZX4YS3fl9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPW4R1j/+mdl7R/F/1btXpbcUgTUVv0MBizhUaDp2IeopNukRGdEsQ3Y19HZJgvuKwHSjhzTmrHPs7LVnhEYgYFlqIiKb9dv7S8DQcq4z3JHgh4yqMLQvux8HSdGE7wdZXDblCRX7WdNQIDXWt9YQifuY4tQKnJbIffFf4Ik4fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GvWhC2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GvWhC2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346DFC4CEE5;
	Tue,  8 Apr 2025 11:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113462;
	bh=NuNJYyJam0EvmmUqmRDv/Eu9h4Nh/D3NEZX4YS3fl9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GvWhC2SdIHbWFrZCw90Du13953HHwyJT4mdm5DayQDw2UXzZ2K1qS3/djvUocOcT
	 W8IHK1pEeZ0SEg9s6kENaKUun7hVSCCLhvsM0u4tuaThXaOXBIlm3E7k7hEShGNc56
	 vuKD7Nh0SZpcArCa4bqYbufIz+2uFyeEG2u/T7rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/268] ring-buffer: Fix bytes_dropped calculation issue
Date: Tue,  8 Apr 2025 12:49:22 +0200
Message-ID: <20250408104832.610698020@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index 61caff3d4091f..62d93db72b0a9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5995,9 +5995,9 @@ static __init int rb_write_something(struct rb_test_data *data, bool nested)
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



