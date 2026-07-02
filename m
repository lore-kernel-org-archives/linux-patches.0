Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070773AC0FD;
	Thu,  2 Jul 2026 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009527; cv=none; b=cl9SHfXaex8LeqHGsU2ca6+nnOwNdp15ZwlqU5GhGIPSeogGsyAx+1jJEatG17H5YTwmvrLkhtPLGa2KaPz/kCXwlkX4ZtSFPg+qgI0gi3A6o4xCgGHe2D5N2PQbaQ6UEqZqhXsrU9m00r3Etefy+ODmK3DzszpeM/5o/8N6C2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009527; c=relaxed/simple;
	bh=qN2Ids3nnvJrpPl5ERT3cmn2B4XEUAOt34B1mRDCx5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHU6l9LjftWCjKTWMt0LPk1j9BtLVwmmm18K+w2rkIRBoaObl5/MyMEXJWqls1eVfIbCasDwGP6WX/7oZtqoN/tXhsM6AbYZ+tsT9c905MQTZI8vHer+B3Exda0aYaSgqhmO6P0aLeL0q8dJ2yK32iF7PwnzYHfGyL8uDYBrUlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8zvZ1s+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8zvZ1s+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7F01F00A3A;
	Thu,  2 Jul 2026 16:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009521;
	bh=ojBGWcIe7/mJyYRSrSkCQXkkS71vUGmjDmWX5f0PnXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E8zvZ1s+syBc5O05G9LmkcFaxpG/fUh0rw5ww/b7SV3jlab9DaEO5szeX1fUOpOn6
	 hsOW3/HBjBakDc7qbKuxmkrNIRNJTAgKCi7t2q8g53LqFsNGNglYST5x4hfGm/AmI4
	 5nM4Maqe1B4uQFIvZfSg6lt0uoc1k9ta7q+Qr8Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	David Teigland <teigland@redhat.com>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 5.10 82/96] dlm: prevent NPD when writing a positive value to event_done
Date: Thu,  2 Jul 2026 18:20:14 +0200
Message-ID: <20260702155110.703379727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 8e2bad543eca5c25cd02cbc63d72557934d45f13 upstream.

do_uevent returns the value written to event_done. In case it is a
positive value, new_lockspace would undo all the work, and lockspace
would not be set. __dlm_new_lockspace, however, would treat that
positive value as a success due to commit 8511a2728ab8 ("dlm: fix use
count with multiple joins").

Down the line, device_create_lockspace would pass that NULL lockspace to
dlm_find_lockspace_local, leading to a NULL pointer dereference.

Treating such positive values as successes prevents the problem. Given
this has been broken for so long, this is unlikely to break userspace
expectations.

Fixes: 8511a2728ab8 ("dlm: fix use count with multiple joins")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lockspace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -639,7 +639,7 @@ static int new_lockspace(const char *nam
 	   lockspace to start running (via sysfs) in dlm_ls_start(). */
 
 	error = do_uevent(ls, 1);
-	if (error)
+	if (error < 0)
 		goto out_recoverd;
 
 	wait_for_completion(&ls->ls_members_done);


