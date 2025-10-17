Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1CF2F12D2;
	Fri, 17 Oct 2025 15:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715310; cv=none; b=tXqYjTWY5CoHe4SCto0VXkvCWQEnAGY6FfqFnn0/0yk3mH2egOSXFs2atPMKHorNffk/xNJRMJe/6Ysf/tjqA+F9N6CWaSC1UefxbYq5h3HaSip2pZ0BxY5vQUqPj6O/Sd/WYTp6+GYFlK5yl9S8COELERLccZrpjD3h/O177qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715310; c=relaxed/simple;
	bh=QwGCUbYA1GGMuuu2m6o4+5W0u5aitfUUpfeqZK727y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QP7rQpWv0vRNT8dzneMYVBAdbcYTuEKsYZgfiTF8qcan0Pt9JLwsDSVasH7wifI842G+5XyuQhs5sZq+Ow+vmWS7sWw0uChbSfjYUazIHhx3S5KDmuO+fev3SjsVCExR/ZNSIBLTdpS8N1v5v8dSavJO4lSV9iryCP94RZb9kuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KLSUuqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KLSUuqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB185C4CEE7;
	Fri, 17 Oct 2025 15:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715310;
	bh=QwGCUbYA1GGMuuu2m6o4+5W0u5aitfUUpfeqZK727y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KLSUuqKGDgU8J+K5JZQX1XTLv0WNr+F7PiqQCJhbgPAC3YqH2P3isYXr1ik8BpXf
	 LI54vy6RzHveG4axBLiZS4DSeRRlR03C60Ho5luwlXE5Y6TXDVzuwzNG0eQWN+vLzg
	 Njaar1puSH0xqfQaMVmvk8sgKYiSgevtoKp2rJDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Kepplinger-Novakovi=C4=87?= <martink@posteo.de>,
	Maud Spierings <maudspierings@gocontroll.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 172/371] media: mc: Fix MUST_CONNECT handling for pads with no links
Date: Fri, 17 Oct 2025 16:52:27 +0200
Message-ID: <20251017145208.152203548@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit eec81250219a209b863f11d02128ec1dd8e20877 upstream.

Commit b3decc5ce7d7 ("media: mc: Expand MUST_CONNECT flag to always
require an enabled link") expanded the meaning of the MUST_CONNECT flag
to require an enabled link in all cases. To do so, the link exploration
code was expanded to cover unconnected pads, in order to reject those
that have the MUST_CONNECT flag set. The implementation was however
incorrect, ignoring unconnected pads instead of ignoring connected pads.
Fix it.

Reported-by: Martin Kepplinger-Novaković <martink@posteo.de>
Closes: https://lore.kernel.org/linux-media/20250205172957.182362-1-martink@posteo.de
Reported-by: Maud Spierings <maudspierings@gocontroll.com>
Closes: https://lore.kernel.org/linux-media/20250818-imx8_isi-v1-1-e9cfe994c435@gocontroll.com
Fixes: b3decc5ce7d7 ("media: mc: Expand MUST_CONNECT flag to always require an enabled link")
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Maud Spierings <maudspierings@gocontroll.com>
Tested-by: Martin Kepplinger-Novaković <martink@posteo.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/mc/mc-entity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -691,7 +691,7 @@ done:
 		 * (already discovered through iterating over links) and pads
 		 * not internally connected.
 		 */
-		if (origin == local || !local->num_links ||
+		if (origin == local || local->num_links ||
 		    !media_entity_has_pad_interdep(origin->entity, origin->index,
 						   local->index))
 			continue;


