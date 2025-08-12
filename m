Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506EE2E285E;
	Tue, 12 Aug 2025 18:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023639; cv=none; b=sF+3APcj0nx6m4AHk5iwS/mvsyjtSfRelBJ3VxG4UBmnh1ppfK1OA+EwtgezacEZ9mGEKnS656LEyj8HP/Xs68cLhVgLjLWQ/Wnmxfcc9cCFmt2XBAXY9rWpLizjxOScUl2FIKXvh3ZI96yr8XJiGpvTIvt6FUdV/cVtqAwY5P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023639; c=relaxed/simple;
	bh=SFn08QXjO1aGucCCDI9QlDRNfkJ3k9EbJbfNGP71YH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9RQcteNM2gi80sSBE0yxzvSHd5jJe2agZenF9XoDM4rtxQMAOn6qyxbj4oxLlT6rAtUMLoebK1xhiNaLu1IjwP4+yXubMJn5NHeMkDvOa3eF1mll2CTO8MxtBzVPfoK0vq1rG3DCwAou71mtwQgR6MHG/yUYfuM/w2boTSTrQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FA28o1t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FA28o1t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF52BC4CEF6;
	Tue, 12 Aug 2025 18:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023639;
	bh=SFn08QXjO1aGucCCDI9QlDRNfkJ3k9EbJbfNGP71YH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FA28o1t7Di1ajgvXptOCL9Wkwad6JLXhtx0jq3hCg3KtmWGftM6CBWO2LmCJPqY0a
	 1Vj8C6qMjkMPHwvMMK644doBc+t1rjs49q5SWZyXF/+KepjAAMEjLn+85S3byLG/vz
	 yq6C1CB3bYjGt5DwIygKNW2puDa431h9h2VQ3nSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 095/627] staging: gpib: Fix error code in board_type_ioctl()
Date: Tue, 12 Aug 2025 19:26:30 +0200
Message-ID: <20250812173422.934617022@linuxfoundation.org>
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
index 93ef5f6ce249..4cb2683caf99 100644
--- a/drivers/staging/gpib/common/gpib_os.c
+++ b/drivers/staging/gpib/common/gpib_os.c
@@ -831,7 +831,7 @@ static int board_type_ioctl(struct gpib_file_private *file_priv,
 	retval = copy_from_user(&cmd, (void __user *)arg,
 				sizeof(struct gpib_board_type_ioctl));
 	if (retval)
-		return retval;
+		return -EFAULT;
 
 	for (list_ptr = registered_drivers.next; list_ptr != &registered_drivers;
 	     list_ptr = list_ptr->next) {
-- 
2.39.5



