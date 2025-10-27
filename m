Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3585330D26;
	Mon, 27 Oct 2025 18:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591518; cv=none; b=qZoF7qF38hcYlH/sTxxNmFM+lAcBXvTvegbRRMvnKZ58VjZMovg/UkHjXuNaacldZapCSLcjRdkmL6HwSIyWZ89y0Ls1CPte+56HlUdPOeJbtqpo0fZoO5dPSdpQ4AiPMJYLtcFvjQKf7bs7d33pHiOKEEW4yapQHcTlAvh7a+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591518; c=relaxed/simple;
	bh=QMLhcPB/YNPGPxykFAN6Rqss7CIQzB44IeAWsIxQ9Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceAA4rHZgTwerO29VC8jkZl7rmgdnIRgtk+t5/yJTdfPpjfGrv/zSFUzr3kNJ+0wKtOOJmC6r9eWJMVevcF0Xf9oYH57viQInmYIsVR8BG9/YKn3/x7hqPcZ17yJpnYe1XFHZXrHyO5BV8od9N+NgHexI2vG15G7bAqXVRrYvaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXx+rSYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXx+rSYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85406C4CEFD;
	Mon, 27 Oct 2025 18:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591517;
	bh=QMLhcPB/YNPGPxykFAN6Rqss7CIQzB44IeAWsIxQ9Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXx+rSYMXaFd6ZOnMPIVMbvepss02eaDaLdqZtiT+rZXiUHh3+Ygc0L25SmWc+APs
	 4gnXwd1kzGSZL+QsAqKfGqPlP/KQEEWyAKgGHclJ+LZ7eoG/SQceXnqgUM7d/guaIO
	 I+NTiyO64IDreHT6gktouE9uHcLxT97AidboKMU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.10 225/332] mm/slab: make __free(kfree) accept error pointers
Date: Mon, 27 Oct 2025 19:34:38 +0100
Message-ID: <20251027183530.737104595@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit cd7eb8f83fcf258f71e293f7fc52a70be8ed0128 upstream.

Currently, if an automatically freed allocation is an error pointer that
will lead to a crash.  An example of this is in wm831x_gpio_dbg_show().

   171	char *label __free(kfree) = gpiochip_dup_line_label(chip, i);
   172	if (IS_ERR(label)) {
   173		dev_err(wm831x->dev, "Failed to duplicate label\n");
   174		continue;
   175  }

The auto clean up function should check for error pointers as well,
otherwise we're going to keep hitting issues like this.

Fixes: 54da6a092431 ("locking: Introduce __cleanup() based infrastructure")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -188,7 +188,7 @@ void kfree_sensitive(const void *);
 size_t __ksize(const void *);
 size_t ksize(const void *);
 
-DEFINE_FREE(kfree, void *, if (_T) kfree(_T))
+DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))
 
 #ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
 void __check_heap_object(const void *ptr, unsigned long n, struct page *page,


