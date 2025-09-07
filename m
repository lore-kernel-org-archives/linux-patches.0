Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E717BB21;
	Sun,  7 Sep 2025 20:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276753; cv=none; b=h1nIt5TmUjOb22fz+nDQi37NfOBtKS33v6fPJ06kM98+yZjYAp0bKTJ1iOd5Ij0/tfv6QzGo8jvAFZvU3vCtm98wZZ264ERATbbHM8YV1ZD/6lNMURUOEeqC/VyUOPmgWNKGAFHwtx8th20BjTZ8CaY9am9nPxmYYVp3lqQ/CUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276753; c=relaxed/simple;
	bh=Q7WNN4uOZaLrOebfxy3J6VQ6aeGMaNKNu2Tk9qM/QgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ9DuSeVlP9mkUPmM5hHmUJ3WCoZXpMwqGW/aJVe9p7YIu9Q2w5mVPP/DNHrWskeKYXHjLuokw95E8mS8TuDC9+W3SwS2ta5ZqSmEd0YkoX26BRThqKr5WAUGQTXizZngn8O1BLMSJ7PztUkzPfhQ2JFYKlFZuNMYhM+Baz80TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2MetIgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2MetIgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BE4C4CEF0;
	Sun,  7 Sep 2025 20:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276753;
	bh=Q7WNN4uOZaLrOebfxy3J6VQ6aeGMaNKNu2Tk9qM/QgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2MetIgx77HXeqAN6OR+IvQSxCSDYadsRmGOcuFgS8o8bFTa+gqKxOV8PTeT1ssq+
	 h3VxQ7q/AxZPt4WEN3ScPUTzQZMvZY4GJBeJmRl+H3lWOV3MDLDedxrpocbDoFzy9r
	 ofSqDGRz9T/uXzNPi4OxR7Q0XDbCPHud0xtpL5Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 052/121] ACPI/IORT: Fix memory leak in iort_rmr_alloc_sids()
Date: Sun,  7 Sep 2025 21:58:08 +0200
Message-ID: <20250907195611.162946149@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit f3ef7110924b897f4b79db9f7ac75d319ec09c4a upstream.

If krealloc_array() fails in iort_rmr_alloc_sids(), the function returns
NULL but does not free the original 'sids' allocation. This results in a
memory leak since the caller overwrites the original pointer with the
NULL return value.

Fixes: 491cf4a6735a ("ACPI/IORT: Add support to retrieve IORT RMR reserved regions")
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/20250828112243.61460-1-linmq006@gmail.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/arm64/iort.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -937,8 +937,10 @@ static u32 *iort_rmr_alloc_sids(u32 *sid
 
 	new_sids = krealloc_array(sids, count + new_count,
 				  sizeof(*new_sids), GFP_KERNEL);
-	if (!new_sids)
+	if (!new_sids) {
+		kfree(sids);
 		return NULL;
+	}
 
 	for (i = count; i < total_count; i++)
 		new_sids[i] = id_start++;


