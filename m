Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CC913DBB7;
	Tue, 23 Jan 2024 01:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971989; cv=none; b=TVMIBdZy4RdJDhOKwEm/app2rw+Km/UTKC+f4P5YUdEZhCuF4Nt5IAf7CDDoJJSiACbMejUX/USUWRwqVGApp41TT8412pMhQP3S9IjjY1sp7ECrqMdZ38o8lvXHfC2BKXGcqEhvGi9HndGohUzM4dNLVSZICi7p+dwk2r0BQnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971989; c=relaxed/simple;
	bh=FEQg78K5+bx5Vi1S+XTJZBWzk8EjZhveFo6vdvDRqL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctkgOk419tvGfLL/xWwoinE3xaruFrphqkX6tvK+Az5D+1gKCZ2pyTIqIp3Adn2ubBMEZUAJK/SCgMwfObsP90ldEshCqnKtDU25LMnhXEhfKvgqXgSSUBcP6wKrBXC279V+jL5nQ5Po2LdJgo0EwO1nm5WlASWZER7myiITO8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg0xZ8Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg0xZ8Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41FDC433F1;
	Tue, 23 Jan 2024 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971988;
	bh=FEQg78K5+bx5Vi1S+XTJZBWzk8EjZhveFo6vdvDRqL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg0xZ8ZhanrAvnBNGOtC7fADd8homkOlh/F0CWgKG0eLKTnXG35XeJBmACmeZBV36
	 8FKmylTw4pC8s3sVAL98XwLMwbReVXnhhN/NscfIAmnIRJhBUUDbHLtLXBEg2MR5rg
	 ApRJHsEWMQUPE4fVlKWaO04eXD1m291u26qiSkoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 372/417] nvme: trace: avoid memcpy overflow warning
Date: Mon, 22 Jan 2024 15:59:00 -0800
Message-ID: <20240122235804.701011048@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a7de1dea76cd6a3707707af4ea2f8bc3cdeaeb11 ]

A previous patch introduced a struct_group() in nvme_common_command to help
stringop fortification figure out the length of the fields, but one function
is not currently using them:

In file included from drivers/nvme/target/core.c:7:
In file included from include/linux/string.h:254:
include/linux/fortify-string.h:592:4: error: call to '__read_overflow2_field' declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
                        __read_overflow2_field(q_size_field, size);
                        ^

Change this one to use the correct field name to avoid the warning.

Fixes: 5c629dc9609dc ("nvme: use struct group for generic command dwords")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/trace.h b/drivers/nvme/target/trace.h
index 155334ddc13f..974d99d47f51 100644
--- a/drivers/nvme/target/trace.h
+++ b/drivers/nvme/target/trace.h
@@ -84,7 +84,7 @@ TRACE_EVENT(nvmet_req_init,
 		__entry->flags = cmd->common.flags;
 		__entry->nsid = le32_to_cpu(cmd->common.nsid);
 		__entry->metadata = le64_to_cpu(cmd->common.metadata);
-		memcpy(__entry->cdw10, &cmd->common.cdw10,
+		memcpy(__entry->cdw10, &cmd->common.cdws,
 			sizeof(__entry->cdw10));
 	),
 	TP_printk("nvmet%s: %sqid=%d, cmdid=%u, nsid=%u, flags=%#x, "
-- 
2.43.0



