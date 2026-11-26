Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704511;
	b=B/6nxqMmRDX2mRVpaiwA7If48UC5AXhEG/eVbQaT3I943pjoiZx4Txmnc+tyZxah/pfv
	 AmIITB8Kg/GIg2WkJUGR+fdBC4DAUYPPOJSKq42TV6ja2Q7eVaz8IK9QlYV125YxgAwhr
	 IheuCx8kw850avR+qD1FzXV/6yf+kAITNEqDTTxiE9g2dLEkFWmdnqQOwK5gnUoiX/qlc
	 7sQPZqpe4R+A8rC8a3HMTBP+/g3ZnGaYbohcSyNxMAbd/NGhYzf1Ij9OhA2Cx0ImFKADe
	 zK5DTtDzuv7b3ke4NY4O/pTyNT5b+cc4XSAYMdIv+BbChc0CuClrvodA98B+jy2y3oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dof/6HCBSFUvI1LhRimxyXGmJwX0BcpaQhd2T6gqjDY=;
	b=Q1kzrQAw5J3gZPdkjyfGUPAZZlGrIinlGLNQEz4u0UQY91tVldKsXYsdB1ma9knEAfmz
	 s/pAPvMk7xEY73ZjE9IqPtzvxAlCAtL0QNDYBMR9sFHqpcNXdjsrgfyW4Z9175OrreLUT
	 HpdB2S1NYAu5GPQsUwJsZCniSVcE0Zq6X8n2X0gJW7/IVcwD8Ss1JHgi513pVxC7qW9oz
	 fbo3wDpTPEc57RCvSpX8LT2oKXFSjskkNUJQhnJ+4wJgqhNWv6F5RbQ0etGZhj7Lv2yjG
	 ZgpVQS9yujHrj+LNRonarBtJthUB8gZBmScrOBvpDPbEEnoG+vqrvnu3CATzol355+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRnXO4l9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F24E606A336;
	Thu, 26 Nov 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRnXO4l9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14471F00ADE;
	Thu, 26 Nov 2026 14:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704511;
	bh=dof/6HCBSFUvI1LhRimxyXGmJwX0BcpaQhd2T6gqjDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRnXO4l9RBGUPBlwm6Qg8jXQK4dvVNZrBfHVmXxSGFKXazch9NEk46KXlhPWrb99E
	 cYFN7IqoQr/Unfxvf1Pp4iwU6X03zXwnNrtmgSBhsETgF3NRUO/+8+M9GOT7AJqjT+
	 LeyUpJGjlJKQiGkq5fHLp8/UWNzZOYqHH+/0gpkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 5.10 151/265] mm/mmzone: read the zoneref slot once in zonelist_zone()
Date: Thu, 26 Nov 2026 15:38:01 +0100
Message-ID: <20261126143615.624218594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price (Meta) <gourry@gourry.net>

commit 9c52ebe9c89d41c56fcb5d94efe9e539414175a9 upstream.

Memory hotplug rebuilds zonelists in place while allocations walk them,
so a zoneref slot can change between two loads of it.

zonelist_zone() loads the slot with a plain access.  The compiler may
load it again later instead of keeping the zone it already read, so a
caller can check one zone and then use another, or the NULL terminator.

Use READ_ONCE().  Callers that take a zone from a slot and keep using
it, such as get_page_from_freelist() with ac->preferred_zoneref, need
that single load.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261101021340.2251928-6-gourry@gourry.net
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmzone.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1030,7 +1030,8 @@ extern struct zone *next_zone(struct zon
 
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
-	return zoneref->zone;
+	/* Memory hotplug rewrites zonelists in place. */
+	return READ_ONCE(zoneref->zone);
 }
 
 static inline int zonelist_zone_idx(struct zoneref *zoneref)


