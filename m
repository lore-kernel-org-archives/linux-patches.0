Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E2A15ADB4;
	Wed,  3 Dec 2025 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776627; cv=none; b=r/TQfzQxFbrf4m5kaw9y2JHmUG4cmMmoMzQ8tQL2W/5VUcABXwbqocvdrCKIPCKSa6bBzBOTfsRwXw00i1qbKBg1uO6x6z3TDAY+WesaZg5K7ROKUyn9vglP7f40mlm1501aNwcTperEiPn69VuWO5wOFQVTQLgFZk9reABH6rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776627; c=relaxed/simple;
	bh=pzoExyn3O3fTr9EJnueblI284Gc6EZ5GihRg+yqbUqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APeJga+RtZfRoylN63nw/iPD4m1/UXAeSM0wtSusJY5bRB7EkP0Ovgyhk7h5NkSWPA6Byd3wM9R1IIsdSFsQdJAbtIxjHFNAWSTTnUX/TDa66iIjjZK4S2IC1BKovoH6ARMBoqZVfqCnqFEvs273QY64KVZ6y0PuBtODO7cQMXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOWTm8Vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOWTm8Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24722C4CEF5;
	Wed,  3 Dec 2025 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776627;
	bh=pzoExyn3O3fTr9EJnueblI284Gc6EZ5GihRg+yqbUqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOWTm8Vb9t1DU12WOY8ZjOybKpqKcW71AwOhElTm1b4ktAWI/aDEQbmoGTwH/ULKO
	 JR//MsX4mjgjZ3JI0AbrlbVgU3n0Vf2Uyjwk9UnDfhEInRyvmRWe3e20NkaFtuFTPD
	 RFCCPPetdxyrTSnRbgBCX9otqxGKrAV3trecoHJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 238/300] net: qede: Initialize qede_ll_ops with designated initializer
Date: Wed,  3 Dec 2025 16:27:22 +0100
Message-ID: <20251203152409.442124809@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -199,7 +199,7 @@ static struct pci_driver qede_pci_driver
 };
 
 static struct qed_eth_cb_ops qede_ll_ops = {
-	{
+	.common = {
 #ifdef CONFIG_RFS_ACCEL
 		.arfs_filter_op = qede_arfs_filter_op,
 #endif


