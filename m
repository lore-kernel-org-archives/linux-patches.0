Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D323189537;
	Tue, 30 Jul 2024 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355609; cv=none; b=sj+EMzFZn4o3uklVe1V99LEK/s4j3FuH3/ZYIyfV4Us5OaprMpgULaweYpurBnOI05wq0ScPw4GURhgf/FN25hf1rwnT77NzzDnHFnx59paK/uQHB/N7kvHIA+YzC/SIkoS51DIzhzZPtMmrARepQZIYPYN41WqGgmsszz1ba30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355609; c=relaxed/simple;
	bh=mKhdRgUcUuft6fmIvcfHN9kbSxVWAVMG+HsGXFCN85s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6ywHJeITVg9GhVlKHJ9RueymSpobofsI/F4Y6ixzrA2Z5OYh+UzTsX+BVLP7M0+ytV2G42KZX6tJ5yErJ1BE32aZvIEPn5NxU87tW3WEkn7IhCFXCWujn9g9/8HxQ+5Zt2S00CrrI66Mv2AUnydImYxkELAgoKyRz6WJjhcAkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbKXk542; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbKXk542"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D0DC32782;
	Tue, 30 Jul 2024 16:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355609;
	bh=mKhdRgUcUuft6fmIvcfHN9kbSxVWAVMG+HsGXFCN85s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbKXk542BsezTXXi7YNY7hwSTEyDXOD0toWXyQ2o89z8GY+vbaaE3zc82B4RPaWk1
	 MStQBxjVQNJHeJhJoHN08/AHKu5w4GKsGQDkxz3DzASI5WgOtGOuyhCzMgrYZR5NvV
	 yCfb64D7V9rln5jZOrnRexGPlxMUHVwqQltiwNx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/440] perf: Fix perf_aux_size() for greater-than 32-bit size
Date: Tue, 30 Jul 2024 17:45:43 +0200
Message-ID: <20240730151620.189399424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5150d5f84c033..386d21c7edfa0 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -128,7 +128,7 @@ static inline unsigned long perf_data_size(struct perf_buffer *rb)
 
 static inline unsigned long perf_aux_size(struct perf_buffer *rb)
 {
-	return rb->aux_nr_pages << PAGE_SHIFT;
+	return (unsigned long)rb->aux_nr_pages << PAGE_SHIFT;
 }
 
 #define __DEFINE_OUTPUT_COPY_BODY(advance_buf, memcpy_func, ...)	\
-- 
2.43.0



