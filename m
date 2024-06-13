Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E351C32;
	Thu, 13 Jun 2024 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283022; cv=none; b=j2zEcvB+7n3zPuCcYlHZhzAvLf59kBl7xlPOxNCLpDZfL75BjdrThhTPNJwM36x27Qbv9t0Q8NgeAHr6prdj7X52+Hc8GLtS0Aut2FWxGKHWm4kZOv7uH5nbgafzY81ilDRAofj2IHCTZp+cFyY90WHTWsa13oY2Xev3B3Jcsas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283022; c=relaxed/simple;
	bh=BUx3nIs5pZVbcYoTc0OezZkhkPUZ7tA1UC87gE6kBOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ugk6y9nIEeD/UKHm3kWaYPXFLqGm0OUbInYZOJr1ZSv014YxVY97fl/2yCqgJ5ceZhb2O0wMjn7s+VKVxPFiTCj6zXWxcvSGnX78ktx5yOgSxmoHcnqrFgTSPcKr6DCpBsEMrPDCcXS+Zz//S01AWovVuQEBZo55YZbczYToGls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTe8ACAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTe8ACAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F08DC32786;
	Thu, 13 Jun 2024 12:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283022;
	bh=BUx3nIs5pZVbcYoTc0OezZkhkPUZ7tA1UC87gE6kBOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTe8ACAlwddmOulscBNyKPGkABDMiyTCdh87IivlrOJfqBDHQw8bJ/50EUCToybhQ
	 VUmdmsj0C+g77F9EuR+74vpIHpiVoA7kLlNk1ZyPevQd2QH5k++uTtYWq7Jfypuhtq
	 HkAg3fKpWRzQnvq9+AZSwPGb+axFMPmqfHecrGy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 72/85] ext4: set type of ac_groups_linear_remaining to __u32 to avoid overflow
Date: Thu, 13 Jun 2024 13:36:10 +0200
Message-ID: <20240613113216.917047562@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 9a9f3a9842927e4af7ca10c19c94dad83bebd713 upstream.

Now ac_groups_linear_remaining is of type __u16 and s_mb_max_linear_groups
is of type unsigned int, so an overflow occurs when setting a value above
65535 through the mb_max_linear_groups sysfs interface. Therefore, the
type of ac_groups_linear_remaining is set to __u32 to avoid overflow.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240319113325.3110393-8-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -180,8 +180,8 @@ struct ext4_allocation_context {
 
 	__u32 ac_groups_considered;
 	__u32 ac_flags;		/* allocation hints */
+	__u32 ac_groups_linear_remaining;
 	__u16 ac_groups_scanned;
-	__u16 ac_groups_linear_remaining;
 	__u16 ac_found;
 	__u16 ac_tail;
 	__u16 ac_buddy;


