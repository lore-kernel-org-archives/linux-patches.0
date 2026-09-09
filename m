Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EB9423A85;
	Wed,  9 Sep 2026 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964120; cv=none; b=lufetwrXoxSqM8REnq2qs9tBo+LL34OnQ5Pp/XiI+RyB8CXXaHvORkmZ9RZMT+z4Hnz61/upoMF8cxONXjlzmIRkAaPeLm4GCyVZUpou3SdlKkUc26YruwDPB6e1xT38Uz+5agn44h6n5iSRDZyarekgHRW1h9TWNnl+cLj5b+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964120; c=relaxed/simple;
	bh=kbZQii8ethbV97+K0gMSfowtpyZq+LAL3iU4jh1t70Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3ic0dKnL2vOGJp7HIQXEuOBwS3dAhfD0X+bbh2oft9zPGo8koCnOGGVRyVo4ubEg0tPj7gfJNRqgNpWMx7fN9a+c/kvYbRo4cPZOxWEm0IHZoccT9mlUT6g1815GMuFENHlUoZDM3KOX3UMpnH8B7RGVJ7es32R4PzF0DLUHBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxuXNFxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxuXNFxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0A01F00A3A;
	Wed,  9 Sep 2026 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964118;
	bh=qcvfgvMoEiomzu6YIKt6Ytozz1b/KoPtf7ejNvrCgSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxuXNFxtpb/GgxmVprsDxjLYGxDDGBOi0ftMY1tz4PKU83b732B8lDVfYmHxAHv5+
	 kG3sEBsyOR/JVaLuTiQQf0jEsnxye62pM4BAeT7CAICIATjmw5E1YsECHDSJF1zdWf
	 +1jANyn+KwTXfBpchD0bZXkINNknB69g6wKvV/EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 311/583] media: v4l2-async: avoid deleting unlinked ASC entry on link error
Date: Wed,  9 Sep 2026 15:39:56 +0200
Message-ID: <20260909134248.782030805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 47d82b605351c0e04f6365e42c8ffe2fcfdba615 upstream.

v4l2_async_match_notify() creates ancillary media links before adding
asc->asc_subdev_entry to sd->asc_list.

If ancillary link creation fails, the function jumps to
err_call_unbind while asc_subdev_entry has not been linked yet. Async
connections are zero-allocated, so the list entry still has NULL next
and prev pointers on this path. Calling list_del() on it can therefore
dereference NULL instead of returning the original link creation error.

Do not delete asc_subdev_entry from err_call_unbind. There is no list
insertion to undo on this path; the bound callback and sub-device
registration are the operations that need to be rolled back.

Fixes: 28a1295795d8 ("media: v4l: async: Allow multiple connections between entities")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-async.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -392,7 +392,6 @@ static int v4l2_async_match_notify(struc
 
 err_call_unbind:
 	v4l2_async_nf_call_unbind(notifier, sd, asc);
-	list_del(&asc->asc_subdev_entry);
 
 err_unregister_subdev:
 	if (registered)


