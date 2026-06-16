Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663164779B1;
	Tue, 16 Jun 2026 17:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629804; cv=none; b=RqsXLGb6gyfLKPKJX5ZkrA0GJnkUbd2NunUz0rPYH4FjAbbscMEs99BhcvLBqAJGdoI97YAAXZBoPGADG/7L4Rm84hbYzBtHNbBovsKY+OLURz9Ocg4Z6ifLXEv0r2EDZMTj2DDBeyYU8vA3pWoOfzr9UrikJoueWfa8l8igKC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629804; c=relaxed/simple;
	bh=nW6t83vzkCn+EDPVEM71hGuc6NZlFvA4KGsBdOZ0YtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=preRi/S/DnE61gfvDK9w09DMrtHa8OgFsv27uTVqlgaJ3W7NJs3sJNiv8CaM+PWtzwSflb2Ya9U008FelSjMnFFETQ4rpBzxQZ/z+mtUG7UZLlwqv/Iefn5G0cf4bumVUmLwAwuGOklINJ7terS/XELsCroaN2kNwsiTUo0CTO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDkuqv5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDkuqv5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0951F00A3A;
	Tue, 16 Jun 2026 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629803;
	bh=Oe0VeUdJSLvGTKjW/p0eu4N3MQk8GkbUuVKY/2ADptM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDkuqv5BltZijvd7Ay0y1J3ieQaC3BnTu9fxmwpNreYkQmjBCg5GW/i5oL9WLKAx8
	 /J7y9ke/WKUPKw5nK8W4EKAv1iiRQ26bheFPsmfsbt+q7hqdgdfl5hvu4cyBTjoryp
	 nFo7vH2UhwwRog81sxnw42RrRQhnHQxBS1ca0/dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 355/452] thunderbolt: Bound root directory content to block size
Date: Tue, 16 Jun 2026 20:29:42 +0530
Message-ID: <20260616145135.813342461@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 65423079c7420e3dbf9a7aa345c243a3f5752e5d upstream.

__tb_property_parse_dir() does not check that content_offset +
content_len fits within block_len for the root directory case.
When rootdir->length equals or exceeds block_len - 2, the entry
loop reads past the allocated property block.

Add a bounds check after computing content_offset and content_len
to reject directories whose content extends past the block.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -181,6 +181,10 @@ static struct tb_property_dir *__tb_prop
 	if (is_root) {
 		content_offset = dir_offset + 2;
 		content_len = dir_len;
+		if (content_offset + content_len > block_len) {
+			tb_property_free_dir(dir);
+			return NULL;
+		}
 	} else {
 		if (dir_len < 4) {
 			tb_property_free_dir(dir);


