Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834526D1A0;
	Tue, 14 May 2024 10:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683754; cv=none; b=PpTsDfvA7jJiYjnf1OIEo8gZC14+tCk34q0YifxzhbAKDE3bQWUr1nrrgr/8PXC3k6nqUDfPowc5dQVmNx+Mh7v9GAb7gRc4dEEYpFab3rdziqokOtzkjC0G0LQ4nrgfdo+3UVVJRUhjyeeeho/oevNxQVzmI/VF0s6IKEZ7tQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683754; c=relaxed/simple;
	bh=1Q7BuxcW9izjILI15Ek25rgF4DMU3HQN2YjBQhzQTIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYw7joIuZx1N7Ur09YNthgG9ODYz9I+VoWgR96wLvlXKWX4tK20n1UOF4TwbdqMX6Js+XsZ3tfHC1Ar1VNLKkhL9os3OJ4owAg5lmXJuQx1/24ILnoQOkjr8jwO3uSParWUHtXjPkMRTj9a0JVQSYr0iHU0/RohhMQeAlrUtNjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZepZ/EAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZepZ/EAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4652C2BD10;
	Tue, 14 May 2024 10:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683754;
	bh=1Q7BuxcW9izjILI15Ek25rgF4DMU3HQN2YjBQhzQTIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZepZ/EAUe1cnfbxiPGSkJcfsLYGmlk6WDcNdkmsAvgPzEAPC+vvtRh4BV3oMxtYWh
	 rZS4YBVLfe66ZmJW2LHATozEvDDtmm+jz4g6FbeIRZ+19oTBFsJqbLOns+IOo/3jOD
	 ZoCxtgRHMpxpImWnt4KIFpDLMC0ax96U/Sit4b7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.8 268/336] mm/slab: make __free(kfree) accept error pointers
Date: Tue, 14 May 2024 12:17:52 +0200
Message-ID: <20240514101048.736683177@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -228,7 +228,7 @@ void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
 size_t __ksize(const void *objp);
 
-DEFINE_FREE(kfree, void *, if (_T) kfree(_T))
+DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))
 
 /**
  * ksize - Report actual allocation size of associated object
@@ -754,7 +754,7 @@ static inline __alloc_size(1, 2) void *k
 extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
 		      __realloc_size(3);
 extern void kvfree(const void *addr);
-DEFINE_FREE(kvfree, void *, if (_T) kvfree(_T))
+DEFINE_FREE(kvfree, void *, if (!IS_ERR_OR_NULL(_T)) kvfree(_T))
 
 extern void kvfree_sensitive(const void *addr, size_t len);
 


