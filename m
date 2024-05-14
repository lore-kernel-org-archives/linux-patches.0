Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6218218026;
	Tue, 14 May 2024 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686459; cv=none; b=UZtF/1O3GM915+KqitQocKu9x4bw6h+h6uF9OEMIPUJ6E0YkTVTWC2Yh5FGdcxjOyfRkhQb0vaIzlYMXWuLki7/vTEaETFEIBeE0JxX2nutHQ4uB9qNJgQqtymGwZu76di5X4ZNzyJqAetCk5ec9Aieowzw7rBgZnCz+FomDNDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686459; c=relaxed/simple;
	bh=uMAJLqwMijo/1MQBWUAZH8l6Z3QGX40Hdxgvd9rNuEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwtSMeY1RZoOO1LTlOqZH265lVgZv2s9cDpHs/loQ2dKK1+uyIle5kKIRNIDPJ4yMozafYJbNFpR2Xq+V+yQd780GEll2XsQh4Vk0h4m/VbHlj9Zzoowb/U40SNjzQJr4D9r8FhC6+jaEthBs3DAlCsToiz371ODYa4Rt5F2p5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EupyhC0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EupyhC0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB371C32782;
	Tue, 14 May 2024 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686459;
	bh=uMAJLqwMijo/1MQBWUAZH8l6Z3QGX40Hdxgvd9rNuEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EupyhC0EFEcVztxvxQbKjr6kKpSAyjtHdXfaWIOPDlaCaGYh043SlIlZMXe5bacmX
	 gDE6l/Eyg5GlWKmisMOB8SqTp0G1hxkqmKv5gh/HsLIvg2LJi44NrKTtK7QxBG3kZT
	 8wapDd+5cymhObYP2JygTe8LpgFzwiLv89i2xOOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/236] qibfs: fix dentry leak
Date: Tue, 14 May 2024 12:18:26 +0200
Message-ID: <20240514101025.835836967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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
index a973905afd132..182a89bb24ef4 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -440,6 +440,7 @@ static int remove_device_files(struct super_block *sb,
 		return PTR_ERR(dir);
 	}
 	simple_recursive_removal(dir, NULL);
+	dput(dir);
 	return 0;
 }
 
-- 
2.43.0



