Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D212DECB0;
	Tue, 11 Nov 2025 01:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825045; cv=none; b=VKRs3qHkH5++X4kfSDHpPc1oom5AxaB4ttkh/C4GtLxKJTlXswnIHZM8h+5a2rUX1+DZdVgF3TF9VuuWByOj0TwGdtYioNpY8txoZ5FUe7OWpnMmKua9Bi5qBscw3sYEmbeofKwojv3AzPBvPkZl+VFuSvMX8D/NqIMTIOOseo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825045; c=relaxed/simple;
	bh=0oFRrTubLnsXkI9wzTMHItsluVvanyHIHKwp2EKq3HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDPxKzR0xAPxLTu6cCtialhoi3QvmIF5uea4FB0RRWqx1tJqcJ2qvkiplzDaJOuc/p2HFP+t7P3Z0aSfd2W4tio9g0AO3xoY9lFNlmcSl8bvDOgFI2Akld+Ri4dEnpM25q2uH3Tg19fzoHytcxa1Zskl3lMqXlhk1XuUxJ0S7aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhSzg5eC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhSzg5eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66FCC4CEFB;
	Tue, 11 Nov 2025 01:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825045;
	bh=0oFRrTubLnsXkI9wzTMHItsluVvanyHIHKwp2EKq3HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhSzg5eCcVDeMqFO1waYlCJFi7uXBbsWZIHzUlGwILjWsKnhbjf1tELvcVcliIVZF
	 GQRx5M0ImzliBR6XGfyeuTr5kLT1T/R0MYhbDOYqP3358FbAsVrXx4UK6T1FCjydHy
	 v+bawFPAlCkaU7rOiwW3XQOWjYfGXoLDcmTuH82Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Tayar <tomer.tayar@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 637/849] accel/habanalabs: return ENOMEM if less than requested pages were pinned
Date: Tue, 11 Nov 2025 09:43:27 +0900
Message-ID: <20251111004551.828716437@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomer Tayar <tomer.tayar@intel.com>

[ Upstream commit 9f5067531c9b79318c4e48a933cb2694f53f3de2 ]

EFAULT is currently returned if less than requested user pages are
pinned. This value means a "bad address" which might be confusing to
the user, as the address of the given user memory is not necessarily
"bad".

Modify the return value to ENOMEM, as "out of memory" is more suitable
in this case.

Signed-off-by: Tomer Tayar <tomer.tayar@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 61472a381904e..48d2d598a3876 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -2332,7 +2332,7 @@ static int get_user_memory(struct hl_device *hdev, u64 addr, u64 size,
 		if (rc < 0)
 			goto destroy_pages;
 		npages = rc;
-		rc = -EFAULT;
+		rc = -ENOMEM;
 		goto put_pages;
 	}
 	userptr->npages = npages;
-- 
2.51.0



