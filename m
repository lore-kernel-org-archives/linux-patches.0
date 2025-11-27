Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2756225BEE8;
	Thu, 27 Nov 2025 14:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255035; cv=none; b=pG3X7xDctOaOXNRUFyDRgfzz10UAYqUB276040RCSlaaG58ypCPmWJS0r5+DfUqh1ehHkoXsqVUfUVLUGmAFVfghOJB595efgjJ6F1f/HNGy2nqjG8oEoRNfzywEeEX18rdxLgDjnBHHgUUBY8u3WI4P3QPa5+Pb2Cr/Fd09zdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255035; c=relaxed/simple;
	bh=rRC94YvnbNkWgTzkmsJIiZKRaTHPVsFE2bc48W4lpyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srZN0aI3bWRTBDif8bWVzycoHarFEm/9NVIQ/hE8LM1VBJxTM5ruqXhnwyuiTEigh2gDir7GGgb9RvOWDPAn6JI2L+JcjZPVEGHaDSAw6YCvyF+xUk/xpaUyvHK88PG1oArJm6XCOI3b5rj4cgOQ+RXQiisb8dJZ3hNb38zAJ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p079ySaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p079ySaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CFFC4CEF8;
	Thu, 27 Nov 2025 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255035;
	bh=rRC94YvnbNkWgTzkmsJIiZKRaTHPVsFE2bc48W4lpyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p079ySaTgd+hWfRrQMdcj+VLxZY3xsLeUQefL1tGRAPQnBEWlCH/3cv2OaWyyN8Ct
	 hv27FVNFll/XUCQSeVn8SKxqDNbGrnohr1pRbAVc+5gyVuzVjqdKRT5iuacBpTAS9G
	 ynIVtEjBGovb33wnn+t5CVyepAyr60x5vkFS+798=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 6.6 72/86] smb: client: fix incomplete backport in cfids_invalidation_worker()
Date: Thu, 27 Nov 2025 15:46:28 +0100
Message-ID: <20251127144030.461877904@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

The previous commit bdb596ceb4b7 ("smb: client: fix potential UAF in
smb2_close_cached_fid()") was an incomplete backport and missed one
kref_put() call in cfids_invalidation_worker() that should have been
converted to close_cached_dir().

Fixes: cb52d9c86d70 ("smb: client: fix potential UAF in smb2_close_cached_fid()")"
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -727,7 +727,7 @@ static void cfids_invalidation_worker(st
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 		/* Drop the ref-count acquired in invalidate_all_cached_dirs */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	}
 }
 


