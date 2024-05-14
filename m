Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CEA12C554;
	Tue, 14 May 2024 11:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686633; cv=none; b=ebPRQ7U+A2izrBhOX47vUTT7hV911p0pQsQlGCyCfIoWBTRYvcQIoV6kYQ3AE/C7Ng/cnVdvOgwprvbzmsxwOi5+Ank87+Wdil6FfzdOTw2LMsDFDfPvvdHkqvmp9+zFj6hNtMj+nyBqjYHyS2O50ekeK/XL+1a/ZEyebmIOkpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686633; c=relaxed/simple;
	bh=akDS+qBCT3opHg4SZTH0dNly6vhHIJVbYSY3ipeoj1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ra3kXCc1O6ROgUsKyf2oTaranirXDoj4R6IQH2srca5LL49rVFPNYrCrhtyauXhLK3EAtgTqJXhKSoOjhFXbuj5MCas5zUI2L+B1+eNvd4qyeKLLBZEaAJYQ2PaiBMVCfgB1aQMcOjjxiWMM5QsmbkbTETcR+8jzHtYuex1TH/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yALydrjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yALydrjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C71C2BD10;
	Tue, 14 May 2024 11:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686633;
	bh=akDS+qBCT3opHg4SZTH0dNly6vhHIJVbYSY3ipeoj1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yALydrjbhJ916f5PlfbxVyDhoNhYwOb4Zv4ydNBqgWkpS2ncN1bUdnHEBDErg0yOj
	 mf2jPHRSyHQRNZ602LGzLkW/CRSHiFL8QvTF4nS3nZyQkxneFn8Vt/BMFlEbIhJqMo
	 mz+a3PXb3tbJvBAUmjAy5uzwU9T3DtZP8m5JdLLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.1 205/236] mm/slab: make __free(kfree) accept error pointers
Date: Tue, 14 May 2024 12:19:27 +0200
Message-ID: <20240514101028.145729203@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -198,7 +198,7 @@ void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
 size_t __ksize(const void *objp);
 
-DEFINE_FREE(kfree, void *, if (_T) kfree(_T))
+DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))
 
 /**
  * ksize - Report actual allocation size of associated object


