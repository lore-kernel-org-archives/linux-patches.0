Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E3233506D;
	Fri, 17 Oct 2025 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715741; cv=none; b=Fnb7saKsdlTOZreQl4kUfyC+Z/JanxRktK6jFdo+CzJqWIZDoXp8mKWiO1NZX5r+sUZI9l3qvebH10vU3wVfdfJup4uG9FmmrA5tdhNWB1N9aL2dKgsFqmLB0OL8aUMwPGo/df9eyVbnPyaiX4YKNcB+8ipYPC76pWbqqKq6c60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715741; c=relaxed/simple;
	bh=pvFJ7bSSlx/PZFQQl0aUh5clZF9UifALY4R9QUqgcIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAbTUHXGkeq2kEoRiNf+VultdLtUke8kzKiTcdyNIA1yB7Jy00lyv1EVz4sISPX8b3e/7/xOTh2PsrBSkhcThI7eCT0oHnRBQnI6zOOkPABs//luRZeIDCZZl8Dqsba5r+gT8UVeLQW5uCD3aBXceZO04JT81ja297uCuymBi3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pbV+NVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pbV+NVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F52C4CEFE;
	Fri, 17 Oct 2025 15:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715741;
	bh=pvFJ7bSSlx/PZFQQl0aUh5clZF9UifALY4R9QUqgcIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pbV+NVfEPkYIAxmu2N+WgYnZNotMvqOO6vWMXCcXrlQvSodpgj8PTDaDu0PI2/Jc
	 HghIaHaXquhxi1gmsgwPBAH6Vw3TDF9LpT3ug/ru9HUyTHE1K28k3BiqIsleRwQFXB
	 BdNLAt9p/JI6snG2lPuIbr0g5L2sg2TD8rHJbrpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.17 322/371] NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()
Date: Fri, 17 Oct 2025 16:54:57 +0200
Message-ID: <20251017145213.727106172@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit ab1c282c010c4f327bd7addc3c0035fd8e3c1721 upstream.

Commit 5304877936c0 ("NFSD: Fix strncpy() fortify warning") replaced
strncpy(,, sizeof(..)) with strlcpy(,, sizeof(..) - 1), but strlcpy()
already guaranteed NUL-termination of the destination buffer and
subtracting one byte potentially truncated the source string.

The incorrect size was then carried over in commit 72f78ae00a8e ("NFSD:
move from strlcpy with unused retval to strscpy") when switching from
strlcpy() to strscpy().

Fix this off-by-one error by using the full size of the destination
buffer again.

Cc: stable@vger.kernel.org
Fixes: 5304877936c0 ("NFSD: Fix strncpy() fortify warning")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1498,7 +1498,7 @@ try_again:
 		return 0;
 	}
 	if (work) {
-		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr) - 1);
+		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr));
 		refcount_set(&work->nsui_refcnt, 2);
 		work->nsui_busy = true;
 		list_add_tail(&work->nsui_list, &nn->nfsd_ssc_mount_list);


