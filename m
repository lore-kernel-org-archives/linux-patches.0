Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127393438BA;
	Sat, 12 Sep 2026 14:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221844; cv=none; b=IUtpnGTLclBdOWDhWWpIp7hFcL7xrqkKwvPrfXs/WFv8nGztzMgytSV/MqoHV4FxivgHOfeKpKsI5AymlkWYnVz8K3nrnBJ9JlyFFvz4Y2IE77K2XBspt2i0e+MI66TM5+Iu+TEkqzaPo8IvuRUptGf+/nm/yCpWkUi4o/1DsEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221844; c=relaxed/simple;
	bh=DgQQ07W+hWXtq2uIkqBNRIQAJmblYloFuCQdwdq8/GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obd7gZNLmYc3NB/IBNda5wditYOOeACd9xxIqsYR/E4iJ4ssnpie+sf5Ago6gSbloaLtIZuOeLDjN2Vihy4YYBYmNncDG5TE1B9dY5owmHnHI80rBFvGTbV86v00fHZKSrooR8oEczsdxEdxaNALk8PysnJwWzCHrgJd3qwDlq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbD8crZe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbD8crZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167501F000FF;
	Sat, 12 Sep 2026 14:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221841;
	bh=xnfTpqTODw4CS6RQwxes1k+adR4N4HNdn+dOXNbIYDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbD8crZeKyuYDYLCVZsBreBI6tjYvdu3zT+Ce1NGydiomqa2i1CBUp8OEcjdCW5yk
	 +8tELpdz2psu729cKyg438KO7lo3vF6bNxfc4vTj5az2bH7Ec86qUcZNJzaMv7VaN2
	 I2gdTXKoYCmr7Z38GP1kN7aGbCWnudwcoM9PH3+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.6 0465/1424] media: v4l2-async: avoid deleting unlinked ASC entry on link error
Date: Sat, 12 Sep 2026 08:48:17 +0200
Message-ID: <20260912065617.700644451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -388,7 +388,6 @@ static int v4l2_async_match_notify(struc
 
 err_call_unbind:
 	v4l2_async_nf_call_unbind(notifier, sd, asc);
-	list_del(&asc->asc_subdev_entry);
 
 err_unregister_subdev:
 	if (registered)


