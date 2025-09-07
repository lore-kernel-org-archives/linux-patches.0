Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0BA1D88D0;
	Sun,  7 Sep 2025 20:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276359; cv=none; b=us3q94gaaywMQ4iy2lCmuTbzcNmvndzGny0zGyEGVf3vU0djOy2NOCCanWjYDIP6bbjHOqD3WBp7/UKdOzS/S+Wl6SHQLySg7VRHaEpByRTECPLTd9/airJR/s0CE4dl9hNZXz3CHQZD/kG+C/IZbPFF4nBaXp1mRHhLT6ZTiB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276359; c=relaxed/simple;
	bh=4+uGD51F76N8QcijdU94gFNKQqfQMr+Jaw8OWr42t1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqlGs1YxIoAgRiwNvr2/01U8N9+qyUUFD5VWE7l1/encqsoChvi1GznwDBWM3x1AIvES3qPfEPBKUq4G1mJLbqpjwsqmNG/PayYc1TeBUq+TQ0OjSgKoMYtUX03S6qTAlbjLo2mYh0lu0bLUlsR3pa98HtorVzeSaoNSe+wwOoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Mb3xY3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Mb3xY3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5070DC4CEF0;
	Sun,  7 Sep 2025 20:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276356;
	bh=4+uGD51F76N8QcijdU94gFNKQqfQMr+Jaw8OWr42t1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Mb3xY3KVzNHog3zWvhhPQlul7T836uJqogJx90/wgzUT4154/ekThvZqlbnyjSbc
	 iG/CgEG5xUcUGMpwzfzrO6qR2ts59qlNrggH1Gp0/uzMSyYtdHvCJA+dqwg/1BGiHK
	 E5ceTYiJbhTFlYQvaLQ9PSpP+8Jko2MNxCrB1QkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/104] pcmcia: Add error handling for add_interval() in do_validate_mem()
Date: Sun,  7 Sep 2025 21:58:37 +0200
Message-ID: <20250907195609.750434061@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 4a81f78caa53e0633cf311ca1526377d9bff7479 ]

In the do_validate_mem(), the call to add_interval() does not
handle errors. If kmalloc() fails in add_interval(), it could
result in a null pointer being inserted into the linked list,
leading to illegal memory access when sub_interval() is called
next.

This patch adds an error handling for the add_interval(). If
add_interval() returns an error, the function will return early
with the error code.

Fixes: 7b4884ca8853 ("pcmcia: validate late-added resources")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/rsrc_nonstatic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 8bda75990bce5..0a4e439d46094 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -375,7 +375,9 @@ static int do_validate_mem(struct pcmcia_socket *s,
 
 	if (validate && !s->fake_cis) {
 		/* move it to the validated data set */
-		add_interval(&s_data->mem_db_valid, base, size);
+		ret = add_interval(&s_data->mem_db_valid, base, size);
+		if (ret)
+			return ret;
 		sub_interval(&s_data->mem_db, base, size);
 	}
 
-- 
2.51.0



