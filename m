Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79EA69D21;
	Wed, 21 Feb 2024 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522222; cv=none; b=iALKC16HjgponEnF3x2is4gzoCmlCS1OIsNnvTpCV769cG/Av5ogyDYTTijthxCfhHumxXW31gRkR1AYFBrghAGJ8viLhgr1lX9q9bJeNt2uNTF2gYEgy76OEz+DNdM0c3IZ/Ovy1lDe142AprSpFJJwKUoR1Vu0S02cTM/g/XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522222; c=relaxed/simple;
	bh=9BH6p6m6Yq6o8zXkTh+PcUk3TAPCGDRxvSe78PxsrnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJsOaA6rFlkMwljYXyB3l6QUxQZ8R580e0dEp/+REYxdom1lxmtTc0kB3h6n2E47vxZi0Dtde11zNVDOb8jXTnFPZV4JaxCN5sK885aNYAjB1i0fr8WGhipS09Ux+v1572b5O6f5Iy7se2iXsFR7lrhP4Socs6CDPC8g7yf1sJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5VbmEo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5VbmEo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B5FC433F1;
	Wed, 21 Feb 2024 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522221;
	bh=9BH6p6m6Yq6o8zXkTh+PcUk3TAPCGDRxvSe78PxsrnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5VbmEo5IJfLoWOnuuCXr2cYgZm8OdQCy/hlKNPgdvASWQJ2cUwRNtBDOwElZGIpS
	 /giCUf//7rCXEUA7HuSb0PzusWrcE6NcUFJ7igYQOCh3VXXZfcQFKKXedTsDBHdqB6
	 qjM8mxxBvTDOxH1wFB3kEy/CadiFHyUbAFFQD7qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rolf Eike Beer <eb@emlix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/476] mm: use __pfn_to_section() instead of open coding it
Date: Wed, 21 Feb 2024 14:02:38 +0100
Message-ID: <20240221130011.918758480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rolf Eike Beer <eb@emlix.com>

[ Upstream commit f1dc0db296bd25960273649fc6ef2ecbf5aaa0e0 ]

It is defined in the same file just a few lines above.

Link: https://lkml.kernel.org/r/4598487.Rc0NezkW7i@mobilepool36.emlix.com
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmzone.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6ba100216530..9e1485083398 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1493,7 +1493,7 @@ static inline int pfn_valid(unsigned long pfn)
 
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	ms = __nr_to_section(pfn_to_section_nr(pfn));
+	ms = __pfn_to_section(pfn);
 	if (!valid_section(ms))
 		return 0;
 	/*
@@ -1508,7 +1508,7 @@ static inline int pfn_in_present_section(unsigned long pfn)
 {
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	return present_section(__nr_to_section(pfn_to_section_nr(pfn)));
+	return present_section(__pfn_to_section(pfn));
 }
 
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
-- 
2.43.0



