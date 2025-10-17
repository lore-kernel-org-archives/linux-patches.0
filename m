Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D08330B11;
	Fri, 17 Oct 2025 15:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715424; cv=none; b=W5/mulBgXMZeKDBSaSk55WBSTo+D87eJlr/SKbICdYRM4RN4gUEz/yWfJj28F+VI3I3MEnUaK2RUB4IG4+UuxR48IJkCo43YhisU9aaZ+MNMqCcJSi8DHAcMFhDyoE0su8VauK9eJGKySNUGFqlaqPe1z9mRXBCezPaInZZvZzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715424; c=relaxed/simple;
	bh=CPbaP1qYB0BRzvS8y/hI9OiYjHwWRfrzqBuGlgLaRog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irck7DXVgxNkVANUjtl23YI1FajThEge1NrsJojLRmoAVVS2JD2HW55iC4AGoJuvUg/HHlZEvauKOwzdprEoMIBkWUFpz83i0yGDFExw4URVrye218OB8EbiUocxoZWb593Li6lZFApUkruak7W+OZL0AMUQokxs+ok6swievJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gkW9IcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gkW9IcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3463C4CEFE;
	Fri, 17 Oct 2025 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715424;
	bh=CPbaP1qYB0BRzvS8y/hI9OiYjHwWRfrzqBuGlgLaRog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gkW9IcOKVGEQSCrdKYTQst15zGwCvJcQk9cOq8dcTvd0j72hVKA3Vh+5l4f5Ole3
	 ZCcUtTBshwz2vNr8iWkF0+bQG0ztZRt3oDLdgj2VXjY1bSFr+YfPraqMHLbwJtxR+V
	 SLdWCexeUttbDx7uwr4lbvsP9RFA0Cszl40FRr1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.17 212/371] fs/ntfs3: Fix a resource leak bug in wnd_extend()
Date: Fri, 17 Oct 2025 16:53:07 +0200
Message-ID: <20251017145209.757304086@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d68318471aa2e16222ebf492883e05a2d72b9b17 upstream.

Add put_bh() to decrease the refcount of 'bh' after the job
is finished, preventing a resource leak.

Fixes: 3f3b442b5ad2 ("fs/ntfs3: Add bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/bitmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -1371,6 +1371,7 @@ int wnd_extend(struct wnd_bitmap *wnd, s
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		/* err = sync_dirty_buffer(bh); */
+		put_bh(bh);
 
 		b0 = 0;
 		bits -= op;


