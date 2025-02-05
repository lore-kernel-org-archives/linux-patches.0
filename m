Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F0E376;
	Wed,  5 Feb 2025 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767459; cv=none; b=RcJAQv/9y9CAJLXiN/k6ieQH45tBSRh+5SVVpasmc8bQbrRsPqzYoZkxgVSMQKwRxJrUBLboFsgAIJN5gEyzokwOztZgHcDvSixgyZM0WLFMlLYNVg723EAwy9q16laoxqS7vJbj5ZIcfNxDxBNTIwks0mzBAN7CB042e4Te3mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767459; c=relaxed/simple;
	bh=3g92yF1Ur6Zt/95n5eSdohWhZ87iog+MgSOrmCqtdYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0mGjrYmzVCZNfyBkwknia/KgWWtzhENdCkIJAbFbzl95pLlP04Qu0Sdnxlob/AwfvHzL6HaeL4Ia2Hag0zMu4tmnwgq7H/vRSWqEsakapDn/6w7b4aAEJIpUiPts5/rgKQBGNIhaskAoeyjpMZ5ZKFWZTqRsyPzcLrdXVbatQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgE2UFMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgE2UFMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3BFC4CED1;
	Wed,  5 Feb 2025 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767459;
	bh=3g92yF1Ur6Zt/95n5eSdohWhZ87iog+MgSOrmCqtdYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgE2UFMv7JgI3blTgAEk1ONeB+Qczhz8kV5ciXjeCosojCRPg1wEQIIdGpsLJeqWR
	 Tqr02zKU6A/k4K5GuQz6PpVi05h4BcQrHxgGPcvhKEN7HHkhGM8TC2LgxEmf0QKy0h
	 8kq+JObna9Y/tFXcyq/SKUVsBARzeS0Rusex8HD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ec5f884c4a135aa0dbb9@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Peter Hutterer <peter.hutterer@who-t.net>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.13 407/623] HID: core: Fix assumption that Resolution Multipliers must be in Logical Collections
Date: Wed,  5 Feb 2025 14:42:29 +0100
Message-ID: <20250205134511.793573090@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/hid/hid-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 33a191973324..5ab8e10bbd76 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1163,6 +1163,8 @@ static void hid_apply_multiplier(struct hid_device *hid,
 	while (multiplier_collection->parent_idx != -1 &&
 	       multiplier_collection->type != HID_COLLECTION_LOGICAL)
 		multiplier_collection = &hid->collection[multiplier_collection->parent_idx];
+	if (multiplier_collection->type != HID_COLLECTION_LOGICAL)
+		multiplier_collection = NULL;
 
 	effective_multiplier = hid_calculate_multiplier(hid, multiplier);
 
-- 
2.48.1



