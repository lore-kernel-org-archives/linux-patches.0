Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C8B2D5924;
	Mon, 13 Oct 2025 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368589; cv=none; b=FdOBoiLqvgSx9xFI+iUC7J92/+N4IZrww5cz0dyVHcxrmtpHihMr4e8uVECROq9LnsYiRnssAox52dqd/GdBEQB3gQZJX+VVYCiZsi167+pZD0uaLv7U7Siu1kS2wJBIuMc1qb/Ay3rn1fKqfesuBGTFCLEMFnIq7vd//0cdckE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368589; c=relaxed/simple;
	bh=5JTLJzMQblWjxor6KX3+JnK/59mcEaseGiyU8u6E8SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjAVYFKFVjEUvcLdmp5u9Ig3dSejehXpiVLAnPqS0EjjKzt6enFUPx+4dQbZAlB3VfF5XMGGIuA+AUhRrUJKBgcqV2BvQT3EB//MsgYj0zfMTE1Sjox7L9fXMo4Ip3VzM1/P1Gd2x5TOoxMa3u3P5OP5TOM+kx/1FXr69QOjBZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj3G+Vu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj3G+Vu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558F9C4CEE7;
	Mon, 13 Oct 2025 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368589;
	bh=5JTLJzMQblWjxor6KX3+JnK/59mcEaseGiyU8u6E8SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj3G+Vu12f06tuB6Z3AJ2g1Dp2LuIVDm1T8JiDadZM87ulovh9Mo3SO+Cj7U+rYWJ
	 UUQBbPrrgRZK0g3Gv7TOJahMi3mnKjN5E8qUMs8C1B6oyH8Sb6vM71dGO5fdJoQ3kK
	 c17WTNPpJ8nSQulNjpyupfcIk4OXcgtmM33st7AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/262] dm vdo: return error on corrupted metadata in start_restoring_volume functions
Date: Mon, 13 Oct 2025 16:45:23 +0200
Message-ID: <20251013144332.646025398@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 9ddf6d3fcbe0b96e318da364cf7e6b59cd4cb5a2 ]

The return values of VDO_ASSERT calls that validate metadata are not acted
upon.

Return UDS_CORRUPT_DATA in case of an error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a4eb7e255517 ("dm vdo: implement the volume index")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Reviewed-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/indexer/volume-index.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index 12f954a0c5325..afb062e1f1fb4 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -836,7 +836,7 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 				    "%zu bytes decoded of %zu expected", offset,
 				    sizeof(buffer));
 		if (result != VDO_SUCCESS)
-			result = UDS_CORRUPT_DATA;
+			return UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0) {
 			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
@@ -928,7 +928,7 @@ static int start_restoring_volume_index(struct volume_index *volume_index,
 				    "%zu bytes decoded of %zu expected", offset,
 				    sizeof(buffer));
 		if (result != VDO_SUCCESS)
-			result = UDS_CORRUPT_DATA;
+			return UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
 			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
-- 
2.51.0



