Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AA13955EC;
	Tue, 12 May 2026 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608559; cv=none; b=iBIm92Tme6NQ94JFV7wUg5Xii9aJHJEwY8YZ3yujZlJU25vhgap+FqiAOrfwzGuttAAIDDuEG08QMdcgH9IldNIisFhPT0e4exu+c9zG7cMCkqY+ppNMGDkU5wdIyFpDCCjEksZfCsh0wxmjXYakwMMw1VOUJ6UvxWqKRb6Q9tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608559; c=relaxed/simple;
	bh=yfoWs4PEUeWxOPaAnGCQn0L8yz2giw4IwcQFQ4t1Wlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6sWtRu2rL6ICW5QJunJeEm/piV0b75Eg08svChjL+7R9aa/7gmj8VP5mwqHvh7RbrlsGqHia99RUHDup1Rftc4W3U6YULh9y8Vokcw1PrAwVipGCg4OgUgt1/idC+oXNgYOGGqy5WuiaKplOF3oHNXBjTbmh9WyQ7C7pelI/Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZLkgEzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZLkgEzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC4FC2BCB0;
	Tue, 12 May 2026 17:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608559;
	bh=yfoWs4PEUeWxOPaAnGCQn0L8yz2giw4IwcQFQ4t1Wlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZLkgEzliQpJlDiocTq4EIU/y2TWPGhiCLsUcjHMprvZoKSSKJGmjKDrd4jN6v+Lg
	 5iOFv7OmzeL9Ric4QaLRNVYw5zwb1XgTVJXmGjzTrcCBeyCx1CH6WOYCliuM3HsIE4
	 WhiZLOcXTjN3NKjRl9LtTU7Rv8v1S3+b4whcxSGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martyn Welch <martyn@welchs.me.uk>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 084/270] staging: vme_user: fix root device leak on init failure
Date: Tue, 12 May 2026 19:38:05 +0200
Message-ID: <20260512173940.227305811@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 32c91e8ee039777d0b95b914633fc6a42607959c upstream.

Make sure to deregister and free the root device in case module
initialisation fails.

Fixes: 658bcdae9c67 ("vme: Adding Fake VME driver")
Cc: stable@vger.kernel.org	# 4.9
Cc: Martyn Welch <martyn@welchs.me.uk>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260424104910.2619349-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vme_user/vme_fake.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/vme_user/vme_fake.c
+++ b/drivers/staging/vme_user/vme_fake.c
@@ -1230,6 +1230,8 @@ err_master:
 err_driver:
 	kfree(fake_bridge);
 err_struct:
+	root_device_unregister(vme_root);
+
 	return retval;
 }
 


