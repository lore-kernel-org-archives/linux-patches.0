Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8FF1EF38C;
	Tue, 12 Aug 2025 18:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023436; cv=none; b=R9X0ZrtldicIeXK+Q0u2winfTy/BPq98s0vfsYenHAXf2iiekMvLZJNQWulJkLrlLSFipaoJsrb3pbfMEjZGvP54A4T+pe3cUvXI/Ll/nkjGNuvVCTu+IqYEP2TdRcyX/Ct49M1jYNn4TKjqMW/mGSSuRT5KTULTYPABJB91iZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023436; c=relaxed/simple;
	bh=WiYnjwRhQFSQgyeXE2R7GTndw9v1KUuTkh7Z2EsrZF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t66WtDnV9D7IqJrpGkguoSnRzyQSfk69tjrQpvRCnziKEUp6+e7RmTuUXUYEBERco31kguD5vZuYyuQwpW9F54fIxqcVlM+6xX2PC1JhP6OFD9dIgcjYQfKs/BD/yD8xQBzXeJ65A1uZ6XirUHGtD5oQDvVTAa+C/RdFOVwi0GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvZeodtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvZeodtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F585C4CEF0;
	Tue, 12 Aug 2025 18:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023436;
	bh=WiYnjwRhQFSQgyeXE2R7GTndw9v1KUuTkh7Z2EsrZF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvZeodtJ+sTpaAei1P1nf65bE3+yw7NEVrHIPiTA7lAyaj72+I5THeL+NtZsF5OJX
	 Hsc6T6+veiJ6WxTcAIQr2GPowNhraon7R6GXbxQEA9BR8ypecSNDupH6dsdc+hMGBO
	 H+EsO7MhqYc6PlWBsCVM0rivBiN7JwS1vkwlqEDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 079/627] staging: gpib: fix unset padding field copy back to userspace
Date: Tue, 12 Aug 2025 19:26:14 +0200
Message-ID: <20250812173422.313578678@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit a739d3b13bff0dfa1aec679d08c7062131a2a425 ]

The introduction of a padding field in the gpib_board_info_ioctl is
showing up as initialized data on the stack frame being copyied back
to userspace in function board_info_ioctl. The simplest fix is to
initialize the entire struct to zero to ensure all unassigned padding
fields are zero'd before being copied back to userspace.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Fixes: 9dde4559e939 ("staging: gpib: Add GPIB common core driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20250623220958.280424-1-colin.i.king@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/common/gpib_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/common/gpib_os.c b/drivers/staging/gpib/common/gpib_os.c
index a193d64db033..93ef5f6ce249 100644
--- a/drivers/staging/gpib/common/gpib_os.c
+++ b/drivers/staging/gpib/common/gpib_os.c
@@ -1774,7 +1774,7 @@ static int query_board_rsv_ioctl(struct gpib_board *board, unsigned long arg)
 
 static int board_info_ioctl(const struct gpib_board *board, unsigned long arg)
 {
-	struct gpib_board_info_ioctl info;
+	struct gpib_board_info_ioctl info = { };
 	int retval;
 
 	info.pad = board->pad;
-- 
2.39.5



