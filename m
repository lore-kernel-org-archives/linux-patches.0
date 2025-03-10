Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB10823026D;
	Mon, 10 Mar 2025 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628191; cv=none; b=rOXy+B/paUsElkv8vajRo1GT70T+2cnetL4tvJ8M1jfYRS/23CdUs5ogojMVKA6Atb4HEbtpQqon7/2zVU6HMBkpcO8qzNg5gOhf7zjX4DPJms6E2edw4uIpJRE1YAg0f9SstxFY40rdmGOqHaLCm3wyVy3sI37VoYPBBHLFKKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628191; c=relaxed/simple;
	bh=ojbLLdVm9skDDwxhbTKeOALQkDcyaH979jYaj3T6ytM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9d80Elil8fIj6xSEuk6WzViS960riSJcE5sw2Arl5r4nkHqxsY//5RuX2MbWwzKAZGGpOKp4PFxI+FvKS7NPgV+LyPU6SaMa1JVFDiu7jrMsqA1c3poZ4mecxovqTgwa+RG0npbXhIDOSkS9DwebYFBaI3HnsOv9GsE5y4V6V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOB3CbIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOB3CbIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149EDC4CEE5;
	Mon, 10 Mar 2025 17:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628190;
	bh=ojbLLdVm9skDDwxhbTKeOALQkDcyaH979jYaj3T6ytM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOB3CbIFTFdqw9cZCHhOggXZ++lOvXOJIxDOsZKt9p2LMZjA4j/i7IxhF/n1QjY1D
	 9sK3hgM7VBzm1O+btzNsWrYQ+gZfi1Izz++BLPLCwRKSa0V3TXbyLyI4J/33tCvqHd
	 TZUXip4Z5EKNIlAom2ZWpl13zYH+zgcSyIevM3/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.6 118/145] char: misc: deallocate static minor in error path
Date: Mon, 10 Mar 2025 18:06:52 +0100
Message-ID: <20250310170439.527135856@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 6d991f569c5ef6eaeadf1238df2c36e3975233ad upstream.

When creating sysfs files fail, the allocated minor must be freed such that
it can be later reused. That is specially harmful for static minor numbers,
since those would always fail to register later on.

Fixes: 6d04d2b554b1 ("misc: misc_minor_alloc to use ida for all dynamic/misc dynamic minors")
Cc: stable <stable@kernel.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://lore.kernel.org/r/20250123123249.4081674-5-cascardo@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -264,8 +264,8 @@ int misc_register(struct miscdevice *mis
 		device_create_with_groups(&misc_class, misc->parent, dev,
 					  misc, misc->groups, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
+		misc_minor_free(misc->minor);
 		if (is_dynamic) {
-			misc_minor_free(misc->minor);
 			misc->minor = MISC_DYNAMIC_MINOR;
 		}
 		err = PTR_ERR(misc->this_device);


