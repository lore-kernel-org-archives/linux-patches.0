Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407F91E47CA;
	Mon, 27 Oct 2025 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591356; cv=none; b=Eu68cMdODGwZ4WRkU1i9ajX2ejQGBD6YAgW8e7QbMWn+WkKsKxcM60onapLnRMDAnpr4TQZoXWGSNR7ShQVr59lv6qDW0cSD9mDAns/52jtPqRntFkHWKV1Ic2pe+PhViOvZp8yNNEicjZ1oM/Iiy7fd5BrLeL9ZeCJ9JoYAhis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591356; c=relaxed/simple;
	bh=YeMgKh/EPKB9F9x0sszjmWNb9zyu38h539y6cQrvTkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTBKWaV+copTCcBTSwWprN38JmIaAhjAzJ0V3Y8fG0cFh5KEA4GYCCpGf5Me/oEqcTplqkaxeTuj0mcKrHdYf+OoG7iPDjI+Re3cquX14NKUzZR9S8BVAW8CabZ2IhbMxrob2UiOm0qMstkM6MzgBURNV7xsztJn9ibr6U6z9X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4g++KL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4g++KL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F73C4CEF1;
	Mon, 27 Oct 2025 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591356;
	bh=YeMgKh/EPKB9F9x0sszjmWNb9zyu38h539y6cQrvTkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4g++KL4o+RdUMTDjiylQeQx5vHgmGg2EJM6Qx8wkOo5r3IXORFjmUQAyIvj/fObv
	 WqAtLWEp+6tAxV3DEBz7Imq3yBiOSxv3ptd1JaHZm+b/Bv79Yz30GBsQOOs8EE07Ms
	 Qinh/ENssADPEywlzk7Qln9DPswxGiuXBOgZ+Bg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 166/332] NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()
Date: Mon, 27 Oct 2025 19:33:39 +0100
Message-ID: <20251027183529.008162774@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
@@ -1335,7 +1335,7 @@ try_again:
 		return 0;
 	}
 	if (work) {
-		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr) - 1);
+		strscpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr));
 		refcount_set(&work->nsui_refcnt, 2);
 		work->nsui_busy = true;
 		list_add_tail(&work->nsui_list, &nn->nfsd_ssc_mount_list);


