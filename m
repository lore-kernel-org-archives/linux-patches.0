Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6174A1D2784;
	Wed,  6 Nov 2024 12:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896144; cv=none; b=YEJ2e/XEgwZk+GD/02FJUtuVg6ppvTSABV6OMY2oIGhO0jejRiiK0S/M/Qjjcbhax4obYrDTI9wp8ni/X55qrJNcybgIZDiAJWQ3+AiA3Thx1dh1zHySqKsZtC+W5O0lYhHj1qNmWAZILsgBjNyZ9RsSe86htP35MBAAVtjPHoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896144; c=relaxed/simple;
	bh=Cld8LoD6Eo+h4g6oqX8OKs+8FDIoJyPoZWRjsEcnQf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjB3IQQyKVWKc0PiJzgWVZKs/IMGzA25ePmYJK+pvERZuVIdIYB//Wcmj2vRrLkdGu3DZqD8MUIatKlFa/pCvfhbSc/X5Y4btzBXaSwBGcD0QfXxSSXb5q6U6hzTn99O6FZ40aFEgSVAD33+eDP2QOjvcD7fJq1GHVJG8Gl28fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHwR6c2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHwR6c2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC418C4CED3;
	Wed,  6 Nov 2024 12:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896144;
	bh=Cld8LoD6Eo+h4g6oqX8OKs+8FDIoJyPoZWRjsEcnQf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHwR6c2roJBv8oSAAI2EMC9F3M10KyFWL/diLamcn+v2/2Y8PKW91P4JkBD1ClNTG
	 e8iXquGtnwuPO0izCNPV4rXKsmcBS5Sopyts1yTIiy9w/t9bNYCQPFhx3MFKmYbnk8
	 IOkif7corYjE3EbpaiH8C08IhlbmdhxivCGO2RrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 104/245] rpcrdma: Always release the rpcrdma_devices xa_array
Date: Wed,  6 Nov 2024 13:02:37 +0100
Message-ID: <20241106120321.776410872@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 63a81588cd2025e75fbaf30b65930b76825c456f ]

Dai pointed out that the xa_init_flags() in rpcrdma_add_one() needs
to have a matching xa_destroy() in rpcrdma_remove_one() to release
underlying memory that the xarray might have accrued during
operation.

Reported-by: Dai Ngo <dai.ngo@oracle.com>
Fixes: 7e86845a0346 ("rpcrdma: Implement generic device removal")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/ib_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/ib_client.c b/net/sunrpc/xprtrdma/ib_client.c
index 8507cd4d89217..28c68b5f68238 100644
--- a/net/sunrpc/xprtrdma/ib_client.c
+++ b/net/sunrpc/xprtrdma/ib_client.c
@@ -153,6 +153,7 @@ static void rpcrdma_remove_one(struct ib_device *device,
 	}
 
 	trace_rpcrdma_client_remove_one_done(device);
+	xa_destroy(&rd->rd_xa);
 	kfree(rd);
 }
 
-- 
2.43.0



