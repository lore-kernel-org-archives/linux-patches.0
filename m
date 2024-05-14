Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E4953370;
	Tue, 14 May 2024 11:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685769; cv=none; b=piYwYzWaDNEqFvT1fEQsaFuq+AE4WbhH7xGvtRGB1LPmPZ0ZOVXcvtYm4QTTXC7jNS/Rx+HKs8o3RLzqY7j1DTZyKXZkUOdTG7VSz/ChFuSpfpc9ywI9jBNNiLFgYsUSlYzez2kUh36qY4mAM8iwJUMudKZVNZmSbz3O8jbNpxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685769; c=relaxed/simple;
	bh=L07PrzzLDTpyeOGb0Y3ApxVpSHXddzRWOOZMqDjjSRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieEddmUr24GQP8fWUjneY0v3ktLa6okqAlnoE5Oar5xuK+aOw0QvQV7YbeB9YywvV1UHUeAr5+eZ99bLjNS6qS2w2aWhfMoiX4YiYPCTFB3PaHeNIgGrR3kad50z00FSWPv41X+iVkboZci9wChG/AhXYbJ0TbVCOFLdRPMZIfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj2ZjKi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj2ZjKi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BFBC2BD10;
	Tue, 14 May 2024 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685769;
	bh=L07PrzzLDTpyeOGb0Y3ApxVpSHXddzRWOOZMqDjjSRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj2ZjKi7dnDPbVgsR9tKgSs4W35rQuIfLWEglggv8p/0P0qmyLn6VPxXOx7Sid5Jx
	 f/HLHJwreQqn7knjT+LYQGHUGfQK5t6/qX4TIydRePNXAlBeYGXbKwOR5niegLfBX/
	 qfeyw2QEEUSGNahPj69nlfAyCiFZ5MwQAGCDZ4Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.6 244/301] mm/slab: make __free(kfree) accept error pointers
Date: Tue, 14 May 2024 12:18:35 +0200
Message-ID: <20240514101041.468135601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -228,7 +228,7 @@ void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
 size_t __ksize(const void *objp);
 
-DEFINE_FREE(kfree, void *, if (_T) kfree(_T))
+DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))
 
 /**
  * ksize - Report actual allocation size of associated object


