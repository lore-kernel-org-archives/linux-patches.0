Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F94213ECF;
	Tue, 12 Nov 2024 10:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408246; cv=none; b=b25dcVlLBSJi9UhhJsYiHY/b6XTqTrvVu0KPVfccDWxjeG2avy1oy5z2+BeuYQMlAo0hjf3rXPs6YY3AKaA+UNScYCjAlLoFoqgTp7uqLd3z9Zj6/ZZYHbrOQdyYqumC0bRryUWvy8rhcywY/UVl0fK7UnR+g9XY5VQUKofn1/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408246; c=relaxed/simple;
	bh=v7mv32BJKJECU66bFwq4qy4NykUKdL+Sm8riekILCok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMGYel2PH38OFNEaC2vHTScZVho08Y/mwzU+pxT2i5wkrA7QwqCbtVdycjlCadymI+PUQRySM6VN5GgkHSzyB8DG0/DB1OPtuEqJxCCRkt3tRMgpNcOBddK8bcOUWsKAgUPKgSv5aSehWIAQgQUNP5dEeFzjCaYRmR33hchjIDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcM4UEPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcM4UEPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EAAC4CECD;
	Tue, 12 Nov 2024 10:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408246;
	bh=v7mv32BJKJECU66bFwq4qy4NykUKdL+Sm8riekILCok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcM4UEPRm0wbFV7yITm0WRk3ojk5LPZRDX54RSCa5kAmiuYIhEjVvvObiwpgYA9Hh
	 p/VpTHGY+aVMJm+GGI/rkxsGW+m2tX40MHkO7ytfP5thBWgHyhYA6Zsb1/Y/4y95Im
	 dfylh79SiJSw+W7aIBMJjSODidd2hRAjQLFekh6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.11 105/184] drm/panthor: Lock XArray when getting entries for the VM
Date: Tue, 12 Nov 2024 11:21:03 +0100
Message-ID: <20241112101904.897642181@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liviu Dudau <liviu.dudau@arm.com>

commit 444fa5b100e5c90550d6bccfe4476efb0391b3ca upstream.

Similar to commit cac075706f29 ("drm/panthor: Fix race when converting
group handle to group object") we need to use the XArray's internal
locking when retrieving a vm pointer from there.

v2: Removed part of the patch that was trying to protect fetching
the heap pointer from XArray, as that operation is protected by
the @pool->lock.

Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Reported-by: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241106185806.389089-1-liviu.dudau@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1580,7 +1580,9 @@ panthor_vm_pool_get_vm(struct panthor_vm
 {
 	struct panthor_vm *vm;
 
+	xa_lock(&pool->xa);
 	vm = panthor_vm_get(xa_load(&pool->xa, handle));
+	xa_unlock(&pool->xa);
 
 	return vm;
 }


