Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E1A3370F7;
	Fri, 17 Oct 2025 15:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714421; cv=none; b=pMBgjaEZpD1Q4CLKhVlrzrRmt9bSKoVE3n8rK+Wss5qaAvGE7J8qH+HKXnh/RNJBhf6KKe3UlsS2gfe+8CILp/cC05rzxNCJgVRSYbKuvBdRLgdvgnR7ci9yaAKx0fqOAjxuJe4yd9EQulecBgnZOb/oKVXWwOjSH4K8gotiGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714421; c=relaxed/simple;
	bh=i815xBWBD8jginWV4FswiuwiemGNqHTQ7nw+0h+GSWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HUCuR1RSoXQzpZCQ6VP87K0C7XryJoPdrf8cOkYNJs/9aOrqhTcwfs+OKlJnePtDFRSGIOq9v4+rGAGa/cqUPTw+XnhkDq/CWVjYgidBYT1xTVQBvpAF6Gb40gvnkvIaSfp4fkTfpbrO3m8oaGzgR/CDGgePOFrFG5gOcG66F7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZQ31Ntb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZQ31Ntb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1978AC4CEE7;
	Fri, 17 Oct 2025 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714421;
	bh=i815xBWBD8jginWV4FswiuwiemGNqHTQ7nw+0h+GSWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZQ31NtbkHtU220uReS3tf+zo8HJCUkS+eZz2hV+eedjtHwD7mWWbLHUSjUGjFlKu
	 W4nKeg7+csB5Ond5MaUwiDJ+xR5KNYvuHFdP8kpyROY3ySCIXb6Jry/nyL10GJVyyk
	 ECuwOmzHLbFxMLYqNCw1QqW26Fke4quWoT8XlqL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Kepplinger-Novakovi=C4=87?= <martink@posteo.de>,
	Maud Spierings <maudspierings@gocontroll.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 106/277] media: mc: Fix MUST_CONNECT handling for pads with no links
Date: Fri, 17 Oct 2025 16:51:53 +0200
Message-ID: <20251017145150.999563193@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


