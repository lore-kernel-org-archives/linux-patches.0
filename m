Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051D15CDFA;
	Tue, 14 May 2024 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683290; cv=none; b=jg0VaELE5JBYuAhIzZqhESpyJrX42gmLmZBebCEOW3+bD5F0CQYzXH1BuEqOY8hAZVwCk4h8bS5P8ltqJhCDz3IgtzIwnec6kJOAuPl1yDR4mbkswbl/KRFxl//IFqllSFFE6aWxH4J29R1HESDCYNIpv/w6IiH7kNZwHaLeYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683290; c=relaxed/simple;
	bh=lKJf40iKQSJzVbKfMyS6hlqf86AASP0bMnKC8lHWKpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9I90+bOeY5m+TUJfgK2gJg5EgzReuDCe5xBMFW9bK/SLpWR/TV/vcdzbHUVCCb2uebteReE9EaY8jEPRwrPKGSLuaxuYLueYScAnfANLmNkZ8qUeDaZbGmhAYK/BMzDjgFbE6YHF4Tawi//nGi6IbkXAXjWgaRxSDsghTlimIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAma9LgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAma9LgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410ABC2BD10;
	Tue, 14 May 2024 10:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683289;
	bh=lKJf40iKQSJzVbKfMyS6hlqf86AASP0bMnKC8lHWKpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAma9LgN6ElTul63KTmlP6ACIdj9kXmijTuEJFwSyScMTm9jQnGj21bafSLXs6Vaw
	 FK3pVd7jDWCjgY+DaWrvEiO1P68tk5CN5INPEIMo7pD4QH6MtVBe7pQcb19tXFyN2R
	 UWdgrEXZcaREM60QRW3w7KwTPCKf0kvqwR74KO4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 195/336] qibfs: fix dentry leak
Date: Tue, 14 May 2024 12:16:39 +0200
Message-ID: <20240514101045.968261203@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 455e966eeff39..b27791029fa93 100644
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



