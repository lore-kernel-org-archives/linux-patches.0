Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4631934A79D;
	Sat, 12 Sep 2026 07:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198817; cv=none; b=GkTDj4l0NJ9ceAIvUv78gpiiFNcPRUhRs6B7fqRZ+9ggtLaNC6a9awYfcbVXoYU+Zmocb/6ykz7/IR3t+mJkRt8MZlJDm1zEhxZAlFXnPib0j6MT+qRq/eClldh/DbM0lARuqvg2eehF25WPqm/D+5Ay8pKFGddQez436xwrXTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198817; c=relaxed/simple;
	bh=qYlgc+KU/CpIRmY6Dgkb8yzOk+w3DQfNovet1kQOJyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHrv2hl1du7uk4opp7rhv5AtLRZ4IvJh687pevPe+fRlEYkdJvjdB9qvbM18/arZ3qBShWQ9ExAKvXFFW+yXnw1P4IFa0MK2CLC6T/rMsX+6jZqUV+KxN9SfG5VP1dmo6Gymvw3RgsoxTdiHSv2vyat3XGPmehom4p5uWC8pSOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwjFH/Ec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwjFH/Ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DB61F000FF;
	Sat, 12 Sep 2026 07:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198816;
	bh=IgloYmEZioh/Ty+7eyfC6w8Lb/gNPizjk8zbq4rR1zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UwjFH/Ecc7Io1Elc+H04AK2U9ZTqMERMAEj3VbHaGtq4Mb4v8/sQcjay86/EIvEwo
	 /5LqZfRnbPIacghjpOkueh2fe+5TZJHGjqWeDoEMJOQhV4aMouymvKnIBIUJapCe0o
	 cjPPRKrFLYf4XC3lJekNfSk/HdKotIwPqUwfF9R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <john@groves.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0415/1815] dax: fix misleading comment about share/index union in dax_folio_reset_order()
Date: Sat, 12 Sep 2026 08:36:05 +0200
Message-ID: <20260912065658.635571760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Groves <John@Groves.net>

[ Upstream commit 3fc3ebf40b5cf077829d8fc5c66ece5b4c6e66c7 ]

The comment in dax_folio_reset_order() claims that DAX maintains an
invariant where folio->share != 0 only when folio->mapping == NULL,
implying folio->share is zero whenever mapping is non-NULL. This is
misleading because folio->share and folio->index are a union -- for
non-shared folios with mapping != NULL, reading folio->share returns
the file page offset (folio->index), which is typically non-zero.

Reword the comment to accurately describe the union aliasing: the
assignment clears whichever interpretation of the union word is active
(index for non-shared folios, share for shared folios), which is correct
because the folio is being released in either case.

No functional change -- the code was already correct, only the
justification was wrong.

Fixes: 59eb73b98ae0b ("dax: Factor out dax_folio_reset_order() helper")

Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
Link: https://patch.msgid.link/0100019ecc08b8cd-4ee80eeb-1341-4f67-8478-7298129440e9-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99b..df19c9317d10e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -392,12 +392,12 @@ int dax_folio_reset_order(struct folio *folio)
 	int order = folio_order(folio);
 
 	/*
-	 * DAX maintains the invariant that folio->share != 0 only when
-	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
-	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
-	 * Callers ensure share has been decremented to zero before
-	 * calling here, so unconditionally clearing both fields is
-	 * correct.
+	 * Clear the mapping and the index/share union word. folio->share
+	 * and folio->index occupy the same union in struct folio. For
+	 * non-shared folios (mapping != NULL), the union holds folio->index
+	 * (file page offset); for shared folios (mapping == NULL), it holds
+	 * folio->share (reference count). Either way, we are releasing the
+	 * folio and both fields should be zeroed.
 	 */
 	folio->mapping = NULL;
 	folio->share = 0;
-- 
2.53.0



