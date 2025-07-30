Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8D113D53B;
	Wed, 30 Jul 2025 09:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868915; cv=none; b=mJhuey8vifH4Z5rC0hG5w07wmkW4FEgZF35rMYPRpUAgQdDbhiHZujT8HjON75oSlGOXyZ75VR0v2T35s95UXVr53z+dYOh1NXJEy9GFZ2RWXnPQHKXfluC+6Hj/LQSRaTsKI/lkiIzDirYeKRj78AMzALDu9zS8WHpeSGf/HoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868915; c=relaxed/simple;
	bh=pKQGaElXS4DLradfcemFUXVCBKSc9LplVYeagKPzTgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i381hVGzixD0bZYxPpizqdxhojOA0utUXzLYJGtDWU7x8NPo7FakassqbLzKnuk1L9TyEb6HkpkESJWo9VES4FNSGhyUYGUAd+j5HKydK1vHoauiqrdPLTfsEQHr4TYknLU1MsZMlrY0VzaKkNlxN9VvZDuk9Mrhk2jdqfkp9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nqpur6KZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nqpur6KZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B00C4CEF5;
	Wed, 30 Jul 2025 09:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868915;
	bh=pKQGaElXS4DLradfcemFUXVCBKSc9LplVYeagKPzTgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nqpur6KZHPX0ygODGJv3Ir2YQjZUbbRFFEFOMTDXPEPq0Vok3NHGE49g8++k3egUc
	 t2r1GLxtI/KL+dHtQRvDacRrbLkudd/nGEjtGeKAQH9fAHg7MlYxOVzcQdreimP+Cq
	 G4yT/y54flKDUe3ERtiu0xQ5mFdLXoPJm3Go4Jr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Dexuan Cui <decui@microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>
Subject: [PATCH 6.12 108/117] Drivers: hv: Make the sysfs node size for the ring buffer dynamic
Date: Wed, 30 Jul 2025 11:36:17 +0200
Message-ID: <20250730093238.012215866@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

commit 65995e97a1caacf0024bebda3332b8d1f0f443c4 upstream.

The ring buffer size varies across VMBus channels. The size of sysfs
node for the ring buffer is currently hardcoded to 4 MB. Userspace
clients either use fstat() or hardcode this size for doing mmap().
To address this, make the sysfs node size dynamic to reflect the
actual ring buffer size for each channel. This will ensure that
fstat() on ring sysfs node always returns the correct size of
ring buffer.

Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250502074811.2022-3-namjain@linux.microsoft.com
[ The structure "struct attribute_group" does not have bin_size field in
  v6.12.x kernel so the logic of configuring size of sysfs node for ring buffer
  has been moved to vmbus_chan_bin_attr_is_visible().
  Original change was not a fix, but it needs to be backported to fix size
  related discrepancy caused by the commit mentioned in Fixes tag. ]
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/vmbus_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1810,7 +1810,6 @@ static struct bin_attribute chan_attr_ri
 		.name = "ring",
 		.mode = 0600,
 	},
-	.size = 2 * SZ_2M,
 	.mmap = hv_mmap_ring_buffer_wrapper,
 };
 static struct attribute *vmbus_chan_attrs[] = {
@@ -1866,6 +1865,7 @@ static umode_t vmbus_chan_bin_attr_is_vi
 	/* Hide ring attribute if channel's ring_sysfs_visible is set to false */
 	if (attr ==  &chan_attr_ring_buffer && !channel->ring_sysfs_visible)
 		return 0;
+	attr->size = channel->ringbuffer_pagecount << PAGE_SHIFT;
 
 	return attr->attr.mode;
 }


