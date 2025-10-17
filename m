Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900612F12A8;
	Fri, 17 Oct 2025 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716681; cv=none; b=jy38Wj85V3zCDh/RDLzXj0gDTKM5dw4QSt+X/btrWKeWsiEl0WlBAti05xKPEMbrMEnqxXlT52L3+KnAcgJxUL0RHufFaoBYKdzXQ6YZxipakcOi97fENM9ddOLWMEY4zr0YW4SrDZOp48uB5fwSOh6oBcdikFgG6pRhexR3aDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716681; c=relaxed/simple;
	bh=UNhUvuLTGXkJb5irK0m6qZ9Df+eG9NylDbSWPiuCeW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7LQQ0rTh4cUwxmYVegddLDZ34uWv1a22+khy4mt3aEM5yYJNpcroOYNcSUloWcitxZXtFY1pAl2N1ky1edWESQU3yhypfZ7/wOeH9IjoqXPoG00yPzGNbeKsz0ReFekIqu7GtfwavUlHBIRbORbclnA8bCJ2zTTepL7a+tLql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JR7EUPzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JR7EUPzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151EAC4CEE7;
	Fri, 17 Oct 2025 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716681;
	bh=UNhUvuLTGXkJb5irK0m6qZ9Df+eG9NylDbSWPiuCeW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JR7EUPzQyYpWRr29eZoP0wTuLuWxEwb6qM4scQ85LumoGzb5WgTW0VGLzNz1CJ3ei
	 76ZjVnRjnCCle8ykUS7TwVQ1oNDdRZBGR2IigjUoHWPTWw7zHK9mAT85a3wSsrFjL0
	 sDRKPwTPOntq8FJwuQ6mLO3TAaqHEJsVSuS2yuuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.15 274/276] mm/slab: make __free(kfree) accept error pointers
Date: Fri, 17 Oct 2025 16:56:07 +0200
Message-ID: <20251017145152.493966100@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
@@ -187,7 +187,7 @@ void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
 size_t __ksize(const void *objp);
 
-DEFINE_FREE(kfree, void *, if (_T) kfree(_T))
+DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))
 
 /**
  * ksize - Report actual allocation size of associated object


