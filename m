Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43966279DB6;
	Tue, 12 Aug 2025 19:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025548; cv=none; b=VS4/KmZnq1Se6qkkC7meuBxFdZlQiID8X5VUbYaFHx3g/FNu8pTbJDjnhH6Uk97cZLd5Otukg0D5lJP4uYQZhu76zsTO5Z6GmX0QCpmKe5PvbTY0v17fE5mXqUvTfZ2tYZ+o3IaxBjT2Iuq9b9TNXQdmv3Y0Qd9NGjI//4W4e2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025548; c=relaxed/simple;
	bh=fUyW9LjPQKpKcmVL8cF5N9xo9gOfR7916YJHmusMj/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2RYFfs5OZG8FzoEMKfxhj5NkMMJ/UALeTLQIk7NAWWAngfRUVCpldEhv+VqRc5LYGE6b3TBzK/8cBNlKe+2ctC0Ip46AuisIlP4EWLB2tUjP+13c36dbsCN0jtVRtsJusJ+6zvsGr07YmIYUS/cLRDHgJH1vrdUo7sAR4sJtMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGmk1efn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGmk1efn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B96CC4CEF0;
	Tue, 12 Aug 2025 19:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025547;
	bh=fUyW9LjPQKpKcmVL8cF5N9xo9gOfR7916YJHmusMj/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGmk1efnv71T5AHqAQRItAWyYZBAk3Fge1EDG/KiP2OqzCP5KKkgAyBuCEIIEy1Ha
	 s6z92j0ihXpccF/JocpV8+wXgOgtusRwNFuHc8W7EiapgJgEkGMpEjTeSZleKX5nx5
	 wKvpYol41FgKUPVEGvxNnyCJrQ464EM1jGRvnofM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 072/480] staging: gpib: Fix error code in board_type_ioctl()
Date: Tue, 12 Aug 2025 19:44:40 +0200
Message-ID: <20250812174400.397882718@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit aa07b790d79226f9bd0731d2c065db2823867cc5 ]

When copy_from_user() fails it return number of bytes it wasn't able to
copy. So the correct return value when copy_from_user() fails is
-EFAULT.

Fixes: 9dde4559e939 ("staging: gpib: Add GPIB common core driver")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20250703064633.1955893-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/common/gpib_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/common/gpib_os.c b/drivers/staging/gpib/common/gpib_os.c
index 8456b97290b8..01a9099a6c16 100644
--- a/drivers/staging/gpib/common/gpib_os.c
+++ b/drivers/staging/gpib/common/gpib_os.c
@@ -819,7 +819,7 @@ static int board_type_ioctl(gpib_file_private_t *file_priv, struct gpib_board *b
 
 	retval = copy_from_user(&cmd, (void __user *)arg, sizeof(board_type_ioctl_t));
 	if (retval)
-		return retval;
+		return -EFAULT;
 
 	for (list_ptr = registered_drivers.next; list_ptr != &registered_drivers;
 	     list_ptr = list_ptr->next) {
-- 
2.39.5



