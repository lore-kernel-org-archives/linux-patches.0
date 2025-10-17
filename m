Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9794C2F12A7;
	Fri, 17 Oct 2025 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713148; cv=none; b=YII0TXQvuxuE2twBkYAbgbc4lHEpGShIG/ET9/01sxVT6vZt0ttUMklgqwqwcUga50By+6ff1OXWCkkYrgK4c38vUJG0jd2ST3J/AWz9qVXadHTjsH9iKGyaIk247ikxelwmuFsOje51d6WCZNsAiPewc1M1vMK3o78A1IOHH/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713148; c=relaxed/simple;
	bh=8NTixbD231uBATNE8bmhi3mMzjretl9EXof1CPHYfnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBNsge91lH2v8D1b3AdE4/4njrDeOGvwgKJmKDCFz/E2jV74ij1hbSUo/gb7e3ACUftp7exhyo5XS0o+adS1EFvFHXYL73x/D3mkN3TXL4jxn6y/5dBH5VSdLbWM/D2w7nJnF6OWCsVteYHizG3mJwCq4zZkIe7Jwg8hV1Shafc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyfqNSet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyfqNSet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60F2C4CEE7;
	Fri, 17 Oct 2025 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713148;
	bh=8NTixbD231uBATNE8bmhi3mMzjretl9EXof1CPHYfnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyfqNSetgp76Pv5PUOyWvSb/PUhhZoalaYD+n7DZ0DhihDwYJQQZOhpYIeSyfToTX
	 CBo2YkpHhxprSaIBukN55vLzbjWsgl+f/6XSksWw0CJ/888h1Tn6+MAELWcnirU1iG
	 D/ru1NNb+OC/UJSplQ79ngtIn07sd0jjazsLjsyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Kepplinger-Novakovi=C4=87?= <martink@posteo.de>,
	Maud Spierings <maudspierings@gocontroll.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 065/168] media: mc: Fix MUST_CONNECT handling for pads with no links
Date: Fri, 17 Oct 2025 16:52:24 +0200
Message-ID: <20251017145131.420171511@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -665,7 +665,7 @@ done:
 		 * (already discovered through iterating over links) and pads
 		 * not internally connected.
 		 */
-		if (origin == local || !local->num_links ||
+		if (origin == local || local->num_links ||
 		    !media_entity_has_pad_interdep(origin->entity, origin->index,
 						   local->index))
 			continue;


