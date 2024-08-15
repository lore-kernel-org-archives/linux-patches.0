Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A181AED5A;
	Thu, 15 Aug 2024 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731161; cv=none; b=sWKBJJe1wxi8q3KAOJ7CZ9kzRuXMZE2xtr++ZFl9MVr1M6374XqKhMo4lxTu8/VOzSn+dlXNkQ9+ntjEL5N9a9Nh2DouTOWctddRlY/4E55muMYtJlEL+QXXTwp01E0gs1rnXPci+iDSn+XKOnTR/zRmikHvWWEuz70zNYYdBGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731161; c=relaxed/simple;
	bh=oS4Vy+nfgFd1W4krWlU72fbkfxRZnCe25VEAbNR36LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+f//tKSt60+fYqJTu3ywKAwd0jWlzk4uW5e1hG2W1Y89gW17AjB9isTfZXjtTauLhQALAYmKma42KW6uNE2Vd/tFHJPRAPIf1z124FiwO+GKA3mqqYYS7ukNXRQUdczZf2x3W3sMnXIcxxwMyOmZxgZ5+GLaiDypTDHcIZBM2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUpllnre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUpllnre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA6CC32786;
	Thu, 15 Aug 2024 14:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731160;
	bh=oS4Vy+nfgFd1W4krWlU72fbkfxRZnCe25VEAbNR36LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUpllnreAfouSAVzKh2kakysSlLeu45EPSveIJBqbH4anRlRnOSbDn80NcN4Kl/P9
	 XEr9v5Mw7UIza/jhS1jQFL8DZdXVyrDIM2WBpc+5L1CHbmynAprPr48e8sUmW95YBC
	 g6JaDW4It2KchXhH5G8LxGMPG6yhS3oZJr9JK2a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/259] perf: Fix perf_aux_size() for greater-than 32-bit size
Date: Thu, 15 Aug 2024 15:22:55 +0200
Message-ID: <20240815131904.427407808@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6e87b358e0826..30218d7c74e66 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -122,7 +122,7 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
 
 static inline unsigned long perf_aux_size(struct ring_buffer *rb)
 {
-	return rb->aux_nr_pages << PAGE_SHIFT;
+	return (unsigned long)rb->aux_nr_pages << PAGE_SHIFT;
 }
 
 #define __DEFINE_OUTPUT_COPY_BODY(advance_buf, memcpy_func, ...)	\
-- 
2.43.0



