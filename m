Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DEB1DF749;
	Tue, 11 Mar 2025 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706655; cv=none; b=XaFOmbfsLOoI7e0lckkxw6BNFgBdpnBNXXWjyEuA4578nf06lTBCXFYreFUiHrja0FXrLtU29RqMocJoaJixnlxJ+lCQkXe05tIgSdXAzvNKG2H5lJluFASCHZezCy9dR2xGyrsphhV9p+NHaDAejkeubW2VXgWjptjppy4iZM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706655; c=relaxed/simple;
	bh=laDwm513YMHiFxMWHirmxKhP6MTD4oauKexsOI+l91c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luVTmoMHPtimPNSP/6ZGSXrzWWBzdeWxoFf2Z6icsYhjG5BaxZyGd6tjgX4Vgt67rcRl5BGGqKvjvOS6jOJ8Nslc8TUNm0iZ1Tt83+ZD1WxD1jl3em9at4G/OnWHjGcBDUS92IjhShT6MQc+ARPgJR83cbPPVraAzE4z0EfLeLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkbaMgh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkbaMgh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16B6C4CEE9;
	Tue, 11 Mar 2025 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706655;
	bh=laDwm513YMHiFxMWHirmxKhP6MTD4oauKexsOI+l91c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkbaMgh68y7bKSyQemfJY/TNakX74ehYbmji7Lj3pFVzsy3qhvBPbyZTOqejE7la1
	 hT8O3OKAqHRttJ+vFuuAkq2pf+o4XL3pYCT5GK+nRdViPl9e0DEjBqFsVT2q3+T+7j
	 8f+n5fN52JufMTugfKGmrUKDCsFRzuaKGBWXflvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ec5f884c4a135aa0dbb9@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Peter Hutterer <peter.hutterer@who-t.net>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 122/462] HID: core: Fix assumption that Resolution Multipliers must be in Logical Collections
Date: Tue, 11 Mar 2025 15:56:28 +0100
Message-ID: <20250311145803.180329974@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1124,6 +1124,8 @@ static void hid_apply_multiplier(struct
 	while (multiplier_collection->parent_idx != -1 &&
 	       multiplier_collection->type != HID_COLLECTION_LOGICAL)
 		multiplier_collection = &hid->collection[multiplier_collection->parent_idx];
+	if (multiplier_collection->type != HID_COLLECTION_LOGICAL)
+		multiplier_collection = NULL;
 
 	effective_multiplier = hid_calculate_multiplier(hid, multiplier);
 


