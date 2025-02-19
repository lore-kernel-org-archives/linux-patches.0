Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF6C1DED40;
	Wed, 19 Feb 2025 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955957; cv=none; b=J/nZTCe7AhAnmdsKuWGMKK+X0SFGGERDHtbeLOdqJgFVqOfibAL8xplkq4lPOxxXpZJdJZGRVXLc640pGGgSIA21Fg8lKrs3fQUHYk9wO93oA4OGhR0l+IvQ9lgrADne9ZG5+bjVuSnIBD+p1qAixeHwjfeq+qzb+CoXkN5gVMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955957; c=relaxed/simple;
	bh=hO8TwXdEbuXyiQ0LX0mI+bwz144cGzS4TxYefgTGO3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4H6UVN4b3k5Tnb1atKxCumh/GEkeNbCV2ouR+uEmMQWTEj2NwbtFcrYP9rz+o04QCSicPl6fF7nSXZej1FfnVotl0WKqdWKcOO54D7p8iw8ymonNQg2CZgUc19F2xFotxoCVLDxxhS7lpSGLGM3cPE5o/YEvm+sFiIG/4bJAdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eI0j8rKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eI0j8rKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E6CC4CED1;
	Wed, 19 Feb 2025 09:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955957;
	bh=hO8TwXdEbuXyiQ0LX0mI+bwz144cGzS4TxYefgTGO3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eI0j8rKu5vEuKrNYX0HNEiDgSbBH0cai4blnBQA2D5cNG5XDejTKu3otblJVQMvWU
	 IkYytNXvF4nPbVPb/WlCuJQc5oy1GJ3anvTK3gm6koKKWkFn0gnJc7rQ1zHrXm9xP7
	 Oq1UcCEyhPHZTyLF8i4n2imeovnyMq5yQZFQzrkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ec5f884c4a135aa0dbb9@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Peter Hutterer <peter.hutterer@who-t.net>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 017/578] HID: core: Fix assumption that Resolution Multipliers must be in Logical Collections
Date: Wed, 19 Feb 2025 09:20:21 +0100
Message-ID: <20250219082653.568539775@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 64f2657b579343cf923aa933f08074e6258eb07b upstream.

A report in 2019 by the syzbot fuzzer was found to be connected to two
errors in the HID core associated with Resolution Multipliers.  One of
the errors was fixed by commit ea427a222d8b ("HID: core: Fix deadloop
in hid_apply_multiplier."), but the other has not been fixed.

This error arises because hid_apply_multipler() assumes that every
Resolution Multiplier control is contained in a Logical Collection,
i.e., there's no way the routine can ever set multiplier_collection to
NULL.  This is in spite of the fact that the function starts with a
big comment saying:

	 * "The Resolution Multiplier control must be contained in the same
	 * Logical Collection as the control(s) to which it is to be applied.
	   ...
	 *  If no Logical Collection is
	 * defined, the Resolution Multiplier is associated with all
	 * controls in the report."
	 * HID Usage Table, v1.12, Section 4.3.1, p30
	 *
	 * Thus, search from the current collection upwards until we find a
	 * logical collection...

The comment and the code overlook the possibility that none of the
collections found may be a Logical Collection.

The fix is to set the multiplier_collection pointer to NULL if the
collection found isn't a Logical Collection.

Reported-by: syzbot+ec5f884c4a135aa0dbb9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000109c040597dc5843@google.com/
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Hutterer <peter.hutterer@who-t.net>
Fixes: 5a4abb36f312 ("HID: core: process the Resolution Multiplier")
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1129,6 +1129,8 @@ static void hid_apply_multiplier(struct
 	while (multiplier_collection->parent_idx != -1 &&
 	       multiplier_collection->type != HID_COLLECTION_LOGICAL)
 		multiplier_collection = &hid->collection[multiplier_collection->parent_idx];
+	if (multiplier_collection->type != HID_COLLECTION_LOGICAL)
+		multiplier_collection = NULL;
 
 	effective_multiplier = hid_calculate_multiplier(hid, multiplier);
 


