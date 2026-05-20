Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56343D8138;
	Wed, 20 May 2026 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297203; cv=none; b=J3+oEoChtQGHl9Bplhr4A/cgElWsWN9sKZE7AuRDJU9zYHLAHq8Uwh2BSujgt4PADSpEyd71p2WbewGNYUG519fEcuMYRu5OnJQ9BcLeHrDpjGYaTjl98Bm/d0W29JbBG98ISppuvpDW8QLrSOGtMZfgQPwFwtOskZ/0TAtoqWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297203; c=relaxed/simple;
	bh=VRDXyZjmKgZQ1I1W918xuRP7s1CGutN6iaWN9RHIaYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhELlidO5UOhhcjhpgW5a1jZzu5JuT2u+z5ijt1XWY0GdSzhOHx/hqp3cvdJQGFOIrbFqM+5dgracarg7IYjbBpUpWaaJoYxE17O2O0vKtl2d3ELbZ7+8aDn9GXG40mzUmeAqOkp2NqhmNM4NtXvvmSIH9kdEvkgAcGpllGvhLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lU9hoVcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lU9hoVcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5644F1F000E9;
	Wed, 20 May 2026 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297201;
	bh=OB5VGmhDzXGlNrlHipUesl7F1qMEoo7EBYo0BJ48WDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lU9hoVcDYigOs0Jcf7fx0xegWepw29b3dukqhqKzi/tzE6T/VlghMjUL/+RVmMjDb
	 S6d2ZIaCFXeqYhLmZ5lz8eAVU8tvxiDZU4hQi454TAKQGVqh6v9oqCpJ0hLuIHd2nv
	 A0a1n0eGcog/Z1bI5V77FHrDRzPFmR2HJN+AE3Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 7.0 1087/1146] accel/rocket: Fix prep_bo ioctl leaking positive return from dma_resv_wait_timeout()
Date: Wed, 20 May 2026 18:22:17 +0200
Message-ID: <20260520162212.835663388@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gyeyoung Baek <gye976@gmail.com>

commit 74570e12b4705ea11dcdfbfbd0a0b0fdaeff3059 upstream.

dma_resv_wait_timeout() returns a positive 'remaining jiffies' value
on success, 0 on timeout, and -errno on failure.

rocket_ioctl_prep_bo() returns this 'long' result from an int-typed
ioctl handler, so positive values reach userspace as bogus errors.
Explicitly set ret to 0 on the success path.

Fixes: 525ad89dd904 ("accel/rocket: Add IOCTLs for synchronizing memory accesses")
Cc: stable@vger.kernel.org
Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Reviewed-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Link: https://patch.msgid.link/c0ebf83b345721701b22d8f5bc41c52c0ecf5e16.1776581974.git.gye976@gmail.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/rocket/rocket_gem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/accel/rocket/rocket_gem.c
+++ b/drivers/accel/rocket/rocket_gem.c
@@ -145,6 +145,8 @@ int rocket_ioctl_prep_bo(struct drm_devi
 	ret = dma_resv_wait_timeout(gem_obj->resv, DMA_RESV_USAGE_WRITE, true, timeout);
 	if (!ret)
 		ret = timeout ? -ETIMEDOUT : -EBUSY;
+	else if (ret > 0)
+		ret = 0;
 
 	shmem_obj = &to_rocket_bo(gem_obj)->base;
 


