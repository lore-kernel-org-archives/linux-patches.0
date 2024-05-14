Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4030D6CDC4;
	Tue, 14 May 2024 11:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685354; cv=none; b=AMVSWzXhJO4urXL6tlZJdoKmqRXbS321EUhwLVkzHdTnx6cp1sRX7q7o4p4Zav2okh28QcpDLr33yjYSL7CphwHjrog6jbkJhiNNkEx5/Fb3YWL5SDYC9gbblBHTC0l/91Cdhwa2dgpq264VosCW4EaxDxyI+ohhGcsl/lkcrbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685354; c=relaxed/simple;
	bh=vzPZ5Q8tWs5AmL952cd/N7r9rt7XG7GooyTKA9X5Sic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMMm8rxz6iwIIVtFR9/A0rn9hEj9vUlF3pwNwHdJZ7bFGoUE1fhTL5TCuJ5YiGIByKz8L9rrL0DaTJGSt+w4IW64qcX2ij9+f0VG+wj9M77kQPzR2NxJggJwhiG101Jqv0jHOhjqUtVvQMDfYMQPIUymVnR0dM8UcKjFehaJd0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJ1u8ewm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJ1u8ewm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594B6C2BD10;
	Tue, 14 May 2024 11:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685353;
	bh=vzPZ5Q8tWs5AmL952cd/N7r9rt7XG7GooyTKA9X5Sic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJ1u8ewmef2JSsWTbKG/GYlYgJIQmnvdfAbCAnETBAjNY2TXzYkjsV0MIOB9Ykc3F
	 aCQmvMMbA2lnHn2eC3ncZFXvALrjKWITv0vwSpYkoe1zr2v0C0ygbBawTZCxo5xXHr
	 h658zO5Z3qNGRnKTmM50kIZ8PtLSFtToiKtRC7HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/301] qibfs: fix dentry leak
Date: Tue, 14 May 2024 12:17:25 +0200
Message-ID: <20240514101038.826782468@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit aa23317d0268b309bb3f0801ddd0d61813ff5afb ]

simple_recursive_removal() drops the pinning references to all positives
in subtree.  For the cases when its argument has been kept alive by
the pinning alone that's exactly the right thing to do, but here
the argument comes from dcache lookup, that needs to be balanced by
explicit dput().

Fixes: e41d237818598 "qib_fs: switch to simple_recursive_removal()"
Fucked-up-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index ed7d4b02f45a6..11155e0fb8395 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -439,6 +439,7 @@ static int remove_device_files(struct super_block *sb,
 		return PTR_ERR(dir);
 	}
 	simple_recursive_removal(dir, NULL);
+	dput(dir);
 	return 0;
 }
 
-- 
2.43.0



