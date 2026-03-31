Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A873E92A5;
	Tue, 31 Mar 2026 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974462; cv=none; b=gaoNtdreopGi+9tBJHl7eW4iAJ/ffc19t5Orq+vxNtnFJKJK6Y39/fhoOr7DN/DMhLNEmXQiuSCew9nhWd2qXLl/ZLqbePVtMNf+Fb4XKOvtAyogM+XB8lsp3zoFw82zndtMsvDFUmHbAvwe4rQjF9ewHjK9sbX0Fwr0mZr1k3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974462; c=relaxed/simple;
	bh=Td4NrqaL2CcHD1DhkxXanRLMEFfLlEE0Tkfl6WoUVYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eY55xcx3fU9//ZynOf3P8D2I6tlsHa3l7oUwY/KouKiyIwfXaNTH+/egzx/sY6r1LHgfDaPKQocY1MlTj3buVwAFOeo4A8nUn73xqSC9AH4BASdf732zDaZgoFwVVOdTyAYSGU1OmujZxh0xkpbFick3KkSh3mbhFG41wl8wYVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCWSFWaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCWSFWaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE928C19423;
	Tue, 31 Mar 2026 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974462;
	bh=Td4NrqaL2CcHD1DhkxXanRLMEFfLlEE0Tkfl6WoUVYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCWSFWaU+9NlvqGLU+6ImXv6/re3CboNqgx2T0XOuba247j7gAfHUENsmRtK53Syz
	 j2AsIXj8RS21JpQeSD28nzd6fB5zYdkes1AlcQWjJLOwBoglowL9db5Q7cTkvl3/tj
	 da7mu5crzItunmhlqi38Y3F5SOxDAgMqwn2smQXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Buerg <buermarc@googlemail.com>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/175] sysctl: fix uninitialized variable in proc_do_large_bitmap
Date: Tue, 31 Mar 2026 18:21:18 +0200
Message-ID: <20260331161733.223747141@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Buerg <buermarc@googlemail.com>

[ Upstream commit f63a9df7e3f9f842945d292a19d9938924f066f9 ]

proc_do_large_bitmap() does not initialize variable c, which is expected
to be set to a trailing character by proc_get_long().

However, proc_get_long() only sets c when the input buffer contains a
trailing character after the parsed value.

If c is not initialized it may happen to contain a '-'. If this is the
case proc_do_large_bitmap() expects to be able to parse a second part of
the input buffer. If there is no second part an unjustified -EINVAL will
be returned.

Initialize c to 0 to prevent returning -EINVAL on valid input.

Fixes: 9f977fb7ae9d ("sysctl: add proc_do_large_bitmap")
Signed-off-by: Marc Buerg <buermarc@googlemail.com>
Reviewed-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 354a2d294f526..f8f07c0492388 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1374,7 +1374,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = *(unsigned long **) table->data;
 	unsigned long *tmp_bitmap = NULL;
-	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c;
+	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c = 0;
 
 	if (!bitmap || !bitmap_len || !left || (*ppos && !write)) {
 		*lenp = 0;
-- 
2.53.0



