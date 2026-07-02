Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDFE344052;
	Thu,  2 Jul 2026 16:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009828; cv=none; b=n1GzyXiPcaVdzdFy1S8EsTa7MLIpEZj+P5GcMFkJZyRg+cndrA8yzi63L0BJlX9FSizq4kG2IWtzy0xneZGRJEksJSZKqfEeLIq2LsT6LAT5yBpz8VnoHvEwQbEPDx6JxOcYuMo31jMF0Ghi+/DKvqz+jrzQhEUBVuwWKgzm858=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009828; c=relaxed/simple;
	bh=hTfoW3l4Gv5uuHS4B10pWZwlSAXt4AU8Oe/XCqGO5tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGHf4kmpQEciY3zHxut3lHLjHzLTVldUqFgD1VDj7cVZCUJ6GkP+xwjiYaJvCbd++OdrhffR2wKteMhoWCwBKo2HMKQkeJxfWqTdL/DkjGAyDcA5IUZGjsEh9HDqVP576EM1UbmxLj2JH7qEkdArELItSKCDzrTyqryQqKHXCFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdG9DWZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdG9DWZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565681F00A3D;
	Thu,  2 Jul 2026 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009825;
	bh=f+GEzMg0YDSOPrKHJMbRu04pxAvx/AYoe5emBcVaMIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdG9DWZzykoujS9iZIBaKYyV4rgecNvnsyXKbf3ncdzvOCw2p2r9vqd2rsUGB0B+C
	 kKB7L63cQ7TMeExngz8IbwccCrOuJS03bCMUpihMSwYUgWdOn1YAe0RnG+aF7FYjcr
	 Kf65ZEQEvi/ok30F8S3+NWIwziMj8hJC73qMBFsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	David Teigland <teigland@redhat.com>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 5.15 95/95] dlm: prevent NPD when writing a positive value to event_done
Date: Thu,  2 Jul 2026 18:20:38 +0200
Message-ID: <20260702155111.208384560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -638,7 +638,7 @@ static int new_lockspace(const char *nam
 	   lockspace to start running (via sysfs) in dlm_ls_start(). */
 
 	error = do_uevent(ls, 1);
-	if (error)
+	if (error < 0)
 		goto out_recoverd;
 
 	wait_for_completion(&ls->ls_members_done);


