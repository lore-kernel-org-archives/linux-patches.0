Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225D747A0D1;
	Sat, 12 Sep 2026 11:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213876; cv=none; b=MYuR/qWmmz/zxWrcZk1lyJg0+vc36jXArV9gkQppqMMGJXtrqwfgMv8a3NN5D0Nq3ct3MfbUxCsvltiCUciO8DY3PnJxHzc2RoMexi2C5wM+CiDMvmq4qoJo3LuSFctn+03y0aeY8cIBoFY57txUFFquHbXYNUX1W3+zVNi8804=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213876; c=relaxed/simple;
	bh=SDShLdJa+xIG5kEC1VOr8kiULNok6fY9o0U1p5V/O50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqmyxAz3Gukh9Kd959KRVqsRAzarT1RIxSJ5Wci/n109pHGopdLlbpv7AfWbWdd8ivKIo51Wi/4hU5bqrIRpIG6ObUiRGEK0TLUPLboHx4jpj8LeQyfXsN3ByTQsVA+ifbJqn9PffLlhsKcKWoWlrtAJ0Ut8qrx1JjQV6W76Q9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvVsjJtK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvVsjJtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DD21F00893;
	Sat, 12 Sep 2026 11:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213874;
	bh=7jFjvBeMDvEE83AEpeXBun/305aW2f3pfv63S6UcEIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvVsjJtK8ZCgFR+iZjg59sHjVIHAFbOFEafywmyg9M5xbruBNC5MTGP9j81oqWqVu
	 PYdh9zWbZ+yxiWKhyI2RwfQ3EhFgdhK41ZaLb4R51Dxym1o1isR8j2MZVNBggN/Dzs
	 +gsnnek7WR96maSDTKAApwXMrAnoFXX/EOJadIrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.12 0211/1376] media: v4l2-async: avoid deleting unlinked ASC entry on link error
Date: Sat, 12 Sep 2026 08:43:57 +0200
Message-ID: <20260912065612.250610470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


