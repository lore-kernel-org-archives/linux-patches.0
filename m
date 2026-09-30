Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E4A5187EF;
	Wed, 30 Sep 2026 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788008; cv=none; b=aFSTU6l2JpxsBTBc+pox7i225Gr4uQ06k+rSroEOtVZlRtVaD4WHjwHePt+ouOP5qnxwC+BSNRHySFEcYvruwNCo7um63jJtK80kcvVGR2RUufltxBHtGZtqVKnqzshS8NxRqiEoqozisImAB6RBM/AsU4iin5IBfFLl2RxiVfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788008; c=relaxed/simple;
	bh=Z8fyHyR3YPW5/TBcg+2BN26f+k9JNG1Skp8sBkQhE9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDAE5o4NcrZp5D1ykqp0QhrJE8b8ZWL4OGmAdMwtI64YeaiIUENYqIQcK9+dbrrE3rOdgGm7ZT8WDRhpP5wwoVeVevNeMh8CltWdan7hs3xQtEWcDemtmLKUszHaIgnD3gCzI+YYByIYjsZUtjJb2ep203IzQv7SRN56JJ/G54w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxNV5USC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxNV5USC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F121F000FF;
	Wed, 30 Sep 2026 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788007;
	bh=qpGmsN0F8qXqiRVdvOdehDbuLa0nOwQuruhwn+i3pSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxNV5USCE5RuOWfxw22ofBrB6uECb/W92AObURfphJGciGePBCOc6fi/rfxMiGxHP
	 nNld2YVp1cyitr/ukZm60JnLfPtlXV3Pa0x61lG95US62p0hdVbMU4l4Q9N5tpXESP
	 aW3u8mPPELOm5lJZtZeDMRDh9dGYh5QE02cdr1EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 430/457] xfs: dont merge different file IO error types
Date: Wed, 30 Sep 2026 17:28:55 +0200
Message-ID: <20260930152355.271081575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit d80993655f7be2a461c0a63e2022da5757f47dac upstream.

LOLLM noticed that we can accidentally merge file range health
monitoring events even if they have different errors.  We shouldn't do
that.

Cc: stable@vger.kernel.org # v7.0
Fixes: dfa8bad3a8796c ("xfs: convey file I/O errors to the health monitor")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_healthmon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -245,7 +245,9 @@ xfs_healthmon_merge_events(
 	case XFS_HEALTHMON_DIOWRITE:
 	case XFS_HEALTHMON_DATALOST:
 		/* logically adjacent file ranges can merge */
-		if (existing->fino != new->fino || existing->fgen != new->fgen)
+		if (existing->fino != new->fino ||
+		    existing->fgen != new->fgen ||
+		    existing->error != new->error)
 			return false;
 
 		if (existing->fpos + existing->flen == new->fpos) {


