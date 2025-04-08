Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827E41AAA0F;
	Tue,  8 Apr 2025 11:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112835; cv=none; b=MPUip+fRv30qHGhOigoXv+RKkSLqaXRSOpDksljXP4w+IX4z53A0h4U7RgUspGhGYJKn4AbDTNAvP1wy+GxxxH62v7SguorWPic0UlIt1N4ebUxI9MYXY04sJDhv9uBN1bK8EneYw5A+Q+9uzrMjdGUYaKk0+7tCJS4LfdX2/y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112835; c=relaxed/simple;
	bh=jVIh62XSwGHtxEuL/56k9RN8BLLNQw0LQLUVWYO/rUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oz41SSV1C9b5snVSPt3nhBaCaNs18n8bpaLMyPWfj/eJHsvam3cgjEh27JnDZxFY3Q9j/V5/UQBXUe6uTu2WHtSrAPInm+lsZ2PTmQ47Y8HiFFgr2KZ7NqQnbdSaxSSiGBn01dRSw4z4FsDrX16DM5E2qAoPqYK30B6VgnGEZro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOpkxnrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOpkxnrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1516FC4CEE5;
	Tue,  8 Apr 2025 11:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112835;
	bh=jVIh62XSwGHtxEuL/56k9RN8BLLNQw0LQLUVWYO/rUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOpkxnrZVfRh8H58++ezpedjePWURJ+FdNiLolTZh3+G7w5nDBS08gqIDB3uhzftY
	 IClUVg3/t5RYPw0a1vT2G4c0M1JRn8WinzwWiXwZzpmAHVH42xE1vPFmbtGutn1SxR
	 Tt6z3SGgGCvDoR4kRB53sJFmhel+fEOFNMuYffIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 216/279] ring-buffer: Fix bytes_dropped calculation issue
Date: Tue,  8 Apr 2025 12:49:59 +0200
Message-ID: <20250408104832.184328773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f9f0c198cb43c..90a8dd91e2eb0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5949,9 +5949,9 @@ static __init int rb_write_something(struct rb_test_data *data, bool nested)
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



