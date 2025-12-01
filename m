Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A475262FE4;
	Mon,  1 Dec 2025 11:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588800; cv=none; b=OLo1spqnAjqADLOxY0gUxMWv1SgXbfy+Zzk8blwDN35Dy/vNZjfC9BwufXDbTri2izFFrxxYWVS1gbzEHHV0fNYgTmtiiEYnE2iWCUf1iQbim01Cwel+azrCMh46Xm1st7lBuIzoYUuabIqJ0fltFL4OmX9peY0FjQsWZnMuypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588800; c=relaxed/simple;
	bh=Hm1vZPmLcJ2L097Bhbb012oN+o/IuyjszyWa8lVgAHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paTfBcIlWlgrK0fHJAQzk4+732wFq93QDf5l9HxQSuhA2yD/t5uyAl2auXMWFtKWAPTHDOhIlsJIeAKHi4MgtIvPs4OWBZqZRU2IZY0qOMy7qmknJT+yR3VrqfqP1ljX9Wt7cM0RiAy786+WS7pUts2fAdbMsSGaocORfTRBa1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY6mQMN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY6mQMN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8760EC113D0;
	Mon,  1 Dec 2025 11:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588799;
	bh=Hm1vZPmLcJ2L097Bhbb012oN+o/IuyjszyWa8lVgAHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mY6mQMN3h/Bo4bj8whBYMDTkGHHtshra/jCLua8JYCN+n9CncqdqCIyvl33veM+f9
	 lVDpEPI+tw5tM9Kdf5snEU/i/wd+Q9ZctyDeSFcHLzJharJYYanT9ZuZgIdffa9xhK
	 mbU2guM6zCaBjJpICProLUYHaAWSO1OghYETSVyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 175/187] net: qede: Initialize qede_ll_ops with designated initializer
Date: Mon,  1 Dec 2025 12:24:43 +0100
Message-ID: <20251201112247.529074585@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 6b3ab7f2cbfaeb6580709cd8ef4d72cfd01bfde4 upstream.

After a recent change [1] in clang's randstruct implementation to
randomize structures that only contain function pointers, there is an
error because qede_ll_ops get randomized but does not use a designated
initializer for the first member:

  drivers/net/ethernet/qlogic/qede/qede_main.c:206:2: error: a randomized struct can only be initialized with a designated initializer
    206 |         {
        |         ^

Explicitly initialize the common member using a designated initializer
to fix the build.

Cc: stable@vger.kernel.org
Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
Link: https://github.com/llvm/llvm-project/commit/04364fb888eea6db9811510607bed4b200bcb082 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20250507-qede-fix-clang-randstruct-v1-1-5ccc15626fba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -216,7 +216,7 @@ static struct pci_driver qede_pci_driver
 };
 
 static struct qed_eth_cb_ops qede_ll_ops = {
-	{
+	.common = {
 #ifdef CONFIG_RFS_ACCEL
 		.arfs_filter_op = qede_arfs_filter_op,
 #endif


