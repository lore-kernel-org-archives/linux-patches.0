Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6504B19DFA6;
	Thu, 15 Aug 2024 13:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728519; cv=none; b=g0mLEu84BgqKyT5sJ42ly8+EGcFUGBIwtiExAivkhSBHe3I9CT8b6tp+jeD8gZvT1IrtzoTgAADlxjdV2FP8i3yHgUrwzUP5PBFJwxdX+cogCYZlFx3qtMG0pz7MZgJCh6S9mXdMq7Umk/GLbDy1eBvZdM//M6X+JGSNR4zw1mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728519; c=relaxed/simple;
	bh=s59+uAZWXV6ueUyW3Ngyd9LirQxdrF7rXZZpEMweW/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCyqocaoqSiLasytAyYRDA0dRhu91VhWrIdhBNdu9qT6e9BvlrlTPy3kqy+4wI3FEN+5TNyPmlaaxEEb5JcDq5qslESJdcwooaCFDVadaAa/Ul909wCOBFarlhvGRYpHsRFk73c9V/H6Jn46AAeX3x946aIAgxNp523bAS0Sf7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRhy+l4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRhy+l4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73A3C32786;
	Thu, 15 Aug 2024 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728519;
	bh=s59+uAZWXV6ueUyW3Ngyd9LirQxdrF7rXZZpEMweW/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRhy+l4BqwNDrnELFHvYehLRXdfNdfrOMPRNcIcdi023FvMz+NfmLUhhor+IF23mN
	 HMgBHrHxB/RSKklxvH+H17/T2mQ7yE0o2SZsRJux3wnG9ZpU+lxS0b1dgGbe9HD4ju
	 cJn8M6+OtLsINsdowfyjgb0wNYjBeSUYOE4XWRI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/196] perf: Fix perf_aux_size() for greater-than 32-bit size
Date: Thu, 15 Aug 2024 15:22:23 +0200
Message-ID: <20240815131853.088411972@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 3df94a5b1078dfe2b0c03f027d018800faf44c82 ]

perf_buffer->aux_nr_pages uses a 32-bit type, so a cast is needed to
calculate a 64-bit size.

Fixes: 45bfb2e50471 ("perf: Add AUX area to ring buffer for raw data streams")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240624201101.60186-5-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 8fc0ddc38cb69..a99713a883e9d 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -121,7 +121,7 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
 
 static inline unsigned long perf_aux_size(struct ring_buffer *rb)
 {
-	return rb->aux_nr_pages << PAGE_SHIFT;
+	return (unsigned long)rb->aux_nr_pages << PAGE_SHIFT;
 }
 
 #define __DEFINE_OUTPUT_COPY_BODY(advance_buf, memcpy_func, ...)	\
-- 
2.43.0



