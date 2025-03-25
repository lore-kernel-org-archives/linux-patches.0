Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B79226AABE;
	Tue, 25 Mar 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906197; cv=none; b=Dsjiy24bQnXbKyDhs3T7gOUXJ0LSDivTcivmx7lGRZXiMGqbls7WquBMTNVUwBnwAlz8qR/06TGa60eLratCDrSjpUHJxs7LcOFgTy/piZ3WmQEqI7rh+l8uMjHKGB/Bk5hfyQYc8IBAJYA28r39KVwZGS5HZF0RJCTQVNWuQi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906197; c=relaxed/simple;
	bh=BdSdIj8w9TKsZ2mB5SPAk87anPGrzhi/zDN5SEXMg94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIX6Z09/MjC/NgB5XFSTHLYQJK1d2eeglo9pusCiYFk560jOTJa+LzaO18wtWy1RxltJAI34d/YEQEpQjDGwXi9W1hb+r+ZrdmJsfysEXOj51SkEEbDasE5uGnNbAzVtYUnT9LJ2/bFU4hlOHgdwB+XfO4S4/3EHY40sQICKRG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaSSaXfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaSSaXfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD71C4CEED;
	Tue, 25 Mar 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906197;
	bh=BdSdIj8w9TKsZ2mB5SPAk87anPGrzhi/zDN5SEXMg94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaSSaXfqZNZEIE2uX5UjbbIvkwNlKWJ1rE7PZcf+tBQkaBtVFbbQOmbTQp7eM2bRF
	 GHbkdu9evXvefI892UEWBlXMZn0245bLZUcIsavWWLFRfTWNWVm9kj+026DQ+55HMl
	 zARJqDvMGXHCHZEoDQTAIp6qBggsrpRFARa8/cIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: [PATCH 6.6 38/77] accel/qaic: Fix integer overflow in qaic_validate_req()
Date: Tue, 25 Mar 2025 08:22:33 -0400
Message-ID: <20250325122145.348357978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 67d15c7aa0864dfd82325c7e7e7d8548b5224c7b upstream.

These are u64 variables that come from the user via
qaic_attach_slice_bo_ioctl().  Use check_add_overflow() to ensure that
the math doesn't have an integer wrapping bug.

Cc: stable@vger.kernel.org
Fixes: ff13be830333 ("accel/qaic: Add datapath")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/176388fa-40fe-4cb4-9aeb-2c91c22130bd@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/qaic/qaic_data.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -550,6 +550,7 @@ static bool invalid_sem(struct qaic_sem
 static int qaic_validate_req(struct qaic_device *qdev, struct qaic_attach_slice_entry *slice_ent,
 			     u32 count, u64 total_size)
 {
+	u64 total;
 	int i;
 
 	for (i = 0; i < count; i++) {
@@ -559,7 +560,8 @@ static int qaic_validate_req(struct qaic
 		      invalid_sem(&slice_ent[i].sem2) || invalid_sem(&slice_ent[i].sem3))
 			return -EINVAL;
 
-		if (slice_ent[i].offset + slice_ent[i].size > total_size)
+		if (check_add_overflow(slice_ent[i].offset, slice_ent[i].size, &total) ||
+		    total > total_size)
 			return -EINVAL;
 	}
 


