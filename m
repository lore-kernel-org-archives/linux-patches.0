Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED561253326;
	Tue, 29 Apr 2025 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947827; cv=none; b=gc5esEa/RsEdOVuvtQVRsj61CLewV6+Mp+LYovaGC88Vdja3TbxiA4rxxwdrzCfbozVj6uaHSAVtZCrKQ2K5c9QEXwOYkTcuPdFQOOJx/OlTGAWB2aiVYrL+4Upwi8xulVWsanLUNmJmlLCmvb+GciKMyw6f/TWyyeif+AjdvnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947827; c=relaxed/simple;
	bh=Bn22ORRGsG1xlob45U2lWlIr0+7q0q/cINw10GZBkXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCZ2j3rAOyko378Dy8yqx2OC6YUZiOCjzdGd5i+GtDNgTTkTRzJixEhBSxKgDiU1Sa2Q6SvgW9tZKG5Qcln9hIKXpzw5ZtX3FtI9fImn2hRwQ9kUV9kBHJnVGsiNXjBjuj4XT0qdiRU6sElmoNzhTmyLvXybOy9NiXPo4y9sfm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpvY1xmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpvY1xmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25535C4CEE9;
	Tue, 29 Apr 2025 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947826;
	bh=Bn22ORRGsG1xlob45U2lWlIr0+7q0q/cINw10GZBkXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpvY1xmZ+6j69HdgGo/4LreSOe9PFgNYfRL+icD8iL62UD4+aHdy2YCEMMCwVxKk9
	 sNe3ImuGqym/iSOvTNH47fM2dxI9pE9wB3/STht0AvN3lARWkuxZmMayUQ4KqhLTSX
	 rMQ6u7p8nM8n9kJO0Fkj5kSUHklPyj+HnIJd6YmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 6.12 115/280] mcb: fix a double free bug in chameleon_parse_gdd()
Date: Tue, 29 Apr 2025 18:40:56 +0200
Message-ID: <20250429161119.817753256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 7c7f1bfdb2249f854a736d9b79778c7e5a29a150 upstream.

In chameleon_parse_gdd(), if mcb_device_register() fails, 'mdev'
would be released in mcb_device_register() via put_device().
Thus, goto 'err' label and free 'mdev' again causes a double free.
Just return if mcb_device_register() fails.

Fixes: 3764e82e5150 ("drivers: Introduce MEN Chameleon Bus")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/6201d09e2975ae5789879f79a6de4c38de9edd4a.1741596225.git.jth@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -96,7 +96,7 @@ static int chameleon_parse_gdd(struct mc
 
 	ret = mcb_device_register(bus, mdev);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	return 0;
 


